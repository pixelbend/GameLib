package com.pixelBender.view.gameScreen
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.interfaces.IGameScreen;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.model.GameScreenProxy;
	import flash.display.DisplayObjectContainer;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import starling.display.DisplayObjectContainer;

	public class GameScreenMediator extends Mediator implements IGameScreen
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Screen state. 
		 */		
		protected var state																		:int;

		/**
		 * Reference to the game facade
		 */
		protected var gameFacade																:GameFacade;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor
		 * @param mediatorName String
		 */		
		public function GameScreenMediator(mediatorName:String)
		{
			super(mediatorName);
			state = GameConstants.STATE_IDLE;
		}
		
		//==============================================================================================================
		// FINAL API
		//==============================================================================================================
		
		/**
		 * Will set the appropriate state and call prepareForStart()
		 * @param screenContainer DisplayObjectContainer
		 * @param starlingScreenContainer DisplayObjectContainer
		 * @param gameScreenProxy GameScreenProxy
		 */		
		public final function prepareScreenForStart(screenContainer:flash.display.DisplayObjectContainer,
														starlingScreenContainer:starling.display.DisplayObjectContainer,
															gameScreenProxy:GameScreenProxy):void
		{
			// Check state
			AssertHelpers.assertCondition(BitMaskHelpers.isBitActive(state, GameConstants.STATE_LOADING),
											"Cannot prepare for start if previous state is not loading!");
			state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_LOADING, GameConstants.STATE_PREPARING_FOR_START);
			// Default behavior
			Logger.info(this + " preparing for start!");
			// Let the screen prepare for start
			if (this is StarlingGameScreen)
			{
				StarlingGameScreen(this).prepareForStart(starlingScreenContainer, gameScreenProxy);
			}
			else if (this is DualGameScreenMediator)
			{
				DualGameScreenMediator(this).prepareForStart(screenContainer, starlingScreenContainer, gameScreenProxy);
			}
			else if (this is NormalDisplayGameScreen)
			{
				NormalDisplayGameScreen(this).prepareForStart(screenContainer, gameScreenProxy);
			}
			else
			{
				AssertHelpers.assertCondition(false, "Your game screen must extend StarlingGameScreen, " +
															"DualGameScreenMediator or NormalDisplayGameScreen!");
			}
		}
		
		/**
		 * Sets the screen in the appropriate state and call start() 
		 */		
		public final function startScreen():void
		{
			AssertHelpers.assertCondition(BitMaskHelpers.isBitActive(state, GameConstants.STATE_PREPARING_FOR_START),
											"Cannot start if previous state is not preparing for start!");
			state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_PREPARING_FOR_START, GameConstants.STATE_STARTED);
			Logger.info(this + " starting!");
			start();
		}
		
		/**
		 * Sets the screen in the appropriate state and call pause() 
		 */		
		public final function pauseScreen():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED)) return;
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
			Logger.info(this + " pausing!");
			pause();
		}
		
		/**
		 * Sets the screen in the appropriate state and call resume()
		 */		
		public final function resumeScreen():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED)) return;
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
			Logger.info(this + " resuming!");
			resume();
		}

		public final function stopScreen():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED)) return;
			state = GameConstants.STATE_IDLE;
			Logger.info(this + " ending!");
			stop();
		}

		public final function disposeScreen():void
		{
			stopScreen();
			state = GameConstants.STATE_DISPOSED;
			gameFacade = null;
			dispose();
		}

		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Starts loading the game screen 
		 */		
		public function loadScreen():void
		{
			AssertHelpers.assertCondition(BitMaskHelpers.isBitActive(state, GameConstants.STATE_IDLE),
																		"Cannot load is game screen is not idle!");
			Logger.info(this + " loading!");
			state = GameConstants.STATE_LOADING;
			facade.sendNotification(GameConstants.LOAD_GAME_SCREEN, getMediatorName());
		}
		
		/**
		 * Game screen proxy name
		 * @default: game screen name + GameConstants.GAME_SCREEN_PROXY_SUFFIX
		 * @return String 
		 */		
		public function getGameScreenProxyName():String
		{
			return mediatorName + GameConstants.GAME_SCREEN_PROXY_SUFFIX;
		}
		
		/**
		 * Game screen state
		 * @return int 
		 */		
		public function getState():int
		{
			return state;
		}

		//==============================================================================================================
		// IMediator IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Create and register game screen proxy 
		 */		
		override public function onRegister():void
		{
			var screenProxy:GameScreenProxy = createGameScreenProxy();
			AssertHelpers.assertCondition((screenProxy!=null), "Game screen proxy cannot be null!");
			facade.registerProxy(screenProxy);
			gameFacade = facade as GameFacade;
		}
		
		/**
		 * Removes the game proxy 
		 */		
		override public function onRemove():void
		{
			var screenProxy:GameScreenProxy = facade.retrieveProxy(getGameScreenProxyName()) as GameScreenProxy;
			facade.removeProxy(screenProxy.getProxyName());
			screenProxy.dispose();
		}
		
		//==============================================================================================================
		// API THAT MUST BE OVERRIDDEN
		//==============================================================================================================

		public function start():void
		{
			AssertHelpers.assertCondition(false, "Override this!");
		}
		
		public function pause():void
		{
			AssertHelpers.assertCondition(false, "Override this!");
		}
		
		public function resume():void
		{
			AssertHelpers.assertCondition(false, "Override this!");
		}

		public function stop():void
		{
			AssertHelpers.assertCondition(false, "Override this!");
		}
		
		public function dispose():void
		{
			AssertHelpers.assertCondition(false, "Override this!");
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[GameScreen:" + mediatorName + " state:" + state + "]";
		}

		//==============================================================================================================
		// LOCALS THAT MUST BE OVERRIDDEN
		//==============================================================================================================

		/**
		 * The game screen logic XML
		 * @return XML
		 */
		protected function getScreenLogicXML():XML
		{
			AssertHelpers.assertCondition(false, "Override this!");
			return null;
		}

		/**
		 * The game screen assets XML
		 * @return XML
		 */
		protected function getScreenAssetXML():XML
		{
			AssertHelpers.assertCondition(false, "Override this!");
			return null;
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		/**
		 * Create the associated game screen proxy
		 * @return GameScreenProxy 
		 */		
		protected function createGameScreenProxy():GameScreenProxy
		{
			return new GameScreenProxy(getGameScreenProxyName(), mediatorName, getScreenLogicXML(), getScreenAssetXML());
		}

		/**
		 * This is the signal that will trigger game screen start
		 */
		protected function sendReadyToStart():void
		{
			sendNotification(GameConstants.GAME_SCREEN_READY_TO_START, this);
		}

		/**
		 * If the game screen packages has a sounds package (the default sound package name),
		 * 	it will be registered with the SoundProxy
		 */
		protected function registerDefaultPackageSounds():void
		{
			sendNotification(GameConstants.REGISTER_GAME_SCREEN_DEFAULT_PACKAGE_SOUND, getGameScreenProxyName());
		}

		/**
		 * If the game screen packages has a sounds package (the default sound package name),
		 * 	it will be unregistered from the SoundProxy
		 */
		protected function unregisterDefaultPackageSounds():void
		{
			sendNotification(GameConstants.UNREGISTER_GAME_SCREEN_DEFAULT_PACKAGE_SOUND, getGameScreenProxyName());
		}
	}
}