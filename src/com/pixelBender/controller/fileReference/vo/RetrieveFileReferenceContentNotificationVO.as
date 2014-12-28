package com.pixelBender.controller.fileReference.vo
{
	public class RetrieveFileReferenceContentNotificationVO extends FileReferenceNotificationVO
	{
		//==============================================================================================================
		// NAME
		//==============================================================================================================

		public static const NAME							:String = "RetrieveFileReferenceContentNotificationVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Reference contents
		 */
		protected var fileContents													:Object;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(groupName:String, fileName:String):RetrieveFileReferenceContentNotificationVO
		{
			initializeNotification(groupName, fileName);
			this.groupName = groupName;
			this.fileName = fileName;
			return this;
		}

		//==============================================================================================================
		// GETTERS / SETTERS
		//==============================================================================================================

		public function getFileContents():Object
		{
			return fileContents;
		}

		public function setFileContents(value:Object):void
		{
			fileContents = value;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public override function toString():String
		{
			return "[RetrieveFileReferenceContentNotificationVO groupName:" + groupName + " fileName: " + fileName + "]";
		}
	}
}
