package com.pixelBender.controller.gameScreen
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RegisterGameScreenDefaultAssetPackageCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Tries to register the default sound package for the given screen
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			var gameScreenProxyName:String = notification.getBody() as String,
				gameScreenProxy:GameScreenProxy = facade.retrieveProxy(gameScreenProxyName) as GameScreenProxy;
			if (gameScreenProxy != null)
			{
				SoundHelpers.registerAssetPackageSounds(gameScreenProxy.getScreenAssetPackageName() +
															GameConstants.DEFAULT_SCREEN_SOUND_PACKAGE_SUFFIX);
			}
		}
	}
}
