/*
ImageAdView.as

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



Description
-----------

Does create a image ad and its gui (image background, close-button).

*/

package com.eyewonder.instream.core.model.staticAd 
{
	import com.eyewonder.instream.core.base.InstreamFrameworkBase;
	import com.eyewonder.instream.core.debugger.UIFDebugMessage;
	import com.eyewonder.instream.core.events.UIFControlEvent;
	import com.eyewonder.instream.core.utility.ClickThru;
	import com.eyewonder.instream.core.utility.ImageLoader;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import flash.events.ErrorEvent;
	
	public class ImageAdView
	{
		private var _staticAdModel:StaticAdModel;
		private var _canvas:MovieClip;
		
		private var imageLoader:ImageLoader;
		
		private var BORDER_WIDTH:Number;
		private var BORDER_RADIUS:Number;
		private var BORDER_ALPHA:Number;
		private var BORDER_COLOR:uint;
		
		private var closeButton:MovieClip;
		private var adImage:MovieClip;
		
		private var _adModel:Object;
		
		private var _instreamFramework:InstreamFrameworkBase;
		
		private var _staticAdController:StaticAdController;
		
		//_instreamFramework acts as controller here
		public function ImageAdView(instreamFramework:InstreamFrameworkBase, staticAdController:StaticAdController, staticAdModel:StaticAdModel) 
		{
			_instreamFramework = instreamFramework;
			
			_staticAdController = staticAdController;
			
			_staticAdModel = staticAdModel;
			
			_canvas = _staticAdModel.canvas;
			
			//called when static ad has been found by the parser
			_staticAdModel.addEventListener(Event.CHANGE, loadImage);
			
			//config variables
			BORDER_WIDTH = _staticAdModel.config.guiBorderWidth;
			BORDER_RADIUS = _staticAdModel.config.guiBorderRadius;
			BORDER_COLOR = _staticAdModel.config.countdown_bar_back_color;
			BORDER_ALPHA = _staticAdModel.config.countdown_bar_opacity;
		}
		
		private function loadImage(e:Event):void
		{
			_adModel = _staticAdModel.staticResource[0];
			
			imageLoader = new ImageLoader();
			
			imageLoader.addEventListener(Event.COMPLETE, processAdImage);
			imageLoader.addEventListener(ErrorEvent.ERROR, errorHandler);
			
			_instreamFramework.dispatchUIFEvent( UIFControlEvent.ON_START_PLAY_AD );
			imageLoader.load(_adModel.URL);
		}
		
		private function processAdImage(e:Event):void
		{
			removeLoaderListener();
			
			adImage = new MovieClip();
			adImage.addChild(e.currentTarget.loader);
			
			e.currentTarget.loader.content.smoothing = true;
			
			drawImageContainer();
			
			addToCanvas();
			
			//add ClickThru
			_staticAdModel.canvas.buttonMode = true;
			_staticAdModel.canvas.useHandCursor = true;
			adImage.addEventListener(MouseEvent.CLICK, clickThru);
			
			//close button
			loadCloseButton();
			
			//returns false, if scaling is off and ad is to big
			if (alignCanvas())
			{
			//control ad,close it after a certain time
			_staticAdController.startAdTimer();
			
			_instreamFramework.dispatchUIFEvent( UIFControlEvent.ON_AD_LOAD_COMPLETE );
			_instreamFramework.dispatchUIFEvent( UIFControlEvent.HIDE_CONTROLS );
			_instreamFramework.addEventListener(UIFControlEvent.ON_RESIZE_NOTIFY, resize);
		}
		}
		
		private function removeLoaderListener():void
		{
			imageLoader.removeEventListener(Event.COMPLETE, processAdImage);
			imageLoader.removeEventListener(ErrorEvent.ERROR, errorHandler);
		}
		
		private function drawImageContainer():void
		{
			var bg:MovieClip = new MovieClip();
			bg.graphics.beginFill(BORDER_COLOR);
			bg.graphics.drawRoundRect(0, 0, adImage.width + BORDER_WIDTH, adImage.height + BORDER_WIDTH, BORDER_RADIUS, BORDER_RADIUS);
			bg.graphics.endFill();
			
			bg.alpha = BORDER_ALPHA;
			
			_canvas.addChild(bg);
		}
		
		private function addToCanvas():void
		{
			//neccessary to prevent resizeNotifyEWHelper from stepping out of resizing
			_instreamFramework._adContainerParent_mc._isLoaded = true;
			
			//set "ad is playing" so endAd is doing something
			_instreamFramework._adIsPlaying = true;
			
			_canvas.addChild(adImage);
		}

		private function loadCloseButton():void
		{
			imageLoader = new ImageLoader();
		
			imageLoader.addEventListener(Event.COMPLETE, processCloseButton);
			imageLoader.addEventListener(ErrorEvent.ERROR, processCloseButton);
			
			imageLoader.load(_staticAdModel.config.nonLinearCloseButtonURL);
		}
		
		private function setAdInfo():void
		{
			//center image within given frame
			adImage.x = adImage.y = BORDER_WIDTH / 2;
			
				//there is no alignment specified in the XML, therefore we set the default position
				_instreamFramework._adTagAlignHorizontal = "center";
				_instreamFramework._adTagAlignVertical = "bottom";
				
				_instreamFramework._adTagWidth = adImage.width + BORDER_WIDTH;
				_instreamFramework._adTagHeight = adImage.height + BORDER_WIDTH;
		}
				
		private function alignCanvas():Boolean
		{
			var everythingWentFine: Boolean = true;
			
			setAdInfo();
				
			if ((_adModel.scalable) || (_instreamFramework.config.scaleVAST))
			{
				_instreamFramework.resizeNotify();
			}
			else
			{
				var playerInfo:Object = _instreamFramework.getPlayerInformation();
				
				//as scaling is off, make sure the ad isn't higher than 20% - which is an advice from IAB

				if ( adImage.height > (playerInfo.videoRect.height / 5))
				{
					UIFDebugMessage.getInstance()._debugMessage(2, "Scaling is turned off, and ad height is bigger than 20% of the player height.", "VAST", "ImageAdView");
					
					errorClose();
					
					everythingWentFine = false;
				}
				else
				{
					//no scaling, position only
					_instreamFramework._adContainerParent_mc.x = (playerInfo.videoRect.width - adImage.width - BORDER_WIDTH) / 2;
					_instreamFramework._adContainerParent_mc.y = playerInfo.videoRect.height - adImage.height - BORDER_WIDTH;
				}
			}
			
			return everythingWentFine;
		}
		
		private function errorHandler(e:Event):void
		{
			removeLoaderListener();
			
			UIFDebugMessage.getInstance()._debugMessage(2, "Error occoured while loading NonLinear VAST ad", "VAST", "ImageAdView");
		
			errorClose();
		}
		
		private function processCloseButton(e:Event):void
		{
			imageLoader.removeEventListener(Event.COMPLETE, processCloseButton);
			imageLoader.removeEventListener(ErrorEvent.ERROR, processCloseButton);
			
			closeButton = new MovieClip();
			
			if (e.currentTarget.loader.content == null)
			{
				//close button graphic has been omitted, or could not be loaded
				closeButton.graphics.beginFill(0xff0000);
				closeButton.graphics.drawRect(0, 0, 40, 15);
				closeButton.graphics.endFill();
			}
			else
			{
				closeButton.addChild(e.currentTarget.loader);
			}
			
			closeButton.visible = false;
			
			//add
			_canvas.addChild(closeButton);
			
			//Listener
			_canvas.addEventListener(MouseEvent.MOUSE_OVER, toggleCloseButton);
			_canvas.addEventListener(MouseEvent.MOUSE_OUT, toggleCloseButton);
			
			closeButton.addEventListener(MouseEvent.CLICK, close);
			
			positionCloseButton();
		}
		
		/*
			Function: positionCloseButton
			
			Aligns the close button to the upper, right corner outside of the ad.
		*/
		private function positionCloseButton():void
		{
			var position:Object = _staticAdModel.config.nonLinearCloseButtonPosition;
			
			if (!isNaN(position.top))
			{
				closeButton.y = position.top;
			}
			
			if (!isNaN(position.right))
			{
				closeButton.x = _canvas.width - closeButton.width - position.right;
			}
			
			if (!isNaN(position.bottom))
			{
				closeButton.y = _canvas.height - closeButton.height - position.bottom;
			}

			if (!isNaN(position.left))
			{
				closeButton.x = position.left;
			}
		}
		
		public function resize(event:Event):void
		{
			alignCanvas();
		}
		
		private function toggleCloseButton(e:Event):void
		{
			closeButton.visible = !closeButton.visible;
		}
		
		private function clickThru(e:Event):void
		{
			var _clickThru:ClickThru = new ClickThru(_instreamFramework._cacheBuster, _adModel.nonLinearClickThrough );
			
			_clickThru.onClickThru(e);
			
			//track
			_staticAdController.trackClickThru();
		}
		
		private function removeListeners():void {
			//remove the event listeners
			_instreamFramework.removeEventListener(UIFControlEvent.ON_RESIZE_NOTIFY, resize);
			
			if (closeButton)
			{
			closeButton.removeEventListener(MouseEvent.CLICK, close);
			}
			
			if (_canvas)
			{
			_canvas.removeEventListener(MouseEvent.MOUSE_OVER, toggleCloseButton);
			_canvas.removeEventListener(MouseEvent.MOUSE_OUT, toggleCloseButton);
			}
		}
		
		//normal close, by the close button
		private function close(e:Event):void
		{
			removeListeners();
			
			_staticAdController.trackUserClose();
			
			_staticAdController.closeAd();
		}
		
		//this is called either by 
		// * scale class (scaling off, ad to big) - through StaticAdModel
		// * ad image wasn't found (this class)
		public function errorClose():void {
			removeListeners();
			
			_staticAdController.closeAd(true);
		}
	}
}