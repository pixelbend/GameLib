package com.pixelBender.controller.locale
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.AssetProxy;
	import com.pixelBender.model.LocalizationProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ChangeApplicationLocaleCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Changes the application locale language
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			// Internals
			var newLocale:String = notification.getBody() as String,
				localizationProxy:LocalizationProxy = facade.retrieveProxy(GameConstants.LOCALIZATION_PROXY_NAME) as LocalizationProxy,
				assetProxy:AssetProxy = facade.retrieveProxy(GameConstants.ASSET_PROXY_NAME) as AssetProxy;
			// Change application locale
			assetProxy.setLocale(newLocale);
			localizationProxy.setLocale(newLocale);
			// Notify others
			facade.sendNotification(GameConstants.APPLICATION_LOCALE_CHANGED);
		}
	}
}
