package com.pixelBender.model.component.loader
{
	import com.pixelBender.model.vo.asset.AssetVO;
	import com.pixelBender.model.vo.asset.ImageAssetVO;

	import flash.events.Event;

	public class ImageLoader extends GraphicsLoader
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Reference to the SWF asset
		 */
		protected var imageAsset														:ImageAssetVO;

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================

		/**
		 * See inherited documentation
		 * @param asset ImageAssetVO
		 * @param callback Function
		 */
		override public function load(asset:AssetVO, callback:Function):void
		{
			super.load(asset, callback);
			imageAsset = asset as ImageAssetVO;
		}

		/**
		 * See inherited documentation
		 * @return AssetVO
		 */
		override public function getAsset():AssetVO
		{
			return imageAsset;
		}

		/**
		 * See inherited documentation
		 */
		override public function clear():void
		{
			super.clear();
			imageAsset = null;
		}

		/**
		 * See inherited documentation
		 */
		override public function dispose():void
		{
			super.dispose();
			imageAsset = null;
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
			imageAsset.setContent(loader.content);
			super.handleCompleteEvent(event);
		}
	}
}
