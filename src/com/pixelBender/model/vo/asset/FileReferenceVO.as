package com.pixelBender.model.vo.asset
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.interfaces.IDispose;
	
	public class FileReferenceVO implements IDispose
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The asset directory name
		 */
		private var directoryName																:String;

		/**
		 * The local asset file identifier 
		 */
		private var fileName																	:String;

		/**
		 * The asset file assetType (swf/xml/sound)
		 */		
		private var	fileType																	:String;

		/**
		 * The reference content
		 */
		private var content																		:Object;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor
		 * @param directoryName String
		 * @param fileName String
		 * @param fileType String
		 */		
		public function FileReferenceVO(directoryName:String, fileName:String, fileType:String)
		{
			this.directoryName = directoryName;
			this.fileName = fileName;
			this.fileType = fileType;
		}
		
		//==============================================================================================================
		// STATIC API
		//==============================================================================================================
		
		/**
		 * Creates an AssetFileReferenceVO instance based on object
		 * @param object Object
		 * @return FileReferenceVO
		 */		
		public static function fromObject(object:Object):FileReferenceVO
		{
			return new FileReferenceVO(object.directoryName, object.name, object.assetType);
		}
		
		/**
		 * Creates object form out of the given AssetFileReferenceVO instance
		 * @param fileReference AssetFileReferenceVO
		 * @return Object
		 */		
		public static function toObject(fileReference:FileReferenceVO):Object
		{
			return {
						directoryName : fileReference.directoryName,
						name : fileReference.fileName,
						assetType : fileReference.fileType
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
			directoryName = null;
			fileName = null;
			content = null;
			fileType = null;
		}
		
		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getDirectoryName():String
		{
			return directoryName;
		}

		public function getFileName():String
		{
			return fileName;
		}

		public function getContent():Object
		{
			return content;
		}

		public function setContent(value:Object):void
		{
			content = value;
		}

		public function getFullPath():String
		{
			return directoryName + "\\" + fileName + "." + getExtension(fileType)
		}

		private static function getExtension(fileType:String):String
		{
			switch(fileType)
			{
				case GameConstants.ASSET_FILE_REFERENCE_TYPE_IMAGE:
					return GameConstants.ASSET_FILE_REFERENCE_TYPE_IMAGE_EXTENSION;
			}
			AssertHelpers.assertCondition(false, "Unknown file reference type [" + fileType + "]");
			return null;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			var path:String;
			try
			{
				path = getFullPath();
			}
			catch (error:Error)
			{
				path = 	directoryName + "\\" + fileName;
			}
			return "[FileReferenceVO filePath:" + path + "]";
		}
	}
}