package com.pixelBender.controller.asset
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.controller.asset.vo.AddPackageToLoadQueueCommandVO;
	import com.pixelBender.model.AssetProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class AddPackageToLoadQueueCommand extends SimpleCommand
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
				commandVO:AddPackageToLoadQueueCommandVO = notification.getBody() as AddPackageToLoadQueueCommandVO;
			// Add package to queue
			assetProxy.addPackageToLoadQueue(commandVO.getPackageName(), commandVO.getIncludeSubPackages());
		}
	}
}