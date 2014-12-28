package com.pixelBender.helpers
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.controller.fileReference.vo.AddFileReferenceNotificationVO;
	import com.pixelBender.controller.fileReference.vo.FileReferenceExistsNotificationVO;
	import com.pixelBender.controller.fileReference.vo.FileReferenceNotificationVO;
	import com.pixelBender.controller.fileReference.vo.RetrieveFileReferenceContentNotificationVO;
	import com.pixelBender.pool.ObjectPool;

	import flash.utils.ByteArray;

	public class FileReferenceHelpers extends GameHelpers
	{
		//==============================================================================================================
		// STATIC API
		//==============================================================================================================

		/**
		 * Initializes all needed object pools
		 */
		public static function initialize():void
		{
			objectPoolMap[FileReferenceExistsNotificationVO.NAME] = objectPoolManager.retrievePool(FileReferenceExistsNotificationVO.NAME);
			objectPoolMap[AddFileReferenceNotificationVO.NAME] = objectPoolManager.retrievePool(AddFileReferenceNotificationVO.NAME);
			objectPoolMap[RetrieveFileReferenceContentNotificationVO.NAME] = objectPoolManager.retrievePool(RetrieveFileReferenceContentNotificationVO.NAME);
			objectPoolMap[FileReferenceNotificationVO.NAME] = objectPoolManager.retrievePool(FileReferenceNotificationVO.NAME);
		}

		/**
		 * Retrieves if the file assigned to the specified group exists as a reference in the system
		 * @param groupName String
		 * @param fileName String
		 */
		public static function retrieveFileReferenceExists(groupName:String, fileName:String):Boolean
		{
			var pool:ObjectPool = objectPoolMap[FileReferenceExistsNotificationVO.NAME],
				noteVO:FileReferenceExistsNotificationVO = objectPoolMap[FileReferenceExistsNotificationVO.NAME].allocate() as FileReferenceExistsNotificationVO;
			noteVO.initialize(groupName, fileName);
			facade.sendNotification(GameConstants.RETRIEVE_FILE_REFERENCE_EXISTS, noteVO);
			pool.release(noteVO);
			return noteVO.getFileExists();
		}

		/**
		 * Will add a new file reference to the application storage
		 * @param groupName
		 * @param fileName
		 * @param contentToSave
		 * @param fileType
		 * @param originalContent
		 * @return Boolean
		 */
		public static function addFileReference(groupName:String, fileName:String, contentToSave:ByteArray,
														fileType:String, originalContent:Object = null):Boolean
		{
			var pool:ObjectPool = objectPoolMap[AddFileReferenceNotificationVO.NAME],
				noteVO:AddFileReferenceNotificationVO = pool.allocate() as AddFileReferenceNotificationVO;
			noteVO.initialize(groupName, fileName, contentToSave, fileType, originalContent);
			facade.sendNotification(GameConstants.ADD_FILE_REFERENCE, noteVO);
			pool.release(noteVO);
			return noteVO.getSuccess();
		}

		/**
		 * Retrieves if the file assigned to the specified group exists as a reference in the system
		 * @param groupName String
		 * @param fileName String
		 */
		public static function retrieveFileReferenceContent(groupName:String, fileName:String):Object
		{
			var pool:ObjectPool = objectPoolMap[RetrieveFileReferenceContentNotificationVO.NAME],
				noteVO:RetrieveFileReferenceContentNotificationVO = pool.allocate() as RetrieveFileReferenceContentNotificationVO;
			noteVO.initialize(groupName, fileName);
			facade.sendNotification(GameConstants.RETRIEVE_FILE_REFERENCE_CONTENT, noteVO);
			pool.release(noteVO);
			return noteVO.getFileContents();
		}

		/**
		 * Will load the file reference identified by groupName/fileName
		 * When the loading procedure is complete, a GameConstants.LOAD_FILE_REFERENCE notification will be dispatched.
		 * 	The note is a RetrieveFileReferenceContentNotificationVO
		 * @param groupName String
		 * @param fileName String
		 */
		public static function loadFileReference(groupName:String, fileName:String):void
		{
			var pool:ObjectPool = objectPoolMap[RetrieveFileReferenceContentNotificationVO.NAME],
				noteVO:FileReferenceNotificationVO = pool.allocate() as FileReferenceNotificationVO;
			noteVO.initializeNotification(groupName, fileName);
			facade.sendNotification(GameConstants.LOAD_FILE_REFERENCE, noteVO);
			pool.release(noteVO);
		}

		/**
		 * Removes the file reference identified by groupName/fileName
		 * @param groupName
		 * @param fileName
		 */
		public static function removeFileReference(groupName:String, fileName:String):void
		{
			var pool:ObjectPool = objectPoolMap[RetrieveFileReferenceContentNotificationVO.NAME],
				noteVO:FileReferenceNotificationVO = pool.allocate() as FileReferenceNotificationVO;
			noteVO.initializeNotification(groupName, fileName);
			facade.sendNotification(GameConstants.REMOVE_FILE_REFERENCE, noteVO);
			pool.release(noteVO);
		}

		/**
		 * Removes the file reference content (for memory optimization reasons) identified by groupName/fileName
		 * @param groupName
		 * @param fileName
		 */
		public static function removeFileReferenceContent(groupName:String, fileName:String):void
		{
			var pool:ObjectPool = objectPoolMap[RetrieveFileReferenceContentNotificationVO.NAME],
				noteVO:FileReferenceNotificationVO = pool.allocate() as FileReferenceNotificationVO;
			noteVO.initializeNotification(groupName, fileName);
			facade.sendNotification(GameConstants.REMOVE_FILE_REFERENCE_CONTENT, noteVO);
			pool.release(noteVO);
		}
	}
}
