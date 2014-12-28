package com.pixelBender.controller.fileReference.vo
{
	import flash.utils.ByteArray;

	public class AddFileReferenceNotificationVO extends FileReferenceNotificationVO
	{
		//==============================================================================================================
		// NAME
		//==============================================================================================================

		public static const NAME										:String = "AddFileReferenceNotificationVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The content as byte array
		 */
		private var contentToSave													:ByteArray;

		/**
		 * The file type
		 */
		private var fileType														:String;

		/**
		 * Original content from which the byte array was extracted
		 */
		private var originalContent													:Object;

		/**
		 * Flag if the save operation was successful or not
		 */
		private var success															:Boolean;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(groupName:String, fileName:String, contentToSave:ByteArray, fileType:String,
								   		originalContent:Object = null):AddFileReferenceNotificationVO
		{
			initializeNotification(groupName, fileName);
			this.contentToSave = contentToSave;
			this.fileType = fileType;
			this.originalContent = originalContent;
			return this;
		}

		//==============================================================================================================
		// GETTERS / SETTERS
		//==============================================================================================================

		public function getContentToSave():ByteArray
		{
			return contentToSave;
		}

		public function getFileType():String
		{
			return fileType;
		}

		public function getOriginalContent():Object
		{
			return originalContent;
		}

		public function getSuccess():Boolean
		{
			return success;
		}

		public function setSuccess(value:Boolean):void
		{
			success = value;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public override function toString():String
		{
			return "[AddFileReferenceNotificationVO groupName:" + groupName + " fileName: " + fileName +
						" fileType:" + fileType + "]";
		}
	}
}
