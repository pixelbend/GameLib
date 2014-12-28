package com.pixelBender.controller.sound
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.SoundProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PauseResumeSoundOnChannelCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Will pause/resume (according to the type) a sound through the sound proxy player component
		 * @param notification INotification
		 */		
		override public function execute(notification:INotification):void
		{
			// Internals
			var soundProxy:SoundProxy = facade.retrieveProxy(GameConstants.SOUND_PROXY_NAME) as SoundProxy,
				channelID:int = notification.getBody() as int;
			// Handle
			if (notification.getType() == GameConstants.TYPE_PAUSE_SOUND)
			{
				soundProxy.pauseSoundOnChannel(channelID);
			}
			else
			{
				soundProxy.resumeSoundOnChannel(channelID);
			}
		}
	}
}