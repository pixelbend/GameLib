package com.pixelBender.model
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.interfaces.IAssetProxy;
	import com.pixelBender.interfaces.ITreeLeaf;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.component.loader.AssetLoaderComponent;
	import com.pixelBender.model.vo.asset.AssetPackageVO;
	import com.pixelBender.model.vo.asset.AssetVO;
	import flash.utils.Dictionary;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AssetProxy extends Proxy implements IAssetProxy
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The registered packages 
		 */		
		protected var packages																:Dictionary;
		
		/**
		 * Path prefix for assets who have generic asset package parents. Used to create the full URL upon load.
		 */
		protected var genericPath															:String;
		
		/**
		 * Path prefix for assets who have locale asset package parents. Used to create the full URL upon load.
		 */
		protected var localePath															:String;
		
		/**
		 * The current language 
		 */		
		protected var locale																:String;
		
		/**
		 * The name of the global asset package 
		 */		
		protected var globalPackageName														:String;
		
		/**
		 * The currently loading queue. If any. 
		 */		
		protected var loadingQueue															:Vector.<AssetVO>;
		
		/**
		 * The current loading asset packaged. If any. 
		 */		
		protected var loadingAssetPackageQueue												:Vector.<AssetPackageVO>;
		
		/**
		 * The loader component of the asset proxy. Responsible only for loading assets. 
		 */		
		protected var loaderComponent														:AssetLoaderComponent;
		
		/**
		 * Asset proxy state 
		 */		
		protected var state																	:int;
		
		/**
		 * Initial load queue length. Used for statistics. 
		 */		
		protected var initialLoadQueueCount													:int;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Asset proxy 
		 * @param proxyName String
		 */		
		public function AssetProxy(proxyName:String)
		{
			super(proxyName);
			loaderComponent = new AssetLoaderComponent();
			packages = new Dictionary();
			genericPath = "";
			localePath = "";
			locale = "";
			state = GameConstants.STATE_IDLE;
		}
		
		//==============================================================================================================
		// IAssetProxy IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Will register a new package to the list
		 * @param assetPackage AssetPackageVO
		 */		
		public function registerPackage(assetPackage:AssetPackageVO):void
		{
			packages[assetPackage.getFullName()] = assetPackage;			
		}
		
		public function getPackage(name:String):*
		{
			return packages[name];
		}
		
		public function setGenericPath(path:String):void
		{
			genericPath = path;
		}

		public function setLocalePath(path:String):void
		{
			localePath = path;
		}
		
		public function setLocale(newLocale:String, invalidateLoadedLocalizedPackages:Boolean = true):void
		{
			locale = newLocale;
			if (invalidateLoadedLocalizedPackages)
			{
				for each (var assetPackage:AssetPackageVO in packages)
				{
					if (assetPackage.getType() == GameConstants.ASSET_PACKAGE_TYPE_LOCALE)
					{
						clearPackage(assetPackage.getFullName());
					}
				}
			}
		}
		
		/**
		 * Retrieves the asset from the specified package.
		 * @param packageName String
		 * @param assetName String
		 * @return AssetVO 
		 */		
		public function getAsset(packageName:String, assetName:String):AssetVO
		{
			var assetPackage:AssetPackageVO = packages[packageName];
			if (assetPackage != null)
			{
				return assetPackage.getChild(assetName) as AssetVO; 
			}
			return null;
		}
		
		/**
		 * Will set all the asset children with null content. Useful when changing languages.
		 * @param name String
		 */		
		public function clearPackage(name:String):void
		{
			var assetPackage:AssetPackageVO = getPackage(name);
			if (assetPackage != null)
			{
				var children:Vector.<ITreeLeaf> = assetPackage.getChildrenVector(),
					child:ITreeLeaf;
				for each (child in children)
				{
					if (child is AssetVO)
					{
						(child as AssetVO).setContent(null);
					}
				}
			}
		}
		
		/**
		 * Will set the assets identified by its parent asset package name to null. 
		 * @param packageName String 
		 * @param name String
		 */		
		public function clearAsset(packageName:String, name:String):void
		{
			var assetVO:AssetVO = getAsset(packageName, name);
			if (assetVO != null)
			{
				assetVO.setContent(null);
			}
		}
		
		/**
		 * Will add all children assets of the given package to the load queue 
		 * @param name String - package identifier
		 * @param includeSubPackages Boolean - if set, it will also add recursively all the assets of the children sub packages.
		 */		
		public function addPackageToLoadQueue(name:String, includeSubPackages:Boolean=true):void
		{
			// Check state
			AssertHelpers.assertCondition((!BitMaskHelpers.isBitActive(state, GameConstants.STATE_LOADING)),
											"Cannot add package to queue while loading!");
			// Internals
			var assetPackage:AssetPackageVO = getPackage(name),
				assets:Vector.<AssetVO>,
				packages:Vector.<AssetPackageVO>,
				subPackage:AssetPackageVO,
				prefix:String,
				asset:AssetVO;
			// Create loading queue if not already there
			if ( loadingAssetPackageQueue == null )
			{
				loadingAssetPackageQueue = new Vector.<AssetPackageVO>();
			}
			if (loadingAssetPackageQueue.indexOf(assetPackage) >= 0) 
			{
				Logger.warning("Asset package["+assetPackage.getName()+"] already in queue. Skipping!");
				return; 
			}
			// Create loading asset queue
			if ( loadingQueue == null )
			{
				loadingQueue = new Vector.<AssetVO>();
			}
			if (assetPackage != null) 
			{
				assets = assetPackage.getAssetChildren();
				prefix = computeURLPrefixForAssetPackage(assetPackage);
				for each (asset in assets) 
				{
					asset.setURLPrefix(prefix);
					loadingQueue.push(asset);
				}
				if (includeSubPackages) 
				{
					packages = assetPackage.getPackageChildren();
					for each (subPackage in packages)
					{
						addPackageToLoadQueue(subPackage.getFullName(), includeSubPackages);
					}
				}
			}
			// Add asset package to load queue
			loadingAssetPackageQueue.push(assetPackage);
		}
		
		/**
		 * Will begin the load procedure. 
		 */		
		public function load():void
		{
			// Verify state
			AssertHelpers.assertCondition(!BitMaskHelpers.isBitActive(state, GameConstants.STATE_LOADING),
											"Cannot call load() while loading!");
			// Check loading queue
			if (loadingQueue.length == 0 ) 
			{
				Logger.warning(this + " Loading queue is empty. Dispatching complete!");
				facade.sendNotification(GameConstants.ASSET_QUEUE_LOADED);
				return;
			}
			// Set proper state
			state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_IDLE, GameConstants.STATE_LOADING);
			// Start load
			initialLoadQueueCount = loadingQueue.length;
			loaderComponent.load(loadingQueue, handleAssetLoaded, handleQueueComplete);
		}
		
		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================

		/**
		 * Pause all loading assets
		 */
		public function pause():void
		{
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_IDLE) ||
					BitMaskHelpers.isBitActive(state, GameConstants.STATE_LOADING))
			{
				state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
				loaderComponent.pause();
			}
		}

		/**
		 * Resume all loading assets
		 */
		public function resume():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED)) return;
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
			loaderComponent.resume();
		}

		/**
		 * Proper memory management 
		 */		
		public function dispose():void
		{
			if (packages != null) 
			{
				DictionaryHelpers.deleteValues(packages);
				packages = null;
			}
			if (loaderComponent != null)
			{
				loaderComponent.dispose();
				loaderComponent = null;
			}
			localePath = null;
			genericPath = null;
			loadingQueue = null;
			state = GameConstants.STATE_DISPOSED;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function setGlobalPackageName(name:String):void
		{
			globalPackageName = name;
		}
		
		public function getGlobalPackageName():String
		{
			return globalPackageName;
		}

		public function setKnownLoaders(knownLoaderTypes:Dictionary):void
		{
			loaderComponent.createLoaderPools(knownLoaderTypes);
		}
		
		public function toString():String
		{
			return "[AssetProxy]";
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Asset completed handler
		 * @param asset AssetVO
		 */		
		protected function handleAssetLoaded(asset:AssetVO):void
		{
			var index:int = loadingQueue.indexOf(asset);
			if (index >= 0 && index < loadingQueue.length)
			{
				loadingQueue.splice(index, 1);
				facade.sendNotification(GameConstants.ASSET_QUEUE_PROGRESS, loadingQueue.length/initialLoadQueueCount);
			}
		}
		
		/**
		 * Queue complete handler  
		 */		
		protected function handleQueueComplete():void
		{
			// Internals
			var assetPackageVO:AssetPackageVO,
				noteName:String;
			// Set proper state
			state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_LOADING, GameConstants.STATE_IDLE);
			// Log
			Logger.info(this + " Asset queue complete with the following packages:");
			// Clear loaded packages
			for each (assetPackageVO in loadingAssetPackageQueue)
			{
				noteName = ( assetPackageVO.getName() == globalPackageName ) ? GameConstants.GLOBAL_ASSET_PACKAGE_LOADED : GameConstants.ASSET_PACKAGE_LOADED;
				Logger.info(this + " Asset package[" + assetPackageVO.getFullName() + "] complete. Dispatching [" + noteName + "] command!");
				facade.sendNotification(noteName, assetPackageVO);
			}
			loadingAssetPackageQueue = null;
			loadingQueue = null;
			// All done			
			facade.sendNotification(GameConstants.ASSET_QUEUE_LOADED);
		}
		
		/**
		 * Computes the proper URL prefix, according to the asset package type.
		 * @param assetPackage AssetPackageVO
		 * @return String 
		 */		
		private function computeURLPrefixForAssetPackage(assetPackage:AssetPackageVO):String
		{
			switch (assetPackage.getType())
			{
				case GameConstants.ASSET_PACKAGE_TYPE_LOCALE:
					return localePath + locale + "/";
				default:
					return genericPath;
			}
		}
	}
}