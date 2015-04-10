package com.pixelBender.view.gameScreen
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.MovieClipHelpers;
	import com.pixelBender.interfaces.IRunnable;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.vo.ScreenTransitionSequenceVO;
	import com.pixelBender.view.transition.TransitionView;
	
	import flash.display.DisplayObjectContainer;
	import flash.system.System;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	import starling.display.DisplayObjectContainer;

	public class GameScreenManagerMediator extends Mediator implements IRunnable
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The transition view component container. On top of the game screen container. 
		 */		
		protected var transitionViewContainer							:flash.display.DisplayObjectContainer;

		/**
		 * The transition view starling component container. On top of the starling game screen container.
		 */
		protected var starlingTransitionViewContainer					:starling.display.DisplayObjectContainer;
		
		/**
		 * The game screen view container 
		 */		
		protected var screenViewContainer								:flash.display.DisplayObjectContainer;

		/**
		 * The starling game screen view container
		 */
		protected var starlingScreenViewContainer						:starling.display.DisplayObjectContainer;
		
		/**
		 * The current active game screen
		 */		
		protected var activeGameScreen									:GameScreenMediator;
		
		/**
		 * The old game screen. Kept until the first phase of the transition is done. 
		 */		
		protected var oldGameScreen										:GameScreenMediator;
		
		/**
		 * The new game screen. Kept until the entire transition process is done. Then it will become the active screen. 
		 */		
		protected var newGameScreen										:GameScreenMediator;
		
		/**
		 * The current transition sequence 
		 */		
		protected var currentTransitionSequence							:ScreenTransitionSequenceVO;
		
		/**
		 * Internal state 
		 */		
		protected var state												:int;
		
		/**
		 * The transition state 
		 */		
		protected var transitionState									:int;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor
		 * @param mediatorName String
		 */		
		public function GameScreenManagerMediator(mediatorName:String)
		{
			super(mediatorName);
			state = GameConstants.STATE_IDLE;
		}
		
		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================
				
		/**
		 * @See inherited doc. 
		 */
		override public function listNotificationInterests():Array
		{
			return [GameConstants.GAME_SCREEN_LOADED, GameConstants.GAME_SCREEN_READY_TO_START];
		}
		
		/**
		 * Notification handler 
		 */
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName()) 
			{
				case GameConstants.GAME_SCREEN_LOADED:
					var gameScreenProxy:GameScreenProxy = facade.retrieveProxy(newGameScreen.getGameScreenProxyName()) as GameScreenProxy;
					newGameScreen.prepareScreenForStart(screenViewContainer, starlingScreenViewContainer, gameScreenProxy);
					break;
				case GameConstants.GAME_SCREEN_READY_TO_START:
					if (newGameScreen == notification.getBody())
					{
						Logger.debug(this + " GameScreenReadyForStart received!");
						currentTransitionSequence.getTransitionAtIndex(transitionState).stopOnNextLoopComplete();
					}
					break;
			}
		}
		
		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Initial start call. Equivalent to game start.  
		 */		
		public function start():void
		{
			state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_IDLE, GameConstants.STATE_STARTED);
			activeGameScreen.startScreen();
		}
		
		/**
		 * Pauses the activeScreen or current transition depending on the state. 
		 */		
		public function pause():void
		{
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_TRANSITIONING))
			{
				currentTransitionSequence.getTransitionAtIndex(transitionState).pause();
			}
			else
			{
				if (activeGameScreen != null)
				{
					activeGameScreen.pauseScreen();
				}
			}
		}
		
		/**
		 * Resumes the activeScreen or current transition depending on the state. 
		 */
		public function resume():void
		{
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
			if ( BitMaskHelpers.isBitActive(state, GameConstants.STATE_TRANSITIONING) )
			{
				currentTransitionSequence.getTransitionAtIndex(transitionState).resume();
			}
			else
			{
				if (activeGameScreen != null)
				{
					activeGameScreen.resumeScreen();
				}
			}
		}
		
		/**
		 * Memory management. 
		 */
		public function dispose():void
		{
			state = GameConstants.STATE_DISPOSED;
			if (starlingScreenViewContainer != null)
			{
				starlingScreenViewContainer.removeChildren();
				starlingScreenViewContainer.removeFromParent(true);
				starlingScreenViewContainer = null;
			}
			if (starlingTransitionViewContainer != null)
			{
				starlingTransitionViewContainer.removeChildren();
				starlingTransitionViewContainer.removeFromParent(true);
				starlingTransitionViewContainer = null;
			}
			if (activeGameScreen != null)
			{
				activeGameScreen.stopScreen();
				activeGameScreen = null;
			}
			MovieClipHelpers.removeFromParent(screenViewContainer);
			screenViewContainer = null;
			MovieClipHelpers.removeFromParent(transitionViewContainer);
			transitionViewContainer = null;
			newGameScreen = null;
			oldGameScreen = null;
			currentTransitionSequence = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Display new screen call. Will start the transition sequence towards the new screen.  
		 * @param newGameScreen GameScreenMediator
		 * @param transitionSequence ScreenTransitionSequenceVO
		 */		
		public function showScreen(newGameScreen:GameScreenMediator, transitionSequence:ScreenTransitionSequenceVO):void
		{
			// Log
			Logger.info(this + "Show screen called. New screen :" + newGameScreen + "]");
			// Check state
			AssertHelpers.assertCondition((!BitMaskHelpers.isBitActive(state, GameConstants.STATE_TRANSITIONING)),
											"Cannot change screen while changing screens. This is not Inception!");
			// Change state
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_TRANSITIONING);
			// advance step will be called and the state will be set right
			transitionState = GameConstants.TRANSITION_STATE_COVER_SCREEN - 1; 
			// Set members
			this.newGameScreen = newGameScreen;
			this.oldGameScreen = activeGameScreen;
			this.activeGameScreen = null;
			this.currentTransitionSequence = transitionSequence;
			// Pause old screen
			if (oldGameScreen != null)
			{
				oldGameScreen.pauseScreen();
			}
			// Start transition
			advanceTransitionPhase();
		}
		
		/**
		 * Sets the two main containers for the game : game screen and transition. The transition container is on top.
		 * @param gameScreenContainer DisplayObjectContainer - game screen container
		 * @param starlingScreenContainer DisplayObjectContainer - starling game screen container
		 * @param transitionContainer DisplayObjectContainer - transition view container
		 * @param starlingTransitionViewContainer DisplayObjectContainer - starling transition view container
		 */		
		public function setViewComponents(gameScreenContainer:flash.display.DisplayObjectContainer,
											starlingScreenContainer:starling.display.DisplayObjectContainer,
										  	transitionContainer:flash.display.DisplayObjectContainer,
											starlingTransitionViewContainer:starling.display.DisplayObjectContainer):void
		{
			this.screenViewContainer = gameScreenContainer;
			this.transitionViewContainer = transitionContainer;
			this.starlingScreenViewContainer = starlingScreenContainer;
			this.starlingTransitionViewContainer = starlingTransitionViewContainer;
		}
		
		public function toString():String
		{
			return "[GameScreenManager state:" + state + " transitionState:" + transitionState + "]";
		}
		
		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================
		
		/**
		 * Transition phase end handler. According to the transition state, the appropriate action will be taken.  
		 */		
		protected function handleTransitionPhaseEnded():void
		{
			// Debug
			Logger.debug(this + " Transition phase[" + transitionState + "] ended!");
			// According to the transition state, compute the next step.
			switch (transitionState) 
			{
				case GameConstants.TRANSITION_STATE_COVER_SCREEN:
					setTimeout(loadNewScreen, 0);
					break;
				case GameConstants.TRANSITION_STATE_LOOP_LOADING:
					// Nothing to do except to advance transition phase.
					break;
				case GameConstants.TRANSITION_STATE_REVEAL_SCREEN:
					// Nothing to do but end the transition process.
					break;
			}
			// Advance phase
			advanceTransitionPhase();
		}
		
		/**
		 * Entire transition sequence ended handler. Will start the new level or signal game ready.  
		 */		
		protected function handleTransitionSequenceEnded():void
		{
			// Clear states
			transitionState = -1;
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_TRANSITIONING);
			// Clear transition members
			activeGameScreen = newGameScreen;
			newGameScreen = null;
			oldGameScreen = null;
			currentTransitionSequence = null;
			// Check state 
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED) )
			{
				// Start current level
				activeGameScreen.startScreen();
			}
			else
			{
				// Signal game ready for start
				(facade as GameFacade).handleGameReadyForStart();
			}
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Kills the current transition view and starts a new one if available. 
		 */
		protected function advanceTransitionPhase():void
		{
			// Internals
			var transitionView:TransitionView;
			// Stop current transition
			removeCurrentTransition();
			// Try start next phase
			transitionState++;
			if (transitionState > GameConstants.TRANSITION_STATE_REVEAL_SCREEN)
			{
				// All done
				handleTransitionSequenceEnded();
				return;
			}
			// Start next transition
			transitionView = currentTransitionSequence.getTransitionAtIndex(transitionState);
			transitionView.addViewComponentParents(transitionViewContainer, starlingTransitionViewContainer);
			transitionView.play(handleTransitionPhaseEnded, (transitionState == GameConstants.TRANSITION_STATE_LOOP_LOADING));
			// Debug
			Logger.debug(this+" Transition phase[" + transitionState + "] started!");
		}
		
		/**
		 * Stops and removes the current transition view from screen. 
		 */		
		protected function removeCurrentTransition():void
		{
			// Internals
			var transitionView:TransitionView = currentTransitionSequence.getTransitionAtIndex(transitionState);
			// Remove old transition
			if (transitionView != null)
			{
				transitionView.stop();
				transitionView.removeViewComponentParents();
			}
		}
		
		/**
		 * Kill the new screen, load the new one and start the looping phase in THAT order,
		 *	that way even if the newScreen == oldScreen, we will still be OK
		 */		
		protected function loadNewScreen():void
		{
			if (oldGameScreen != null) 
			{
				oldGameScreen.stopScreen();
				oldGameScreen = null;
				System.gc();
			}
			newGameScreen.loadScreen();
		}
	}
}