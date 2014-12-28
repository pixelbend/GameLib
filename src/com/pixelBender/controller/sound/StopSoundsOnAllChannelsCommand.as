package com.pixelBender.controller.sound
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.SoundProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StopSoundsOnAllChannelsCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Will all sounds played through the sound proxy
		 * @param notification INotification
		 */		
		override public function execute(notification:INotification):void
		{
			// Internals
			var soundProxy:SoundProxy = facade.retrieveProxy(GameConstants.SOUND_PROXY_NAME) as SoundProxy;
			// Handle
			soundProxy.stopAllSoundChannels();
		}
	}
}