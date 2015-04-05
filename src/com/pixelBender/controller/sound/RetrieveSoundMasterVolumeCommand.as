package com.pixelBender.controller.sound
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.SoundProxy;
	import com.pixelBender.model.vo.sound.RetrieveMasterVolumeVO;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RetrieveSoundMasterVolumeCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Will change the sound proxy master volume
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			var soundProxy:SoundProxy = facade.retrieveProxy(GameConstants.SOUND_PROXY_NAME) as SoundProxy,
				vo:RetrieveMasterVolumeVO = notification.getBody() as RetrieveMasterVolumeVO;
			vo.setMasterVolume(soundProxy.getMasterVolume());
		}
	}
}
