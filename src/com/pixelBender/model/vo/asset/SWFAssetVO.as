package com.pixelBender.model.vo.asset
{
	import com.pixelBender.constants.GameConstants;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	public class SWFAssetVO extends AssetVO
	{
	
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The content casted as DisplayObject 
		 */		
		protected var swf																			:DisplayObject;
		
		/**
		 * The content casted as MovieClip 
		 */		
		protected var movieSwf																		:MovieClip;
		
		/**
		 * The content casted as Bitmap 
		 */		
		protected var image																			:Bitmap;
		
		/**
		 * The asset application domain. Useful for graphic linkages
		 */		
		protected var applicationDomain																:ApplicationDomain;
		
		/**
		 * The content associated bytes. Useful to clone SWFs.
		 */		
		protected var bytes																			:ByteArray;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor 
		 * @param name String
		 * @param url String
		 */		
		public function SWFAssetVO(name:String, url:String)
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
			return GameConstants.ASSET_TYPE_SWF;
		}
		
		/**
		 * Custom implementation
		 * @param content DisplayObject
		 */		
		override public function setContent(content:*):void
		{
			swf = content as DisplayObject;
			movieSwf = content as MovieClip;
			image = content as Bitmap;
			if (content == null)
			{
				bytes.clear();
				bytes = null;
			}
			super.setContent(content);
		}
		
		/**
		 * Proper memory management. 
		 */		
		override public function dispose():void
		{
			super.dispose();
			if (bytes != null)
			{
				bytes.clear();
				bytes = null;
			}
			image = null;
			movieSwf = null;
			swf = null;
		}
		
		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================
		
		public function getSwf():DisplayObject
		{
			return swf;
		}
		
		public function getMovieSwf():MovieClip
		{
			return movieSwf;
		}
		
		public function getImage():Bitmap
		{
			return image;
		}
		
		public function getApplicationDomain():ApplicationDomain
		{
			return applicationDomain;
		}
		
		public function setApplicationDomain(appDom:ApplicationDomain):void
		{
			applicationDomain = appDom;
		}
		
		public function getBytes():ByteArray
		{
			return bytes;
		}
				
		public function setBytes(bytes:ByteArray):void
		{
			this.bytes = bytes;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public override function toString():String
		{
			return "[SWFAssetVO name:" + name + " url:" + getFullURL() + "]";
		}
	}
}