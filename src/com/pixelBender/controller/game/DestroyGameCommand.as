package com.pixelBender.controller.game
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.GameComponentProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class DestroyGameCommand extends SimpleCommand
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
			var gameComponentProxy:GameComponentProxy = facade.retrieveProxy(GameConstants.GAME_COMPONENT_PROXY_NAME) as GameComponentProxy;
			// Log
			Logger.info(this + " executing!");
			// Pause
			gameComponentProxy.disposeComponents();
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function toString():String
		{
			return "[DestroyGameCommand]";
		}
	}
}