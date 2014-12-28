package com.pixelBender.controller.gameScreen
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.controller.gameScreen.vo.ShowGameScreenCommandVO;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.model.GameComponentProxy;
	import com.pixelBender.model.vo.ScreenTransitionSequenceVO;
	import com.pixelBender.view.gameScreen.GameScreenManagerMediator;
	import com.pixelBender.view.gameScreen.GameScreenMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowGameScreenCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Starts the show new screen procedure invoking the game screen manager.
		 * @param notification INotification
		 */		
		override public function execute(notification:INotification):void
		{
			// Internals
			var commandVO:ShowGameScreenCommandVO = notification.getBody() as ShowGameScreenCommandVO,
				gameScreenName:String = commandVO.getScreenName(),
				transitionSequenceName:String = (commandVO.getTransitionSequenceName() != null ) ? commandVO.getTransitionSequenceName() : GameConstants.DEFAULT_TRANSITION_SEQUENCE_NAME,
				gameComponentProxy:GameComponentProxy = facade.retrieveProxy(GameConstants.GAME_COMPONENT_PROXY_NAME) as GameComponentProxy,
				gameScreenManager:GameScreenManagerMediator = facade.retrieveMediator(GameConstants.GAME_SCREEN_MANAGER_MEDIATOR_NAME) as GameScreenManagerMediator,
				newScreen:GameScreenMediator = gameComponentProxy.getGameScreen(gameScreenName),
				transitionSequence:ScreenTransitionSequenceVO = gameComponentProxy.getScreenTransitionSequence(transitionSequenceName);
			// Check data
			AssertHelpers.assertCondition(newScreen != null, "Game screen identifier[" + gameScreenName + "] given is invalid!");
			AssertHelpers.assertCondition(transitionSequence != null, "Transition sequence identifier[" + transitionSequenceName + "] given is invalid!");
			// Retrieve actual references
			gameScreenManager.showScreen(newScreen, transitionSequence);
		}
	}
}