package com.pixelBender.model.component.loader
{
	import com.pixelBender.model.vo.asset.AssetVO;
	import com.pixelBender.model.vo.asset.SWFAssetVO;

	import flash.events.Event;

	public class SWFLoader extends GraphicsLoader
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Reference to the SWF asset 
		 */		
		protected var swfAsset																		:SWFAssetVO;

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
		}
		
		/**
		 * See inherited documentation 
		 */	
		override public function dispose():void
		{
			super.dispose();
			swfAsset = null;
		}

		//==============================================================================================================
		// PROTECTED OVERRIDES
		//==============================================================================================================

		/**
		 * Custom complete handler.
		 * @param event Event
		 */
		override protected function handleCompleteEvent(event:Event):void
		{
			swfAsset.setContent(loader.content);
			swfAsset.setApplicationDomain(loader.contentLoaderInfo.applicationDomain);
			swfAsset.setBytes(loader.contentLoaderInfo.bytes);
			super.handleCompleteEvent(event);
		}
	}
}