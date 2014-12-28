package com.pixelBender.controller.game
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.log.Logger;
	import com.pixelBender.view.gameScreen.GameScreenManagerMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartGameCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Pauses all game components
		 * @param notification INotification
		 */		
		override public function execute(notification:INotification):void
		{
			// Internals
			var gameScreenManager:GameScreenManagerMediator = facade.retrieveMediator(GameConstants.GAME_SCREEN_MANAGER_MEDIATOR_NAME) as GameScreenManagerMediator;
			// Log
			Logger.info(this + " executing!");
			// Pause
			gameScreenManager.start();
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function toString():String
		{
			return "[StartGameCommand]";
		}
	}
}