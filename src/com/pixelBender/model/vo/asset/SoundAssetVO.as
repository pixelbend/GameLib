package com.pixelBender.model.vo.asset
{
	import com.pixelBender.constants.GameConstants;
	
	import flash.media.Sound;

	public class SoundAssetVO extends AssetVO
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The content casted as Sound 
		 */		
		protected var sound																			:Sound;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function SoundAssetVO(name:String, url:String)
		{
			super(name, url);
		}
		
		//==============================================================================================================
		// PUBLIC OVERRIDES
		//==============================================================================================================
		
		/**
		 * The appropriate asset type.
		 * @return String 
		 */	
		override public function getType():String
		{
			return GameConstants.ASSET_TYPE_SOUND;
		}
		
		/**
		 * Custom implementation
		 * @param content DisplayObject
		 */		
		override public function setContent(content:*):void
		{
			sound = content as Sound;
			super.setContent(content);
		}
		
		/**
		 * Proper memory management. 
		 */		
		override public function dispose():void
		{
			super.dispose();
			sound = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function getSound():Sound
		{
			return sound;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public override function toString():String
		{
			return "[SoundAssetVO name:" + name + " url:" + getFullURL() + "]";
		}
	}
}