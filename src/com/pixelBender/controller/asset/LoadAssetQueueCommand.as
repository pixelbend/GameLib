package com.pixelBender.controller.asset
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.AssetProxy;
	import com.pixelBender.model.component.loader.AssetLoaderComponent;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadAssetQueueCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Will add the given package name to the load queue
		 * @param notification INotification
		 */		
		override public function execute(notification:INotification):void
		{
			// Internals
			var assetProxy:AssetProxy = facade.retrieveProxy(GameConstants.ASSET_PROXY_NAME) as AssetProxy,
				concurrentLoadersCount:uint = notification.getBody() ? int(notification.getBody()) : GameConstants.DEFAULT_CONCURRENT_LOADERS;
			// Add package to queue
			assetProxy.load(concurrentLoadersCount);
		}
	}
}