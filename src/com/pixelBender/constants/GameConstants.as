package com.pixelBender.constants
{
	public class GameConstants
	{
		//=================================================================================================================================
		// GAME NOTIFICATION NAMES
		//=================================================================================================================================
		
		public static const INIT_GAME											:String = "_game__initGame";
		public static const START_GAME											:String = "_game__startGame";
		public static const PAUSE_GAME											:String = "_game__pauseGame";
		public static const RESUME_GAME											:String = "_game__resumeGame";
		public static const DESTROY_GAME										:String = "_game__destroyGame";
		
		//=================================================================================================================================
		// ASSET NOTIFICATION NAMES
		//=================================================================================================================================
		
		public static const PARSE_AND_REGISTER_ASSET_PACKAGE					:String = "_game__parseAndRegisterPackage";
		public static const ASSET_QUEUE_LOADED									:String = "_game__assetQueueLoaded";
		public static const GLOBAL_ASSET_PACKAGE_LOADED							:String = "_game__globalAssetPackageLoaded";
		public static const ASSET_PACKAGE_LOADED								:String = "_game__assetPackageLoaded";
		public static const ASSET_QUEUE_PROGRESS								:String = "_game__assetQueueProgress";
		public static const ADD_PACKAGE_TO_QUEUE								:String = "_game__addPackageToQueue";
		public static const LOAD_ASSET_QUEUE									:String = "_game__loadQueue";
		public static const RETRIEVE_GLOBAL_ASSET_PACKAGE						:String = "_game_retrieveGlobalAssetPackage";

		//=================================================================================================================================
		// ASSET FILE REFERENCE NOTIFICATION NAMES
		//=================================================================================================================================

		public static const ADD_FILE_REFERENCE									:String = "_game__addFileReference";
		public static const RETRIEVE_FILE_REFERENCE_EXISTS						:String = "_game__retrieveFileReferenceExists";
		public static const RETRIEVE_FILE_REFERENCE_CONTENT						:String = "_game__retrieveFileReferenceContent";
		public static const LOAD_FILE_REFERENCE									:String = "_game__loadFileReference";
		public static const FILE_REFERENCE_LOADED								:String = "_game__fileReferenceLoaded";
		public static const REMOVE_FILE_REFERENCE								:String = "_game__removeFileReference";
		public static const REMOVE_FILE_REFERENCE_CONTENT						:String = "_game__removeFileReferenceContent";
		
		//=================================================================================================================================
		// SOUND NOTIFICATION NAMES
		//=================================================================================================================================
		
		public static const PLAY_SOUND_ON_CHANNEL								:String = "_game__playSoundOnChannel";
		public static const STOP_SOUND_ON_CHANNEL								:String = "_game__stopSoundOnChannel";
		public static const STOP_SOUNDS_ON_ALL_CHANNELS							:String = "_game__stopSoundsOnAllChannels";
		public static const RETRIEVE_CURRENT_PLAYING_SOUND						:String = "_game__retrieveCurrentPlayingSound";
		public static const PAUSE_RESUME_SOUND_ON_CHANNEL						:String = "_game__pauseResumeSoundOnChannel";
		public static const REGISTER_UNREGISTER_ASSET_PACKAGE_SOUNDS			:String = "_game__registerUnregisterAssetPackageSounds";
		public static const RETRIEVE_SOUND_MASTER_VOLUME						:String = "_game__retrieveSoundMasterVolume";
		public static const SET_SOUND_MASTER_VOLUME								:String = "_game__setSoundMasterVolume";
		public static const SOUND_MASTER_VOLUME_CHANGED							:String = "_game__soundMasterVolumeChanged";
		
		//=================================================================================================================================
		// SOUND NOTIFICATION TYPES
		//=================================================================================================================================
		
		public static const TYPE_REGISTER_ASSET_PACKAGE_SOUNDS					:String = "_type__registerAssetPackageSounds";
		public static const TYPE_UNREGISTER_ASSET_PACKAGE_SOUNDS				:String = "_type__unregisterAssetPackageSounds";

		public static const TYPE_PAUSE_SOUND									:String = "_type_pauseSound";
		public static const TYPE_RESUME_SOUND									:String = "_type_resumeSound";
		
		//=================================================================================================================================
		// GAME SCREEN NOTIFICATION NAMES
		//=================================================================================================================================
		
		public static const SHOW_GAME_SCREEN									:String = "_game__showGameScreen";
		public static const LOAD_GAME_SCREEN									:String = "_game__loadGameScreen";
		public static const GAME_SCREEN_LOADED									:String = "_game__gameScreenLoaded";
		public static const GAME_SCREEN_READY_TO_START							:String = "_game__gameScreenReadyToStart";

		public static const REGISTER_GAME_SCREEN_DEFAULT_PACKAGE_SOUND			:String = "_game__registerGameScreenDefaultPackageSounds";
		public static const UNREGISTER_GAME_SCREEN_DEFAULT_PACKAGE_SOUND		:String = "_game__unregisterGameScreenDefaultPackageSounds";
		
		//=================================================================================================================================
		// POPUP NOTIFICATION NAMES
		//=================================================================================================================================

		public static const DO_OPEN_POPUP										:String = "_game__doOpenPopup";
		public static const OPEN_POPUP											:String = "_game__openPopup";
		public static const CLOSE_POPUP											:String = "_game__closePopup";
		public static const GET_STACK_POPUPS									:String = "_game__getStackPopups";
		public static const SET_STACK_POPUPS									:String = "_game__setStackPopups";
		public static const GET_POPUP_TRANSLUCENT_LAYER_PROPERTIES				:String = "_game__setPopupTranslucentLayerProperties";
		public static const SET_POPUP_TRANSLUCENT_LAYER_ENABLED					:String = "_game__setPopupTranslucentLayerEnabled";
		public static const SET_POPUP_TRANSLUCENT_LAYER_COLOR					:String = "_game__setPopupsTranslucentLayerColor";
		public static const SET_POPUP_TRANSLUCENT_LAYER_ALPHA					:String = "_game__setPopupTranslucentLayerAlpha";
		
		//=================================================================================================================================
		// TWEEN NOTIFICATION NAMES
		//=================================================================================================================================
		
		public static const ADD_TWEEN											:String = "_game__addTween";
		public static const PAUSE_TWEEN											:String = "_game__pauseTween";
		public static const RESUME_TWEEN										:String = "_game__resumeTween";
		public static const REMOVE_TWEEN										:String = "_game__removeTween";
		public static const REMOVE_TWEEN_FOR_TARGET								:String = "_game__removeTweenForTarget";

		//=================================================================================================================================
		// LOCALE NOTIFICATION NAMES
		//=================================================================================================================================

		public static const CHANGE_APPLICATION_LOCALE							:String = "_game__changeApplicationLocale";

		//=================================================================================================================================
		// TRANSITION / TRANSITION SEQUENCE NAMES
		//=================================================================================================================================
		
		public static const DEFAULT_TRANSITION_SEQUENCE_NAME					:String = "defaultTransitionSequence";
		public static const LOOP_TRANSITION_NAME								:String = "loopTransition";
		
		//=================================================================================================================================
		// COMPONENT NAMES
		//=================================================================================================================================
		
		public static const GAME_COMPONENT_PROXY_NAME							:String = "_game__componentProxy";
		public static const ASSET_PROXY_NAME									:String = "_game__assetProxy";
		public static const FILE_REFERENCE_PROXY_NAME							:String = "_game__fileReferenceProxy";
		public static const SOUND_PROXY_NAME									:String = "_game__soundProxy";
		public static const LOCALIZATION_PROXY_NAME								:String = "_game__localizationProxy";
		public static const TWEEN_PROXY											:String = "_game__tweenProxy";
		public static const GAME_SCREEN_PROXY_SUFFIX							:String = "_screenProxy";

		public static const GAME_SCREEN_MANAGER_MEDIATOR_NAME					:String = "_game__gameScreenManagerMediator";
		public static const POPUP_MANAGER_MEDIATOR_NAME							:String = "_game__popupManagerMediator";

		//=================================================================================================================================
		// REFLECTIONS
		//=================================================================================================================================
		
		public static const REFLECTION_TYPE_GAME_COMPONENT						:String = "gameComponent";
		public static const REFLECTION_TYPE_ASSET								:String = "asset";
		public static const REFLECTION_TYPE_LOADER								:String = "assetLoader";
		
		//=================================================================================================================================
		// ASSET PACKAGE CONSTANTS
		//=================================================================================================================================
			
		public static const ASSET_PACKAGE_TYPE_GENERIC							:String = "generic";
		public static const ASSET_PACKAGE_TYPE_LOCALE							:String = "locale";
		public static const ASSET_PACKAGE_XML_NAME								:String = "package";
		
		public static const DEFAULT_SCREEN_SOUND_PACKAGE_SUFFIX					:String = ".sounds";
		
		//=================================================================================================================================
		// ASSET TYPES
		//=================================================================================================================================
		
		public static const ASSET_TYPE_SWF										:String = "swf";
		public static const ASSET_TYPE_SOUND									:String = "sound";
		public static const ASSET_TYPE_XML										:String = "xml";

		//=================================================================================================================================
		// ASSET FILE REFERENCE TYPES/EXTENSIONS
		//=================================================================================================================================

		public static const ASSET_FILE_REFERENCE_TYPE_IMAGE						:String = "image";
		public static const ASSET_FILE_REFERENCE_TYPE_IMAGE_EXTENSION			:String = "png";

		//=================================================================================================================================
		// ASSET NAMES
		//=================================================================================================================================
		
		public static const GAME_SCREEN_DEFAULT_MAIN_GRAPHICS_ASSET_NAME		:String = "mainGraphics";
		public static const POPUP_LOGIC_XML_ASSET_NAME							:String = "popupLogic";
		public static const LOCALE_TEXTS_ASSET_NAME								:String = "localeTexts";
		
		//=================================================================================================================================
		// SOUND CHANNEL IDS
		//=================================================================================================================================
		
		public static const CHANNEL_VOICE										:int = 0;
		public static const CHANNEL_SFX											:int = 1;
		public static const CHANNEL_AMBIANCE									:int = 2;
		public static const CHANNEL_PLAN_B										:int = 3;
		public static const CHANNEL_PLAN_C										:int = 4;

		public static const MAX_CHANNELS										:int = 5;

		public static const CHANNEL_VOICE_NAME									:String = "voice";
		public static const CHANNEL_SFX_NAME									:String = "SFX";
		public static const CHANNEL_AMBIANCE_NAME								:String = "ambiance";
		public static const CHANNEL_PLAN_B_NAME									:String = "planB";
		public static const CHANNEL_PLAN_C_NAME									:String = "planC";

		//=================================================================================================================================
		// GAME COMPONENT POSSIBLE STATES
		//=================================================================================================================================
		
		public static const STATE_IDLE											:int = 1<<0;
		public static const STATE_CLOSED										:int = 1<<0;
		public static const STATE_LOADING										:int = 1<<1;
		public static const STATE_PLAYING										:int = 1<<1;
		public static const STATE_TRANSITIONING									:int = 1<<1;
		public static const STATE_UPDATING										:int = 1<<1;
		public static const STATE_PREPARING_FOR_OPEN							:int = 1<<2;
		public static const STATE_PREPARING_FOR_START							:int = 1<<2;
		public static const STATE_STARTED										:int = 1<<3;
		public static const STATE_OPENED										:int = 1<<3;
		public static const STATE_PAUSED										:int = 1<<4;
		public static const STATE_DISPOSED										:int = 1<<5;

		//=================================================================================================================================
		// TRANSITION STATES
		//=================================================================================================================================
		
		public static const TRANSITION_STATE_COVER_SCREEN						:int = 0;
		public static const TRANSITION_STATE_LOOP_LOADING						:int = 1;
		public static const TRANSITION_STATE_REVEAL_SCREEN						:int = 2;
		public static const TRANSITION_STATES									:int = 3;
		
		//=================================================================================================================================
		// COMPONENT QUALIFIED CLASS NAMES
		//=================================================================================================================================
		
		public static const GAME_COMPONENT_PROXY_QUALIFIED_CLASS_NAME			:String = "com.pixelBender.model::GameComponentProxy";
		public static const ASSET_PROXY_QUALIFIED_CLASS_NAME					:String = "com.pixelBender.model::AssetProxy";
		public static const FILE_REFERENCE_PROXY_QUALIFIED_CLASS_NAME			:String = "com.pixelBender.model::FileReferenceProxy";
		public static const SOUND_PROXY_QUALIFIED_CLASS_NAME					:String = "com.pixelBender.model::SoundProxy";
		public static const LOCALIZATION_PROXY_QUALIFIED_CLASS_NAME				:String = "com.pixelBender.model::LocalizationProxy";
		public static const GAME_SCREEN_MANAGER_MEDIATOR_QUALIFIED_CLASS_NAME	:String = "com.pixelBender.view.gameScreen::GameScreenManagerMediator";	
		public static const POPUP_MANAGER_MEDIATOR_QUALIFIED_CLASS_NAME			:String = "com.pixelBender.view.popup::GameScreenManagerMediator";
		
		//=================================================================================================================================
		// COMPONENT TYPES
		//=================================================================================================================================
		
		public static const TYPE_PROXY											:String = "proxy";
		public static const TYPE_MEDIATOR										:String = "mediator";
		
		//=================================================================================================================================
		// BOOLEAN STRING VALUES- used in XML parsing
		//=================================================================================================================================
		
		public static const BOOLEAN_TRUE_STRING									:String = "true";
		public static const BOOLEAN_FALSE_STRING								:String = "false";
	}
}