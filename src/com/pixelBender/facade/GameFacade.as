package com.pixelBender.facade
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.constants.GameLinkages;
	import com.pixelBender.controller.asset.AddPackageToLoadQueueCommand;
	import com.pixelBender.controller.asset.AssetPackageLoadedCommand;
	import com.pixelBender.controller.asset.GlobalAssetPackageLoadedCommand;
	import com.pixelBender.controller.asset.LoadAssetQueueCommand;
	import com.pixelBender.controller.asset.ParseAndRegisterAssetPackageCommand;
	import com.pixelBender.controller.asset.RetrieveGlobalAssetPackageCommand;
	import com.pixelBender.controller.fileReference.AddFileReferenceCommand;
	import com.pixelBender.controller.fileReference.LoadFileReferenceCommand;
	import com.pixelBender.controller.fileReference.RemoveFileReferenceCommand;
	import com.pixelBender.controller.fileReference.RemoveFileReferenceContentCommand;
	import com.pixelBender.controller.fileReference.RetrieveFileReferenceContentCommand;
	import com.pixelBender.controller.fileReference.RetrieveFileReferenceExistsCommand;
	import com.pixelBender.controller.fileReference.vo.AddFileReferenceNotificationVO;
	import com.pixelBender.controller.fileReference.vo.FileReferenceExistsNotificationVO;
	import com.pixelBender.controller.fileReference.vo.FileReferenceNotificationVO;
	import com.pixelBender.controller.fileReference.vo.RetrieveFileReferenceContentNotificationVO;
	import com.pixelBender.controller.game.DestroyGameCommand;
	import com.pixelBender.controller.game.InitGameCommand;
	import com.pixelBender.controller.game.PauseGameCommand;
	import com.pixelBender.controller.game.ResumeGameCommand;
	import com.pixelBender.controller.game.StartGameCommand;
	import com.pixelBender.controller.gameScreen.LoadGameScreenCommand;
	import com.pixelBender.controller.gameScreen.RegisterGameScreenDefaultAssetPackageCommand;
	import com.pixelBender.controller.gameScreen.ShowGameScreenCommand;
	import com.pixelBender.controller.gameScreen.UnregisterGameScreenDefaultAssetPackageCommand;
	import com.pixelBender.controller.gameScreen.vo.ShowGameScreenCommandVO;
	import com.pixelBender.controller.locale.ChangeApplicationLocaleCommand;
	import com.pixelBender.controller.popup.OpenPopupCommand;
	import com.pixelBender.controller.sound.PauseResumeSoundOnChannelCommand;
	import com.pixelBender.controller.sound.PlaySoundOnChannelCommand;
	import com.pixelBender.controller.sound.RegisterUnregisterAssetPackageSoundsCommand;
	import com.pixelBender.controller.sound.SetSoundMasterVolumeCommand;
	import com.pixelBender.controller.sound.StopSoundOnChannelCommand;
	import com.pixelBender.controller.sound.StopSoundsOnAllChannelsCommand;
	import com.pixelBender.controller.tween.AddTweenCommand;
	import com.pixelBender.controller.tween.PauseTweenCommand;
	import com.pixelBender.controller.tween.RemoveTweenCommand;
	import com.pixelBender.controller.tween.RemoveTweenForTargetCommand;
	import com.pixelBender.controller.game.vo.InitGameCommandVO;
	import com.pixelBender.controller.tween.ResumeTweenCommand;
	import com.pixelBender.helpers.FileReferenceHelpers;
	import com.pixelBender.helpers.GameHelpers;
	import com.pixelBender.helpers.LocalizationHelpers;
	import com.pixelBender.helpers.PopupHelpers;
	import com.pixelBender.helpers.ScreenHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.helpers.TweenHelpers;
	import com.pixelBender.interfaces.IRunnable;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.component.loader.FileLoader;
	import com.pixelBender.model.component.sound.SoundPlayer;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.model.vo.note.tween.AddTweenNotificationVO;
	import com.pixelBender.model.vo.sound.CompleteQueuePropertiesVO;
	import com.pixelBender.model.vo.sound.CompleteSoundPropertiesVO;
	import com.pixelBender.model.vo.sound.PlayQueuePropertiesVO;
	import com.pixelBender.model.vo.sound.PlaySoundPropertiesVO;
	import com.pixelBender.model.vo.sound.RetrieveCurrentPlayingSoundVO;
	import com.pixelBender.model.vo.tween.TweenTargetPropertyVO;
	import com.pixelBender.model.vo.tween.TweenVO;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.pool.ObjectPoolManager;
	import com.pixelBender.update.FrameUpdateManager;
	import com.pixelBender.view.popup.vo.PopupHelpersResponseVO;
	import flash.display.DisplayObjectContainer;
	import org.puremvc.as3.patterns.facade.Facade;
	import starling.display.DisplayObjectContainer;

	public class GameFacade extends Facade implements IRunnable
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================
		
		/**
		 * Static instance 
		 */		
		protected static var instance										:GameFacade;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Retain object pool used to minimize the number of new Notification objects created
		 */
		protected var notificationPool										:ObjectPool;

		/**
		 * Game root container 
		 */		
		protected var gameRoot												:flash.display.DisplayObjectContainer;

		/**
		 * Starling game root container
		 */
		protected var starlingGameRoot										:starling.display.DisplayObjectContainer;
		
		/**
		 * Game logic XML. Keeps all game screens, custom transitions, transition sequences and game components
		 * 	and also game component configurations
		 */		
		protected var globalLogicXML										:XML;
		
		/**
		 * Game assets XML 
		 */		
		protected var globalAssetsXML										:XML;
		
		/**
		 * Game ready callback. Invoked when everything is done. 
		 */		
		protected var gameReadyCallback										:Function;

		/**
		 * Application size
		 */
		protected var gameSize												:GameSizeVO;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function GameFacade()
		{
			super();
            // Force import linkage class
			new GameLinkages();
		}
		
		//==============================================================================================================
		// STATIC INSTANCE
		//==============================================================================================================
		
		/**
		 * 
		 * It will create an instance if it wasn't already created. Otherwise will return the former created instance
		 * 
		 * @return the instance of the GameEngineFacade
		 */
		public static function getInstance():GameFacade
		{
			if (instance == null)
			{
				instance = new GameFacade();
			}
			return GameFacade(instance);
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Init function. Will begin game class creation.
		 * @param root DisplayObjectContainer - Game base view container
         * @param globalLogic XML - global logic XML - keeps game screens, custom transitions, transition sequences and
		 * 												game components, and also game component configuration
		 * @param globalAssets XML - global game assets XML
		 * @param gameReadyCallback - callback invoked when the first screen is ready to start
		 * @param firstScreenName String - the first screen unique identifier. Optional. If no first screen is set,
		 * 									the user must call the first showScreen call by hand.
		 * @param starlingRoot starling.display.DisplayObjectContainer - the starling game root. Optional.
		 * @param transitionSequenceName String - the transition sequence that will be used to show the first screen.
		 * 											Optional.
		 * @param locale - game start locale. Optional
		 */
		public function init(root:flash.display.DisplayObjectContainer, globalLogic:XML, globalAssets:XML, gameReadyCallback:Function,
                             	firstScreenName:String=null, starlingRoot:starling.display.DisplayObjectContainer = null,
									transitionSequenceName:String=null, locale:String=""):void
		{
			// Internals
			var logicXML:LogicXML = new LogicXML();
			var embeddedXML:XML = logicXML.getXML();
			// Default transition sequence
			transitionSequenceName = ( transitionSequenceName == null ) ? GameConstants.DEFAULT_TRANSITION_SEQUENCE_NAME : transitionSequenceName;
			// Keep reference to params
			this.gameRoot = root;
			this.starlingGameRoot = starlingRoot;
			this.globalLogicXML = globalLogic;
			this.globalAssetsXML = globalAssets;
			this.gameReadyCallback = gameReadyCallback;
			this.gameSize = new GameSizeVO(gameRoot.stage.fullScreenWidth, gameRoot.stage.fullScreenHeight);
			// Initialize vo object pools
			initializeObjectPools();
			// Initialize helpers
			initializeHelpers();
			// Initialize the game
			sendNotification(GameConstants.INIT_GAME, new InitGameCommandVO(embeddedXML, globalLogic, globalAssets, gameRoot,
								starlingGameRoot, firstScreenName, transitionSequenceName, locale));
			// Initialize localization now, since now there is a proper localization proxy defined
			LocalizationHelpers.initialize();
		}
		
		/**
		 * The first game screen is initializes. All appropriate assets are loaded. It's GO time!  
		 */		
		public function handleGameReadyForStart():void
		{
			Logger.info(this + " Game ready for start!");
			gameReadyCallback();
			gameReadyCallback = null;
		}

		/**
		 * Needed to be called each time the game root is resized
		 */
		public function handleGameResized(scale:Number):void
		{
			if (gameSize != null)
			{
				gameSize.update(gameRoot.stage.fullScreenWidth, gameRoot.stage.fullScreenHeight, scale);
			}
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================
		
		public function toString():String
		{
			return "[GameFacade]";
		}
		
		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Start the game and all associated IRunnable game components 
		 */		
		public function start():void
		{
			sendNotification(GameConstants.START_GAME);
		}
		
		/**
		 * Pause the game and all associated IPauseResume game components 
		 */
		public function pause():void
		{
			sendNotification(GameConstants.PAUSE_GAME);	
		}
		
		/**
		 * Resume the game and all associated IPauseResume game components 
		 */
		public function resume():void
		{
			sendNotification(GameConstants.RESUME_GAME);
		}
		
		/**
		 * Dispose game and all associated IDispose game components 
		 */
		public function dispose():void
		{
			sendNotification(GameConstants.DESTROY_GAME);
			gameRoot = null;
			gameReadyCallback = null;
			globalLogicXML = null;
			globalAssetsXML = null;
			gameSize = null;
			notificationPool = null;
			instance = null;
			// Dispose static initialized game helpers
			Logger.dispose();
			LocalizationHelpers.dispose();
			GameHelpers.dispose();
			ObjectPoolManager.dispose();
			FrameUpdateManager.getInstance().dispose();
		}
		
		//==============================================================================================================
		// GETTERS
		//==============================================================================================================
		
		public function getGameRootContainer():flash.display.DisplayObjectContainer
		{
			return gameRoot;
		}

		public function getStarlingGameRootContainer():starling.display.DisplayObjectContainer
		{
			return starlingGameRoot;
		}
		
		public function getApplicationSize():GameSizeVO
		{
			return gameSize;
		}

		public function getGameLogicXML():XML
		{
			return globalLogicXML;
		}
		
		//==============================================================================================================
		// OVERRIDES
		//==============================================================================================================
		
		/**
		 * Custom
		 */
		override protected function initializeController():void
		{
			// Super behaviour
			super.initializeController();
			// Game commands
			registerCommand(GameConstants.INIT_GAME, InitGameCommand);
			registerCommand(GameConstants.START_GAME, StartGameCommand);
			registerCommand(GameConstants.PAUSE_GAME, PauseGameCommand);
			registerCommand(GameConstants.RESUME_GAME, ResumeGameCommand);
			registerCommand(GameConstants.DESTROY_GAME, DestroyGameCommand);
			// Asset proxy commands
			registerCommand(GameConstants.PARSE_AND_REGISTER_ASSET_PACKAGE, ParseAndRegisterAssetPackageCommand);
			registerCommand(GameConstants.ADD_PACKAGE_TO_QUEUE, AddPackageToLoadQueueCommand);
			registerCommand(GameConstants.LOAD_ASSET_QUEUE, LoadAssetQueueCommand);
			registerCommand(GameConstants.ASSET_PACKAGE_LOADED, AssetPackageLoadedCommand);
			registerCommand(GameConstants.GLOBAL_ASSET_PACKAGE_LOADED, GlobalAssetPackageLoadedCommand);
			registerCommand(GameConstants.RETRIEVE_GLOBAL_ASSET_PACKAGE, RetrieveGlobalAssetPackageCommand);
			// Asset file reference proxy commands
			registerCommand(GameConstants.ADD_FILE_REFERENCE, AddFileReferenceCommand);
			registerCommand(GameConstants.RETRIEVE_FILE_REFERENCE_EXISTS, RetrieveFileReferenceExistsCommand);
			registerCommand(GameConstants.RETRIEVE_FILE_REFERENCE_CONTENT, RetrieveFileReferenceContentCommand);
			registerCommand(GameConstants.LOAD_FILE_REFERENCE, LoadFileReferenceCommand);
			registerCommand(GameConstants.REMOVE_FILE_REFERENCE, RemoveFileReferenceCommand);
			registerCommand(GameConstants.REMOVE_FILE_REFERENCE_CONTENT, RemoveFileReferenceContentCommand);
			// Sound proxy commands
			registerCommand(GameConstants.PLAY_SOUND_ON_CHANNEL, PlaySoundOnChannelCommand);
			registerCommand(GameConstants.SET_SOUND_MASTER_VOLUME, SetSoundMasterVolumeCommand);
			registerCommand(GameConstants.PAUSE_RESUME_SOUND_ON_CHANNEL, PauseResumeSoundOnChannelCommand);
			registerCommand(GameConstants.STOP_SOUND_ON_CHANNEL, StopSoundOnChannelCommand);
			registerCommand(GameConstants.STOP_SOUNDS_ON_ALL_CHANNELS, StopSoundsOnAllChannelsCommand);
			registerCommand(GameConstants.REGISTER_UNREGISTER_ASSET_PACKAGE_SOUNDS, RegisterUnregisterAssetPackageSoundsCommand);
			// Game screen commands
			registerCommand(GameConstants.LOAD_GAME_SCREEN, LoadGameScreenCommand);
			registerCommand(GameConstants.SHOW_GAME_SCREEN, ShowGameScreenCommand);
			registerCommand(GameConstants.REGISTER_GAME_SCREEN_DEFAULT_PACKAGE_SOUND, RegisterGameScreenDefaultAssetPackageCommand);
			registerCommand(GameConstants.UNREGISTER_GAME_SCREEN_DEFAULT_PACKAGE_SOUND, UnregisterGameScreenDefaultAssetPackageCommand);
			// Popup commands
			registerCommand(GameConstants.DO_OPEN_POPUP, OpenPopupCommand);
			// Tween proxy commands
			registerCommand(GameConstants.ADD_TWEEN, AddTweenCommand);
			registerCommand(GameConstants.PAUSE_TWEEN, PauseTweenCommand);
			registerCommand(GameConstants.RESUME_TWEEN, ResumeTweenCommand);
			registerCommand(GameConstants.REMOVE_TWEEN, RemoveTweenCommand);
			registerCommand(GameConstants.REMOVE_TWEEN_FOR_TARGET, RemoveTweenForTargetCommand);
			// Locale command
			registerCommand(GameConstants.CHANGE_APPLICATION_LOCALE, ChangeApplicationLocaleCommand);
		}

		public override function sendNotification(notificationName:String, notificationBody:Object=null,
												  	notificationType:String=null):void
		{
			var note:GameNotification = notificationPool.allocate() as GameNotification;
			note.initialize(notificationName, notificationBody, notificationType);
			notifyObservers(note);
			notificationPool.release(note);
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function initializeObjectPools():void
		{
			var poolManager:ObjectPoolManager = ObjectPoolManager.getInstance();
			// File Reference VOs
			poolManager.registerPool(FileReferenceExistsNotificationVO.NAME, FileReferenceExistsNotificationVO, 1);
			poolManager.registerPool(AddFileReferenceNotificationVO.NAME, AddFileReferenceNotificationVO, 1);
			poolManager.registerPool(AddFileReferenceNotificationVO.NAME, AddFileReferenceNotificationVO, 1);
			poolManager.registerPool(RetrieveFileReferenceContentNotificationVO.NAME, RetrieveFileReferenceContentNotificationVO, 1);
			poolManager.registerPool(FileReferenceNotificationVO.NAME, FileReferenceNotificationVO, 1);
			// Screen VOs
			poolManager.registerPool(ShowGameScreenCommandVO.NAME, ShowGameScreenCommandVO, 1);
			// Tween VOs
			poolManager.registerPool(AddTweenNotificationVO.NAME, AddTweenNotificationVO, 1);
			poolManager.registerPool(TweenTargetPropertyVO.NAME, TweenTargetPropertyVO);
			poolManager.registerPool(TweenVO.NAME, TweenVO);
			// Sound VOs
			poolManager.registerPool(SoundPlayer.NAME, SoundPlayer, GameConstants.MAX_CHANNELS);
			poolManager.registerPool(PlaySoundPropertiesVO.NAME, PlaySoundPropertiesVO, 1);
			poolManager.registerPool(PlayQueuePropertiesVO.NAME, PlayQueuePropertiesVO, 1);
			poolManager.registerPool(CompleteSoundPropertiesVO.NAME, CompleteSoundPropertiesVO, 1);
			poolManager.registerPool(CompleteQueuePropertiesVO.NAME, CompleteQueuePropertiesVO, 1);
			poolManager.registerPool(RetrieveCurrentPlayingSoundVO.NAME, RetrieveCurrentPlayingSoundVO, 1);
			// Popup VOs
			poolManager.registerPool(PopupHelpersResponseVO.NAME, PopupHelpersResponseVO, 1);
			// File loaders
			poolManager.registerPool(FileLoader.NAME, FileLoader);
			// Notifications
			notificationPool = poolManager.registerPool(GameNotification.NAME, GameNotification);
		}

		protected function initializeHelpers():void
		{
			FrameUpdateManager.getInstance();
			Logger.createInstance();
			GameHelpers.initialize(this);
			FileReferenceHelpers.initialize();
			ScreenHelpers.initialize();
			TweenHelpers.initialize();
			SoundHelpers.initialize();
			PopupHelpers.initialize();
		}
	}
}