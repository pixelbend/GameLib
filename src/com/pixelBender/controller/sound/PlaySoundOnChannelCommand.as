package com.pixelBender.controller.sound
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.vo.sound.PlaySoundPropertiesVO;
	import com.pixelBender.model.SoundProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PlaySoundOnChannelCommand extends SimpleCommand
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
				soundPlayPropsVO:PlaySoundPropertiesVO = notification.getBody() as PlaySoundPropertiesVO;
			// Play
			soundProxy.playSoundOnChannel(soundPlayPropsVO);
		}
	}
}