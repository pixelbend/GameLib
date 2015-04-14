package com.pixelBender.model.component.loader
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.constants.GameReflections;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.interfaces.IAssetLoader;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.model.vo.asset.AssetVO;
	import com.pixelBender.pool.ObjectPoolManager;

	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	public class AssetLoaderComponent implements IPauseResume
	{
		
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================
		
		private static const DEFAULT_QUEUE_LENGTH												:int = 10;
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The total queue that will be loaded 
		 */		
		protected var totalQueue																:Vector.<AssetVO>;

		/**
		 * The current assigned loaders 
		 */		
		protected var currentLoaders															:Vector.<IAssetLoader>;
		
		/**
		 * The maximum length of the current loaders vector. Used not to generate system block if too many complete listeners get
		 * 	fired up in the same time. 
		 */		
		protected var maxParallelLoaders														:int;
		
		/**
		 * The callback invoked each time an asset is completed
		 */		
		protected var assetLoadedCallback														:Function;
		
		/**
		 * The callback invoked when the entire queue is complete 
		 */		
		protected var queueCompleteCallback														:Function;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor 
		 */		
		public function AssetLoaderComponent()
		{
			createLoadersDictionary();
			maxParallelLoaders = DEFAULT_QUEUE_LENGTH;
		}
		
		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================
		
		public function pause():void
		{
			IRunnableHelpers.pause(currentLoaders);
		}
		
		public function resume():void
		{
			IRunnableHelpers.resume(currentLoaders);
		}
		
		public function dispose():void
		{
			currentLoaders = null;
			totalQueue = null;
			assetLoadedCallback = null;
			queueCompleteCallback = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function load(queue:Vector.<AssetVO>, assetLoadedCallback:Function, queueCompleteCallback:Function):void
		{
			// Internals
			var asset:AssetVO;
			// Reset all queues
			currentLoaders = new <IAssetLoader>[];
			totalQueue = new <AssetVO>[];
			this.assetLoadedCallback = assetLoadedCallback;
			this.queueCompleteCallback = queueCompleteCallback;
			// Clone queue
			for each (asset in queue)
			{
				totalQueue.push(asset);
			}
			// Start actual loading
			loadNextAssets();
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[AssetLoaderComponent]";
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Will load next available assets
		 */		
		protected function loadNextAssets():void
		{
			// Internals
			var loaderPool:ObjectPool,
				loader:IAssetLoader,
				assetToLoad:AssetVO;
			// Build up queue
			while (currentLoaders.length < maxParallelLoaders && totalQueue.length > 0)
			{
				assetToLoad = totalQueue.pop();
				loaderPool = ObjectPoolManager.getInstance().retrievePool(assetToLoad.getType());
				loader = loaderPool.allocate() as IAssetLoader;
				currentLoaders.push(loader);
				loader.load(assetToLoad, handleAssetLoaded);
			}
		}
		
		/**
		 * Asset loaded complete handler
		 * @param loader IAssetLoader
		 */		
		protected function handleAssetLoaded(loader:IAssetLoader):void
		{
			// Internals
			var loadedAsset:AssetVO = loader.getAsset(),
				loaderPool:ObjectPool = ObjectPoolManager.getInstance().retrievePool(loadedAsset.getType()),
				index:int = currentLoaders.indexOf(loader);
			// Release the loader back in the pool
			currentLoaders.splice(index,1);
			loader.clear();
			loaderPool.release(loader);
			// Check complete
			if (totalQueue.length == 0 && currentLoaders.length == 0)
			{
				handleQueueComplete();
				return;
			}
			// Next asset
			loadNextAssets();
		}
		
		/**
		 * Queue complete handler
		 */		
		protected function handleQueueComplete():void
		{
			totalQueue = null;
			currentLoaders = null;
			queueCompleteCallback();
		}
		
		/**
		 * Will create the loader object pools. 
		 */		
		protected static function createLoadersDictionary():void
		{
			// Internals
			var knownLoaderTypes:Dictionary = GameReflections.getAllReflectionsByType(GameConstants.REFLECTION_TYPE_LOADER),
				loaderClass:Class,
				key:String;
			// Create instance and populate with all loader known types.
			for (key in knownLoaderTypes)
			{
				loaderClass = ApplicationDomain.currentDomain.getDefinition(knownLoaderTypes[key]) as Class;
				ObjectPoolManager.getInstance().registerPool(key, loaderClass);
			}
		}
	}
}