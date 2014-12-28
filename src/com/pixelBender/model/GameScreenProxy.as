package com.pixelBender.model
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.controller.asset.vo.AddPackageToLoadQueueCommandVO;
	import com.pixelBender.controller.asset.vo.ParseAndRegisterAssetPackageCommandVO;
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.vo.asset.AssetPackageVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class GameScreenProxy extends Proxy implements IDispose
	{
		
		//==============================================================================================================
		// ITreeLeaf IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * The game screen asset package 
		 */		
		protected var screenAssetPackage														:AssetPackageVO;
		
		/**
		 * The screen logic XML 
		 */		
		protected var screenLogicXML															:XML;
		
		/**
		 * The screen assets XML 
		 */		
		protected var screenAssetsXML															:XML;
		
		/**
		 * Needed for initialization process. 
		 */		
		protected var screenAssetPackageName													:String;
		
		/**
		 * Reference to the screen mediator name 
		 */		
		protected var screenName																:String;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function GameScreenProxy(proxyName:String, screenName:String, screenLogicXML:XML, screenAssetsXML:XML)
		{
			this.screenLogicXML = screenLogicXML;
			this.screenAssetsXML = screenAssetsXML;
			if (screenAssetsXML != null)
			{
				this.screenAssetPackageName = String(screenAssetsXML.@name);
			}
			this.screenName = screenName;
			super(proxyName);
		}
		
		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Memory management 
		 */		
		public function dispose():void
		{
			screenAssetPackage = null;
			screenLogicXML = null;
			screenAssetsXML = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Add to queue the screen asset package name and start loading. 
		 */		
		public function loadScreenPackage():void
		{
			if (screenAssetsXML == null || (screenAssetPackage != null && screenAssetPackage.getIsComplete())) 
			{
				Logger.info(this + " Screen already loaded or no assets to load. Dispatching GAME_SCREEN_LOADED notification!");
				facade.sendNotification(GameConstants.GAME_SCREEN_LOADED, screenName);
				return;
			}
			facade.sendNotification(GameConstants.ADD_PACKAGE_TO_QUEUE, new AddPackageToLoadQueueCommandVO(screenAssetPackageName));
			facade.sendNotification(GameConstants.LOAD_ASSET_QUEUE);	
		}
		
		/**
		 * Asset package loaded handler. Keeps a reference to the asset package and fires the screen loaded
		 * 	notification if the right package is given.
		 * @param completedAssetPackage AssetPackageVO
		 */		
		public function handlePackageLoaded(completedAssetPackage:AssetPackageVO):void
		{
			if (completedAssetPackage != null && completedAssetPackage == screenAssetPackage)
			{
				handleScreenPackageLoaded();
			}
		}
		
		public function toString():String
		{
			return "[GameScreenProxy screenName:" + screenName + "]";
		}
		
		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================
		
		public function getScreenAssetPackageName():String
		{
			return screenAssetPackageName;
		}
		
		public function getScreenAssetPackage():AssetPackageVO
		{
			return screenAssetPackage;
		}
		
		//==============================================================================================================
		// IProxy IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * On register functionality. Handles the screen XMLs. 
		 */		
		override public function onRegister():void
		{
			if (screenAssetsXML != null)
			{
				var noteVO:ParseAndRegisterAssetPackageCommandVO = new ParseAndRegisterAssetPackageCommandVO(screenAssetsXML, null);
				facade.sendNotification(GameConstants.PARSE_AND_REGISTER_ASSET_PACKAGE, noteVO);
				this.screenAssetPackage = noteVO.getRegisteredPackage();
			}
			parseScreenLogicXML();
		}

		//==============================================================================================================
		// LOCALS THAT SHOULD BE OVERRIDDEN
		//==============================================================================================================
		
		/**
		 * Package loaded handler
		 */
		protected function handleScreenPackageLoaded():void
		{
			// Log
			Logger.info(this + " screen loaded!");
			// Send notification to game screen manager.
			facade.sendNotification(GameConstants.GAME_SCREEN_LOADED, screenName);
		}
		
		/**
		 * Parse and create and needed logic VOs here. 
		 */		
		protected function parseScreenLogicXML():void{}
	}
}