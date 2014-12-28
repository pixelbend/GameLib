package com.pixelBender.model.component.loader
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.model.vo.asset.AssetVO;
	import com.pixelBender.model.vo.asset.XMLAssetVO;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class XMLLoader extends AssetLoader
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Reference to the XML asset 
		 */		
		protected var xmlAsset																		:XMLAssetVO;
		
		/**
		 * The actual loader 
		 */		
		protected var loader																		:URLLoader;
		
		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================
		
		/**
		 * See inherited documentation 
		 * @param asset AssetVO
		 * @param callback Function
		 */		
		override public function load(asset:AssetVO, callback:Function):void
		{
			super.load(asset, callback);
			xmlAsset = asset as XMLAssetVO;
			if (loader == null)
			{
				loader = new URLLoader();
			}
			addListeners(loader);
			loader.load( new URLRequest(xmlAsset.getFullURL()) );
		}
		
		/**
		 * See inherited documentation
		 * @return AssetVO 
		 */		
		override public function getAsset():AssetVO
		{
			return xmlAsset;
		}
		
		/**
		 * See inherited documentation 
		 */		
		override public function clear():void
		{
			super.clear();
			xmlAsset = null;
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
			xmlAsset = null;
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
			xmlAsset.setContent(new XML(loader.data));
			removeListeners(loader);
			super.handleCompleteEvent(event);
		}
	}
}