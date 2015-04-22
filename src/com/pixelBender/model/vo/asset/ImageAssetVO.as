package com.pixelBender.model.vo.asset
{
	import com.pixelBender.constants.GameConstants;

	import flash.display.Bitmap;

	public class ImageAssetVO extends AssetVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The content casted as Bitmap
		 */
		protected var image																			:Bitmap;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		/**
		 * Constructor
		 * @param name String
		 * @param url String
		 */
		public function ImageAssetVO(name:String, url:String)
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
			return GameConstants.ASSET_TYPE_IMAGE;
		}

		/**
		 * Custom implementation
		 * @param content DisplayObject
		 */
		override public function setContent(content:*):void
		{
			image = content as Bitmap;
			super.setContent(content);
		}

		/**
		 * Proper memory management.
		 */
		override public function dispose():void
		{
			super.dispose();
			if (image != null)
			{
				image.bitmapData.dispose();
				image = null;
			}
		}

		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================

		public function getImage():Bitmap
		{
			return image;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public override function toString():String
		{
			return "[ImageAssetVO name:" + name + " url:" + getFullURL() + "]";
		}
	}
}
