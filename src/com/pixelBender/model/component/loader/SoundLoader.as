package com.pixelBender.model.component.loader
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.model.vo.asset.AssetVO;
	import com.pixelBender.model.vo.asset.SoundAssetVO;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	public class SoundLoader extends AssetLoader
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Reference to the SoundAsset 
		 */		
		protected var soundAsset																	:SoundAssetVO;
		
		/**
		 * The actual loader 
		 */		
		protected var loader																		:Sound;

		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================
		
		/**
		 * See inherited documentation 
		 * @param asset SoundAssetVO
		 * @param callback Function
		 */	
		override public function load(asset:AssetVO, callback:Function):void
		{
			super.load(asset, callback);
			soundAsset = asset as SoundAssetVO;
			// New loader each time since it's the same as the content.
			loader = new Sound();
			addListeners(loader);
			loader.load( new URLRequest(soundAsset.getFullURL()) );
		}
		
		/**
		 * See inherited documentation
		 * @return AssetVO 
		 */		
		override public function getAsset():AssetVO
		{
			return soundAsset;
		}
		
		/**
		 * See inherited documentation 
		 */		
		override public function clear():void
		{
			super.clear();
			soundAsset = null;
			removeListeners(loader);
			loader = null;
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
			soundAsset = null;
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
			soundAsset.setContent(loader);
			removeListeners(loader);
			super.handleCompleteEvent(event);
		}
	}
}