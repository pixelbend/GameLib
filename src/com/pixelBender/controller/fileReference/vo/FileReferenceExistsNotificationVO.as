package com.pixelBender.controller.fileReference.vo
{
	public class FileReferenceExistsNotificationVO extends FileReferenceNotificationVO
	{
		//==============================================================================================================
		// NAME
		//==============================================================================================================

		public static const NAME									:String = "FileReferenceExistsNotificationVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Flag
		 */
		protected var fileExists												:Boolean;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(groupName:String, fileName:String):FileReferenceExistsNotificationVO
		{
			initializeNotification(groupName, fileName);
			fileExists = false;
			return this;
		}

		//==============================================================================================================
		// GETTERS / SETTERS
		//==============================================================================================================

		public function getFileExists():Boolean
		{
			return fileExists;
		}

		public function setFileExists(value:Boolean):void
		{
			fileExists = value;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public override function toString():String
		{
			return "[FileReferenceExistsNotificationVO groupName:" + groupName + " fileName: " +
						fileName + " fileExists:" + fileExists + "]";
		}
	}
}
