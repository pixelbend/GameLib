package com.pixelBender.controller.fileReference.vo
{
	public class FileReferenceNotificationVO
	{
		//==============================================================================================================
		// NAME
		//==============================================================================================================

		public static const NAME										:String = "FileReferenceNotificationVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The group for the file
		 */
		protected var groupName														:String;

		/**
		 * File identifier
		 */
		protected var fileName														:String;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initializeNotification(groupName:String, fileName:String):FileReferenceNotificationVO
		{
			this.groupName = groupName;
			this.fileName = fileName;
			return this;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getGroupName():String
		{
			return groupName;
		}

		public function getFileName():String
		{
			return fileName;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[FileReferenceNotificationVO groupName:" + groupName + " fileName: " + fileName + "]";
		}
	}
}
