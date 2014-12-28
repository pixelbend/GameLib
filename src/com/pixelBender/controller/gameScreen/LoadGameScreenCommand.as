package com.pixelBender.controller.gameScreen
{
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.view.gameScreen.GameScreenMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadGameScreenCommand extends SimpleCommand
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
			var gameScreenName:String = notification.getBody() as String,
				gameScreenMediator:GameScreenMediator = facade.retrieveMediator(gameScreenName) as GameScreenMediator,
				gameScreenProxy:GameScreenProxy = facade.retrieveProxy(gameScreenMediator.getGameScreenProxyName()) as GameScreenProxy;
			// Add package to queue
			gameScreenProxy.loadScreenPackage();
		}
	}
}