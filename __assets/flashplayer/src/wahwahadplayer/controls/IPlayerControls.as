// Only handle visual display here. Handle any control logic in AdManager.as
package wahwahadplayer.controls
{

    public interface IPlayerControls
    {

        function initialize(displayObj: Object, adManager: Object): void;
		

		function showPlaying(play:Boolean): void;
		function showMuted(mute:Boolean): void;
		function adCompleted(): void;
		function adError(): void;
		function updateCountdown(remaining:Number, duration:Number):void
		
		
    }
}