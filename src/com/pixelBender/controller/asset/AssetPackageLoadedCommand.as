package com.pixelBender.controller.asset
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.GameComponentProxy;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.asset.AssetPackageVO;
	import com.pixelBender.view.gameScreen.GameScreenMediator;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class AssetPackageLoadedCommand extends SimpleCommand
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
			var completedAssetPackage:AssetPackageVO = notification.getBody() as AssetPackageVO,
				gameComponentProxy:GameComponentProxy = facade.retrieveProxy(GameConstants.GAME_COMPONENT_PROXY_NAME) as GameComponentProxy,
				gameScreens:Dictionary = gameComponentProxy.getGameScreens(),
				gameScreen:GameScreenMediator,
				gameScreenProxy:GameScreenProxy;
			// Parse all game screens and check 
			for each (gameScreen in gameScreens) 
			{
				// Only consider loading game screens
				if (gameScreen.getState() == GameConstants.STATE_LOADING) 
				{
					// Retrieve proxy and let it decide it if the completed package is right
					gameScreenProxy = facade.retrieveProxy(gameScreen.getGameScreenProxyName()) as GameScreenProxy;
					gameScreenProxy.handlePackageLoaded(completedAssetPackage);
				}
			}
		}
	}
}