package com.pixelBender.controller.game
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.constants.GameReflections;
	import com.pixelBender.controller.asset.vo.ParseAndRegisterAssetPackageCommandVO;
	import com.pixelBender.controller.game.component.GameComponent;
	import com.pixelBender.controller.game.vo.InitGameCommandVO;
	import com.pixelBender.controller.gameScreen.vo.ShowGameScreenCommandVO;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.AssetProxy;
	import com.pixelBender.model.GameComponentProxy;
	import com.pixelBender.model.LocalizationProxy;
	import com.pixelBender.model.vo.InitTransitionVO;
	import com.pixelBender.model.vo.ScreenTransitionSequenceVO;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.pool.ObjectPoolManager;
	import com.pixelBender.view.gameScreen.GameScreenManagerMediator;
	import com.pixelBender.view.gameScreen.GameScreenMediator;
	import com.pixelBender.view.popup.PopupManagerMediator;
	import com.pixelBender.view.popup.PopupMediator;
	import com.pixelBender.view.transition.TransitionView;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;

	/**
	 * Initialization game command. Will parse and create the following components:
	 * 		- game components:
	 * 			- SoundProxy
	 * 			- AssetProxy
	 * 			- GameScreenManagerMediator
	 *          - PopupManagerMediator
	 * 			- LocalizationProxy
	 * 			- AssetFileReferenceProxy
	 *      - game screens
	 *      - transition views
	 * 		- transition sequences
	 * 		- popups
	 * This command was kept so bulky (~400 lines Jeez), just so that there will be a single point of entry (and possible failure) on game initialization.
	 */	
	public class InitGameCommand extends SimpleCommand
	{
		
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Will parse all XMLs and create all needed game components.
		 */
		override public function execute(notification:INotification):void
		{
			// Internals
			var time:int = getTimer(),
				initVO:InitGameCommandVO = notification.getBody() as InitGameCommandVO,
				defaultGameLogicXML:XML = initVO.getDefaultLogicXML(),
				specificGameLogic:XML = initVO.getGameLogicXML(),
				specificAssets:XML = initVO.getGameAssetsXML(),
				gameRoot:flash.display.DisplayObjectContainer = initVO.getGameRoot(),
				starlingGameRoot:starling.display.DisplayObjectContainer = initVO.getStarlingGameRoot(),
				gameComponentsDictionary:Dictionary = new Dictionary(),
				gameScreenDictionary:Dictionary = new Dictionary(),
				transitionSequenceDictionary:Dictionary = new Dictionary(),
				transitionViewDictionary:Dictionary = new Dictionary(),
				transitionInitVODictionary:Dictionary = new Dictionary(),
				popupsDictionary:Dictionary = new Dictionary(),
				gameComponentProxy:GameComponentProxy,
				gameComponent:GameComponent,
				gameComponentName:String,
				list:XMLList,
				node:XML;
			// Log
			Logger.info(this + " executing!");
			// Create component dictionary
			GameComponent.setQualifiedClassNameDictionary( getGameComponentQualifiedNameDictionary() );
			// Create reflection dictionary
			populateGameReflectionDictionary(defaultGameLogicXML);
			// Parse specific components
			if (specificGameLogic != null )
			{
				list = specificGameLogic.components.component;
				for each (node in list)
				{
					gameComponent = new GameComponent(String(node.@name), String(node.@type), String(node.@className), gameRoot);
					gameComponentsDictionary[gameComponent.getName()] = gameComponent.validateAndCreate(facade);
				}
			}
			// Parse default components
			list = defaultGameLogicXML.components.component;
			for each (node in list)
			{
				gameComponent = new GameComponent(String(node.@name), String(node.@type), GameReflections.getGameComponentQualifiedClassName(String(node.@name)), gameRoot);
				gameComponentName = gameComponent.getName();
				if (gameComponentsDictionary[gameComponentName] == null)
				{
					// No specific found. Create default.
					gameComponentsDictionary[gameComponentName] = gameComponent.create(facade);
				}
			}
			// Set locale
			assignGameLocale(gameComponentsDictionary, initVO.getLocale());
			// Set component dictionary
			gameComponentProxy = facade.retrieveProxy(GameConstants.GAME_COMPONENT_PROXY_NAME) as GameComponentProxy;
			gameComponentProxy.setGameComponents(gameComponentsDictionary);
			// Create and set component view containers
			createGameViewComponents(gameComponentsDictionary, gameRoot, starlingGameRoot);
			// Parse configurations
			list = specificGameLogic.configurations.configuration;
			for each (node in list)
			{
				parseConfiguration(node, gameComponentsDictionary);				
			}
			// Parse and create screens
			list = specificGameLogic.gameScreens.gameScreen;
			for each (node in list)
			{
				createGameScreen(node, gameScreenDictionary);
			}
			gameComponentProxy.setGameScreens(gameScreenDictionary);
			// Get transition from both and default and specific game logic
			createTransitionViews(defaultGameLogicXML.transitions.transition, transitionViewDictionary, transitionInitVODictionary);
			createTransitionViews(specificGameLogic.transitions.transition, transitionViewDictionary, transitionInitVODictionary);
			gameComponentProxy.setTransitions(transitionViewDictionary);
			gameComponentProxy.setTransitionInitVOs(transitionInitVODictionary);
			// Get transition sequences from both and default and specific game logic
			createTransitionSequences(defaultGameLogicXML.transitionSequences.transitionSequence, transitionViewDictionary, transitionSequenceDictionary);
			createTransitionSequences(specificGameLogic.transitionSequences.transitionSequence, transitionViewDictionary, transitionSequenceDictionary);
			gameComponentProxy.setTransitionSequences(transitionSequenceDictionary);
			// Parse, create and register popup mediators
			createPopups(specificGameLogic.popups.popup, popupsDictionary);
			gameComponentProxy.setPopups(popupsDictionary);
			// Register the global asset packages
			if ( specificAssets != null )
			{
				facade.sendNotification(GameConstants.PARSE_AND_REGISTER_ASSET_PACKAGE, new ParseAndRegisterAssetPackageCommandVO(specificAssets, null, true, true));
			}
			// Debug
			Logger.debug(this + " command took:" + (getTimer()-time) + " ms.");
			// All done. Start the show if it was asked to do so
			if (initVO.getFirstScreenName() != null)
			{
				var pool:ObjectPool = ObjectPoolManager.getInstance().retrievePool(ShowGameScreenCommandVO.NAME),
						noteVO:ShowGameScreenCommandVO = pool.allocate() as ShowGameScreenCommandVO;
				noteVO.initialize(initVO.getFirstScreenName(), initVO.getTransitionSequenceName());
				facade.sendNotification(GameConstants.SHOW_GAME_SCREEN, noteVO);
				pool.release(noteVO);
			}
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function toString():String
		{
			return "[InitGameCommand]";
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Will build the component name -> base qualified class name dictionary
		 * @return Dictionary 
		 * 
		 */		
		private static function getGameComponentQualifiedNameDictionary():Dictionary
		{
			var dictionary:Dictionary = new Dictionary();
			dictionary[GameConstants.GAME_COMPONENT_PROXY_NAME] 			= GameConstants.GAME_COMPONENT_PROXY_QUALIFIED_CLASS_NAME;
			dictionary[GameConstants.ASSET_PROXY_NAME] 					    = GameConstants.ASSET_PROXY_QUALIFIED_CLASS_NAME;
			dictionary[GameConstants.FILE_REFERENCE_PROXY_NAME]				= GameConstants.FILE_REFERENCE_PROXY_QUALIFIED_CLASS_NAME;
			dictionary[GameConstants.SOUND_PROXY_NAME] 					    = GameConstants.SOUND_PROXY_QUALIFIED_CLASS_NAME;
			dictionary[GameConstants.LOCALIZATION_PROXY_NAME]				= GameConstants.LOCALIZATION_PROXY_QUALIFIED_CLASS_NAME;
			dictionary[GameConstants.GAME_SCREEN_MANAGER_MEDIATOR_NAME] 	= GameConstants.GAME_SCREEN_MANAGER_MEDIATOR_QUALIFIED_CLASS_NAME;
			dictionary[GameConstants.POPUP_MANAGER_MEDIATOR_NAME] 			= GameConstants.POPUP_MANAGER_MEDIATOR_QUALIFIED_CLASS_NAME;
			return dictionary;
		}
		
		/**
		 * Will populate the reflection type dictionary in the static GameReflections class. 
		 * @param defaultGameLogicXML XML
		 */		
		private static function populateGameReflectionDictionary(defaultGameLogicXML:XML):void
		{
			// Internals
			var reflections:XMLList = defaultGameLogicXML.reflections.reflection,
				reflection:XML;
			// Parse
			for each (reflection in reflections)
			{
				GameReflections.addReflectionComponent(String(reflection.@type), String(reflection.@name), String(reflection.@className));
			}
		}
		
		//==============================================================================================================
		// GAME COMPONENT CONFIGURATION
		//==============================================================================================================
		
		/**
		 * Will apply function calls to all game components
		 * @param node XML - the configuration XML
		 * @param componentDictionary Dictionary - all the created components in dictionary form
		 */		
		private function parseConfiguration(node:XML, componentDictionary:Dictionary):void
		{
			// Internals
			var configurationCallNodes:XMLList = node.children(),
				configurationObject:Object = componentDictionary[String(node.@name)],
				configurationCallNode:XML,
				configurationCall:Function;
			// Start calling
			for each (configurationCallNode in configurationCallNodes)
			{
				configurationCall = configurationObject[String(configurationCallNode.name())];
				if (configurationCall != null)
				{
					configurationCall.apply(this, [String(configurationCallNode.@value)]);
				}
			}
		}
		
		//==============================================================================================================
		// GAME SCREENS
		//==============================================================================================================
		
		/**
		 * Will create game screens
		 * @param addToDictionary Dictionary
		 * @param node XML
		 */
		private function createGameScreen(node:XML, addToDictionary:Dictionary):void
		{
			// Internals
			var cls:Class = ApplicationDomain.currentDomain.getDefinition(String(node.@className)) as Class,
				gameScreen:GameScreenMediator = new cls(String(node.@name));
			// Check inheritance
			AssertHelpers.assertCondition(gameScreen!=null, "Class["+String(node.@className)+"] is not an extension of GameScreenMediator!");
			// Register game screen
			facade.registerMediator(gameScreen);
			addToDictionary[gameScreen.getMediatorName()] = gameScreen;
		}
		
		//==============================================================================================================
		// TRANSITION VIEWS
		//==============================================================================================================
		
		/**
		 * Create transition views from list
		 * @param transitionList XMLList
		 * @param transitionViewDictionary Dictionary
		 * @param transitionInitVODictionary Dictionary
		 */		
		private static function createTransitionViews(transitionList:XMLList, transitionViewDictionary:Dictionary, transitionInitVODictionary:Dictionary):void
		{
			// Internals
			var node:XML;
			// Parse and create
			for each (node in transitionList)
			{
				createTransitionView(node, transitionViewDictionary);
				createTransitionInitVO(node, transitionInitVODictionary);
			}
		}
		
		/**
		 * Create transition from XML node using reflection 
		 * @param node XML
		 * @param addToDictionary Dictionary
		 */		
		private static function createTransitionView(node:XML, addToDictionary:Dictionary):void
		{
			// Internals
			var classInstance:Class = ApplicationDomain.currentDomain.getDefinition(String(node.@className)) as Class,
				transitionName:String = String(node.@name),
				transitionView:TransitionView = new classInstance(transitionName);
			// Check inheritance
			AssertHelpers.assertCondition(transitionView!=null, "Class["+String(node.@className)+"] is not an extension of TransitionView!");
			// Add to dictionary
			addToDictionary[transitionName] = transitionView;
		}
		
		/**
		 * Will create an init VO for the transition if needed
		 * @param node XML
		 * @param transitionInitVODictionary Dictionary
		 */		
		private static function createTransitionInitVO(node:XML, transitionInitVODictionary:Dictionary):void
		{
			// Internals
			var transitionName:String = String(node.@name),
				initVOAssetName:String = String(node.@lazyInitOnGlobalAssetName);
			// Check if init VO is needed
			if (initVOAssetName.length>0)
			{
				transitionInitVODictionary[transitionName] = new InitTransitionVO(transitionName, initVOAssetName);
			}
		}
		
		//==============================================================================================================
		// TRANSITION SEQUENCES
		//==============================================================================================================
		
		/**
		 * Create transition sequence from list 
		 * @param transitionSequenceList XMLList
		 * @param transitionDictionary Dictionary - needed to retrieve transitions
		 * @param addToDictionary - the sequence dictionary
		 */
		private static function createTransitionSequences(transitionSequenceList:XMLList, transitionDictionary:Dictionary, addToDictionary:Dictionary):void
		{
			// Internals
			var node:XML;
			// Create transitions
			for each (node in transitionSequenceList)
			{
				createTransitionSequence(node, transitionDictionary, addToDictionary);
			}
		}
		
		/**
		 * Create transition sequence from XML.
		 * @param sequenceXML XML
		 * @param transitionDictionary Dictionary - needed to retrieve transitions
		 * @param addToDictionary Dictionary
		 */
		private static function createTransitionSequence(sequenceXML:XML, transitionDictionary:Dictionary, addToDictionary:Dictionary):void
		{
			// Internals
			var sequenceName:String = String(sequenceXML.@name),
				list:XMLList = sequenceXML.transition,
				transitionSequence:ScreenTransitionSequenceVO = new ScreenTransitionSequenceVO(sequenceName),
				transitions:Vector.<TransitionView> = new Vector.<TransitionView>(),
				node:XML;
			// Check sequence length
			AssertHelpers.assertCondition((list.length() == GameConstants.TRANSITION_STATES), "Transition sequence with name["+sequenceName+"] must have exactly GameConsts.TRANSITION_STATES inner sequences!");
			// Parse and add
			for each (node in list)
			{
				transitions.push(transitionDictionary[String(node.@name)]);
			}
			// Set transitions for sequence
			transitionSequence.setTransitionViews(transitions);
			// Add to dictionary
			addToDictionary[sequenceName] = transitionSequence;
		}
		
		//==============================================================================================================
		// POPUPS
		//==============================================================================================================
		
		/**
		 * Will create and register all popups  
		 * @param popupXMLList XMLList
		 * @param popupDictionary Dictionary
		 */		
		private function createPopups(popupXMLList:XMLList, popupDictionary:Dictionary):void
		{
			// Internals
			var node:XML,
				classInstance:Class,
				popupMediator:PopupMediator;
			// Parse
			for each (node in popupXMLList) 
			{
				// Create class
				classInstance = ApplicationDomain.currentDomain.getDefinition(String(node.@className)) as Class;
				popupMediator = new classInstance(String(node.@name));
				// Check inheritance
				AssertHelpers.assertCondition(popupMediator != null, "Class["+String(node.@className)+"] is not an extension of PopupMediator!");
				// Register game screen
				facade.registerMediator(popupMediator);
				popupDictionary[popupMediator.getMediatorName()] = popupMediator;
			}
		}
		
		/**
		 * Will create all needed view component containers:
		 * 		- game screen
		 * 		- transition 
		 * 		- popup
		 * @param gameComponentDictionary Dictionary
		 * @param gameRoot DisplayObjectContainer
		 * @param starlingGameRoot DisplayObjectContainer
		 */
		private static function createGameViewComponents(gameComponentDictionary:Dictionary,
												  			gameRoot:flash.display.DisplayObjectContainer,
																starlingGameRoot:starling.display.DisplayObjectContainer):void
		{
			// Internals
			var gameScreenContainer:flash.display.Sprite = new flash.display.Sprite(),
				screenTransitionContainer:flash.display.Sprite = new flash.display.Sprite(),
				popupContainer:flash.display.Sprite = new flash.display.Sprite(),
				gameScreenManager:GameScreenManagerMediator = gameComponentDictionary[GameConstants.GAME_SCREEN_MANAGER_MEDIATOR_NAME],
				popupManager:PopupManagerMediator = gameComponentDictionary[GameConstants.POPUP_MANAGER_MEDIATOR_NAME],
				starlingScreenContainer:starling.display.Sprite,
				starlingTransitionContainer:starling.display.Sprite,
				starlingPopupContainer:starling.display.Sprite;
			// Layer the containers 
			gameRoot.addChild(gameScreenContainer);
			gameRoot.addChild(screenTransitionContainer);
			gameRoot.addChild(popupContainer);
			// Create starling container if need be
			if (starlingGameRoot != null)
			{
				starlingScreenContainer = new starling.display.Sprite();
				starlingTransitionContainer = new starling.display.Sprite();
				starlingPopupContainer = new starling.display.Sprite();
				starlingGameRoot.addChild(starlingScreenContainer);
				starlingGameRoot.addChild(starlingTransitionContainer);
				starlingGameRoot.addChild(starlingPopupContainer);
			}
			// Set them to the appropriate managers
			gameScreenManager.setViewComponents(gameScreenContainer, starlingScreenContainer, screenTransitionContainer, starlingTransitionContainer);
			popupManager.setPopupContainers(popupContainer, starlingPopupContainer);
		}
		
		//==============================================================================================================
		// LOCALIZATION
		//==============================================================================================================
		
		/**
		 * Assign game locale to all needed components 
		 * @param gameComponentDictionary String
		 * @param locale String
		 */		
		public static function assignGameLocale(gameComponentDictionary:Dictionary, locale:String):void
		{
			AssetProxy(gameComponentDictionary[GameConstants.ASSET_PROXY_NAME]).setLocale(locale);
			LocalizationProxy(gameComponentDictionary[GameConstants.LOCALIZATION_PROXY_NAME]).setLocale(locale);
		}
	}
}