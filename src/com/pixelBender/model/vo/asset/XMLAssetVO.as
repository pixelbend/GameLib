package com.pixelBender.model.vo.asset
{
	import com.pixelBender.constants.GameConstants;

	public class XMLAssetVO extends AssetVO
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The content casted as DisplayObject 
		 */		
		protected var xml																			:XML;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function XMLAssetVO(name:String, url:String)
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
			return GameConstants.ASSET_TYPE_XML;
		}
		
		/**
		 * Custom implementation
		 * @param content DisplayObject
		 */		
		override public function setContent(content:*):void
		{
			xml = content as XML;
			super.setContent(content);
		}
		
		/**
		 * Proper memory management. 
		 */		
		override public function dispose():void
		{
			super.dispose();
			xml = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function getXML():XML
		{
			return xml;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public override function toString():String
		{
			return "[XMLAssetVO name:" + name + " url:" + getFullURL() + "]";
		}
	}
}