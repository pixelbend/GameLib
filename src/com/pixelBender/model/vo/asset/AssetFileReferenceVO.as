package com.pixelBender.model.vo.asset
{
	import com.pixelBender.interfaces.IDispose;
	
	public class AssetFileReferenceVO implements IDispose
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The local asset file identifier 
		 */		
		private var name																		:String;
		
		/**
		 * The local asset file URL (relative to the running machine) 
		 */		
		private var localURL																	:String;
		
		/**
		 * The asset file assetType (swf/xml/sound)
		 */		
		private var	assetType																	:String;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor
		 * @param fileName String
		 * @param fileURL String
		 * @param assetType String
		 */		
		public function AssetFileReferenceVO(fileName:String, fileURL:String, assetType:String)
		{
			this.name = fileName;
			this.localURL = fileURL;
			this.assetType = assetType;
		}
		
		//==============================================================================================================
		// STATIC API
		//==============================================================================================================
		
		/**
		 * Creates an AssetFileReferenceVO instance based on object
		 * @param object Object
		 * @return AssetFileReferenceVO
		 */		
		public static function fromObject(object:Object):AssetFileReferenceVO
		{
			return new AssetFileReferenceVO(object.name, object.localURL, object.assetType);
		}
		
		/**
		 * Creates object form out of the given AssetFileReferenceVO instance
		 * @param fileReference AssetFileReferenceVO
		 * @return Object
		 */		
		public static function toObject(fileReference:AssetFileReferenceVO):Object
		{
			return {
						name : fileReference.name,
						localURL : fileReference.localURL,
						assetType : fileReference.assetType
					};
		}
		
		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Proper memory management
		 */		
		public function dispose():void
		{
			name = null;
			localURL = null;
			assetType = null;
		}
		
		//==============================================================================================================
		// GETTERS
		//==============================================================================================================
		
		public function getName():String 
		{
			return name;
		}
		
		public function getURL():String 
		{
			return localURL;
		}
		
		public function getType():String 
		{
			return assetType;
		}
	}
}