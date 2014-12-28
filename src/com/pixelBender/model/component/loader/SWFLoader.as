package com.pixelBender.model.component.loader
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.model.vo.asset.AssetVO;
	import com.pixelBender.model.vo.asset.SWFAssetVO;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class SWFLoader extends AssetLoader
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Reference to the SWF asset 
		 */		
		protected var swfAsset																		:SWFAssetVO;
		
		/**
		 * The actual loader 
		 */		
		protected var loader																		:Loader;
		
		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		/**
		 * See inherited documentation 
		 * @param asset SWFAssetVO
		 * @param callback Function
		 */	
		override public function load(asset:AssetVO, callback:Function):void
		{
			super.load(asset, callback);
			swfAsset = asset as SWFAssetVO;
			if (loader == null)
			{
				loader = new Loader();
			}
			addListeners(loader.contentLoaderInfo);
			loader.load( new URLRequest(swfAsset.getFullURL()) );
		}
		
		/**
		 * See inherited documentation
		 * @return AssetVO 
		 */		
		override public function getAsset():AssetVO
		{
			return swfAsset;
		}
		
		/**
		 * See inherited documentation 
		 */		
		override public function clear():void
		{
			super.clear();
			swfAsset = null;
			removeListeners(loader);
		}
		
		/**
		 * See inherited documentation 
		 */	
		override public function dispose():void
		{
			super.dispose();
			if (loader != null)
			{
				removeListeners(loader);
				if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_LOADING))
				{
					loader.close();
				}
				loader = null;
			}
			swfAsset = null;
		}
		
		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================
		
		/**
		 * Custom error handler.
		 * @param error Event
		 */		
		override protected function handleErrorEvent(error:Event):void
		{
			removeListeners(loader);
			super.handleErrorEvent(error);
		}
		
		/**
		 * Custom complete handler.
		 * @param event Event
		 */		
		override protected function handleCompleteEvent(event:Event):void
		{
			swfAsset.setContent(loader.content);
			swfAsset.setApplicationDomain(loader.contentLoaderInfo.applicationDomain);
			swfAsset.setBytes(loader.contentLoaderInfo.bytes);
			removeListeners(loader);
			super.handleCompleteEvent(event);
		}
	}
}