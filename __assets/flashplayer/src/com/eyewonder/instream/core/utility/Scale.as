/*

Universal Instream Framework
Copyright (c) 2006-2010, Eyewonder, LLC
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
* Neither the name of Eyewonder, LLC nor the
names of contributors may be used to endorse or promote products
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Eyewonder, LLC''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Eyewonder, LLC BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This file should be accompanied with supporting documentation and source code.
If you believe you are missing files or information, please 
contact Eyewonder, LLC (http://www.eyewonder.com)

*/

package com.eyewonder.instream.core.utility{
	import com.eyewonder.instream.core.base.AdContainerParent;
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import flash.display.MovieClip;

	import flash.geom.Rectangle;

	public class Scale {
		private var _instreamFramework:InstreamFrameworkBase;

		private var _holder:AdContainerParent;
		private var _content:MovieClip;

		private var _newVideoDimension:Rectangle;
		private var _positionVPAID:Boolean;

		public function Scale(instreamFramework:InstreamFrameworkBase) {
			_instreamFramework=instreamFramework;

			_holder=_instreamFramework._adContainerParent_mc;
			_content=_instreamFramework._adContainer_mc;
		}

		//all data that is important for scaling is stored into the adModel
		private function get _adModel():Object {
			var adModel:Object = new Object();
			adModel.width=_instreamFramework._adTagWidth;
			adModel.height=_instreamFramework._adTagHeight;
			adModel.alignVertical=_instreamFramework._adTagAlignVertical;
			adModel.alignHorizontal=_instreamFramework._adTagAlignHorizontal;

			return adModel;
		}

		//returns the current values stored in UIFConfig
		//TODO could be made even easier when using config values throughout this scaling code only
		private function get _playerModel():Rectangle {
			return new Rectangle(_instreamFramework.config.x, _instreamFramework.config.y, _instreamFramework.config.width, _instreamFramework.config.height);
		}

		//scales ad movieclip up to all available space in width/height
		public function fitScreen():void {
			if (! isNaN(_adModel.width)&&! isNaN(_adModel.height)) {
				selectScaleMethod();
			}
		}

		public function positionVPAID():void {

			_positionVPAID=true;

			_newVideoDimension=new Rectangle(0,0,_adModel.width,_adModel.height);
			calculatePosition();
			setFinalValues();
		}

		//scales movieclip to hit a certain height of the videoscreen - this is given in percent
		public function fitHeightInPercent(percent:Number):void {
			_newVideoDimension=new Rectangle(0,0,_playerModel.width,_playerModel.height/100*percent);

			calculateFitScreen();

			if (!_instreamFramework._config.scaleVAST && !_instreamFramework._staticAd.staticResource[0].scalable)
			{
				//test if ad is bigger than 20% of screen height
				if (_adModel.height > (_playerModel.height / 5))
				{
					_instreamFramework._debugMessage(2, "[Scale] fitHeightInPercent(): Static Resource Ad height is larger than 20% of screen height. Killing ad. Ad width=" + _adModel.width + " Ad height=" + _adModel.height + " Player video dimensions=Rectangle[x=" + _playerModel.x + ",y=" + _playerModel.y + ",width=" + _playerModel.width + ",height=" + _playerModel.height + "]");
					_instreamFramework._staticAd.errorClose(); //calls ifb.endAd() and the error trackers
				}
				else
				{
						//set original width/height - as no scaling is set
					_newVideoDimension.width = _adModel.width;
					_newVideoDimension.height = _adModel.height;
				}
			}
			
			calculatePosition();

			setFinalValues();
		}

		//formerly known as resizeNotifyEWHelper
		private function selectScaleMethod():void {
			if ( (_instreamFramework.config.scaleEW && _instreamFramework._adFormat == "EW") ||
			 (_instreamFramework.config.scaleVAST && _instreamFramework._adFormat == "VAST") ||
			 (_instreamFramework.config.scaleVAST && _instreamFramework._adFormat == "VAST2")) {
				_newVideoDimension=new Rectangle(_playerModel.x,_playerModel.y,_playerModel.width,_playerModel.height);

				calculateFitScreen();
			} else {
				_newVideoDimension=new Rectangle(0,0,_adModel.width,_adModel.height);
			}

			calculatePosition();

			setFinalValues();
		}

		private function calculateFitScreen():void {
			_instreamFramework._debugMessage(2, " Scaling enabled. Ad tag WxH: ["+_adModel.width+" x "+_adModel.height+"]");


			var scale:Number=1;

			/* letterbox if appropriate */
			if (_adModel.width/_newVideoDimension.width>=_adModel.height/_newVideoDimension.height) {
				/* Constrain by x dimension. Keep width the same, but expand height */
				if (Number(_adModel.width)!=0&&! isNaN(Number(_adModel.width))) {
					scale = (_adModel.height / _adModel.width);
				} else {
					_instreamFramework._debugMessage(2, "[Scale] resizeNotify: Constrain by x. WARNING: _adModel.width is 0. Scale set to 1 to avoid divide by 0 issue");
				}

				_newVideoDimension.height=_newVideoDimension.width*scale;
				_instreamFramework._debugMessage(2, "[Scale] resizeNotify: Constrain by x. Scale="+ scale +" Newsize(WxH)="+ _newVideoDimension.width +"x"+ _newVideoDimension.height);
			} else {
				/* Constrain by y dimension. Keep height the same, but expand width */
				if (Number(_adModel.height)!=0&&! isNaN(Number(_adModel.height))) {
					scale = (_adModel.width / _adModel.height);
				} else {
					_instreamFramework._debugMessage(2, "[Scale] resizeNotify: Constrain by y. WARNING: _adModel.height is 0. Scale set to 1 to avoid divide by 0 issue");
				}

				_newVideoDimension.width=_newVideoDimension.height*scale;
				_instreamFramework._debugMessage(2, "[Scale] resizeNotify: Constrain by y. Scale="+ scale +" Newsize(WxH)="+ _newVideoDimension.width +"x"+ _newVideoDimension.height);
			}
		}

		private function calculatePosition():void {
			var msg1:String="";
			var msg2:String="";

			var playerModelX:Number=0;
			var playerModelY:Number=0;

			if ((! _instreamFramework.config.scaleEW) || (!_instreamFramework.config.scaleVAST)) {
				playerModelX=_playerModel.x;
				playerModelY=_playerModel.y;
			}

			switch (_adModel.alignHorizontal) {
				case "center" :

					_newVideoDimension.x += (_playerModel.width - _newVideoDimension.width)/2 + playerModelX;
					msg1="Center";
					break;

				case "right" :
					_newVideoDimension.x+=_playerModel.width-_newVideoDimension.width+playerModelX;
					msg1="Right";
					break;

				default :
					_newVideoDimension.x=_playerModel.x;
					msg1="Left";
					break;
			}

			switch (_adModel.alignVertical) {
				case "middle" :
					_newVideoDimension.y += (_playerModel.height - _newVideoDimension.height)/2 + + playerModelY;
					msg2="Middle";
					break;

				case "bottom" :
					_newVideoDimension.y+=_playerModel.height-_newVideoDimension.height+playerModelY;
					msg2="Bottom";
					break;

				default :
					_newVideoDimension.y=_playerModel.y;
					msg2="Top";
					break;
			}

			_instreamFramework._debugMessage(2, "[Scale] resizeNotify: halign=" + msg1 + " valign="+msg2);

			adjustInvisibleArea();
		}

		/*
		Some ads have invisible content, which is hidden with a mask for instance.
		NonLinear ads and interactive ads do have this, VAST ads don't - therefore we only apply this for
		non VAST ads.
		 
		It is assumed that _adModel.height and _adModel.width are accurate
		 */
		private function adjustInvisibleArea():void {
			if ((_instreamFramework._adFormat != "VAST") && (_instreamFramework._adFormat != "VAST2")) {
				if (_content != null && _content.height > 0
				  && (Number(_adModel.width) != 0 && !isNaN(Number(_adModel.width)))
				  && (Number(_adModel.height) != 0 && !isNaN(Number(_adModel.height)))) {
					var adjustmentXRatio:Number=_content.width/_adModel.width;
					var adjustmentYRatio:Number=_content.height/_adModel.height;
					_instreamFramework._debugMessage(2, "[Scale] resizeNotify: Adjusting for invisible area in creative. adjustmentXRatio=" + adjustmentXRatio + " adjustmentYRatio="+adjustmentYRatio);

					_newVideoDimension.width=adjustmentXRatio*_newVideoDimension.width;
					_newVideoDimension.height=adjustmentYRatio*_newVideoDimension.height;
				}
			}
		}

		private function setFinalValues():void {
			_holder.x=_newVideoDimension.x;
			_holder.y=_newVideoDimension.y;


			if (_positionVPAID==false) {
				_holder.width=_newVideoDimension.width;
				_holder.height=_newVideoDimension.height;
			} else {
				_positionVPAID=false;
			}

			_instreamFramework._debugMessage(2, "UIF Scale ResizeNotify: Streched ad to WxH [ " + _holder.width + " x " + _holder.height + " ] and moved to ( " + _holder.x + " , " + _holder.y + " )");
		}
	}
}