package com.pixelBender.controller.sound
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.SoundProxy;
	import com.pixelBender.model.vo.sound.RetrieveCurrentPlayingSoundVO;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RetrieveCurrentPlayingSoundCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Will play a sound through the sound proxy player component
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			// Internals
			var soundProxy:SoundProxy = facade.retrieveProxy(GameConstants.SOUND_PROXY_NAME) as SoundProxy,
				noteVO:RetrieveCurrentPlayingSoundVO = notification.getBody() as RetrieveCurrentPlayingSoundVO;
			// Play
			noteVO.setPlayer(soundProxy.getChannelPlayer(noteVO.getChannelID()));
		}
	}
}
