package com.pixelBender.controller.asset
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.AssetProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RetrieveGlobalAssetPackageCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Retrieves the global asset package
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			var assetProxy:AssetProxy = facade.retrieveProxy(GameConstants.ASSET_PROXY_NAME) as AssetProxy;
			notification.setBody(assetProxy.getPackage(assetProxy.getGlobalPackageName()));
		}
	}
}
