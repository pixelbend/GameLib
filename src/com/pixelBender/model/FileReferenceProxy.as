package com.pixelBender.model
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.controller.fileReference.vo.RetrieveFileReferenceContentNotificationVO;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.component.loader.FileLoader;
	import com.pixelBender.model.vo.asset.FileReferenceVO;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.pool.ObjectPoolManager;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * This proxy will be used to store data reference (saved local files) during runtime.
	 * It's intention is to keep references to all files saved during game runtime in order to improve performance.
	 * The file references kept here should be:
	 * 	- pixel perfect images
	 * 	- sprite sheets that are computed based on the screen dimension out of vector graphics
	 */
	public class FileReferenceProxy extends Proxy implements IPauseResume
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Reference to the shared object.
		 * The data in the shared object will be formed as a 2 layer dictionary (in object form):
		 * 	- layer 0 : 
		 * 		- key : group name
		 * 		- value : group file dictionary
		 * 	- layer 1 (group file dictionary)
		 * 		- key : file name 
		 * 		- value : AssetFileReferenceVO instance in object form
		 */
		private var sharedObject															:Object;
		
		/**
		 * The above reference data in proper dictionary form and object instance manner  
		 */		
		private var localFileReferenceDictionary											:Dictionary;

		/**
		 * All the file loaders
		 */
		private var loaders																	:Vector.<FileLoader>;

		/**
		 * Reference to the loader pool
		 */
		private var loaderPool																:ObjectPool;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor
		 * @param proxyName String 
		 */		
		public function FileReferenceProxy(proxyName:String)
		{
			super(proxyName);
			localFileReferenceDictionary = new Dictionary();
			sharedObject = SharedObject.getLocal(proxyName);
			loaders = new Vector.<FileLoader>();
			loaderPool = ObjectPoolManager.getInstance().retrievePool(FileLoader.NAME);
			// Sync from SO
			readFromSharedData();
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================

		/**
		 * Retrieves the file VO to the specified group exists as a reference in the system
		 * @param groupName String
		 * @param fileName String
		 */
		public function getFileReferenceExists(groupName:String, fileName:String):Boolean
		{
			return ((localFileReferenceDictionary != null && localFileReferenceDictionary[groupName] != null) &&
					(localFileReferenceDictionary[groupName][fileName] != null));
		}

		/**
		 * Will add a file reference
		 * @param groupName String
		 * @param fileName String
		 * @param contentToSave ByteArray
		 * @param fileType String
		 * @param originalContent Object
		 * @return Boolean
		 */		
		public function addFileReference(groupName:String, fileName:String, contentToSave:ByteArray, fileType:String,
												originalContent:Object = null):Boolean
		{
			// Data integrity check
			AssertHelpers.assertCondition(groupName != null && groupName.length > 0, "Group name cannot be nul or empty!");
			AssertHelpers.assertCondition(fileName != null && fileName.length > 0, "File name cannot be nul or empty!");
			AssertHelpers.assertCondition(contentToSave != null && contentToSave.length > 0, "File reference content cannot be null or empty!");
			AssertHelpers.assertCondition(!getFileReferenceExists(groupName, fileName), "File reference for ["+groupName+"]["+fileName+"] already exists!");
			// Add entry
			if (localFileReferenceDictionary[groupName] == null )
			{
				localFileReferenceDictionary[groupName] = new Dictionary();
				sharedObject.data[groupName] = {};
			}
			try
			{
				var assetFileVO:FileReferenceVO = new FileReferenceVO(groupName, fileName, fileType),
					parentDirectory:File,
					assetFile:File,
					assetStream:FileStream = new FileStream();
				// Save to file
				assetFile = File.applicationStorageDirectory.resolvePath(assetFileVO.getFullPath());
				parentDirectory = assetFile.parent;
				if (!parentDirectory.exists)
				{
					parentDirectory.createDirectory();
				}
				assetStream.open(assetFile, FileMode.WRITE);
				assetStream.writeBytes(contentToSave, 0, contentToSave.length);
				assetStream.close();
				// Save to SO
				saveSharedData();
				// Save asset file
				assetFileVO.setContent(originalContent);
				// Save dictionaries
				localFileReferenceDictionary[groupName][fileName] = assetFileVO;
				sharedObject.data[groupName][fileName] = FileReferenceVO.toObject(assetFileVO);
				// Done
				return true;
			}
			catch(error:Error)
			{
				Logger.error(this, "Local reference for group[" + groupName + "] file[" + fileName + "] could not be saved. " +
									"Error[" + error + "]");
			}
			return false;
		}

		/**
		 * Will retrieve the file reference content
		 * @param groupName
		 * @param fileName
		 * @return Object
		 */
		public function getFileReferenceContent(groupName:String, fileName:String):Object
		{
			AssertHelpers.assertCondition(getFileReferenceExists(groupName, fileName),
											"File reference for ["+groupName+"]["+fileName+"] does not exist!");
			var fileReference:FileReferenceVO = localFileReferenceDictionary[groupName][fileName];
			return fileReference.getContent();
		}

		/**
		 * Will load the file reference bytes
		 * @param groupName
		 * @param fileName
		 */
		public function loadFileReferenceContent(groupName:String, fileName:String):void
		{
			// Data integrity check
			AssertHelpers.assertCondition(getFileReferenceExists(groupName, fileName),
											"File reference for ["+groupName+"]["+fileName+"] does not exist!");
			// Internals
			var fileReference:FileReferenceVO = localFileReferenceDictionary[groupName][fileName],
				filePath:String = fileReference.getFullPath(),
				file:File = File.applicationStorageDirectory.resolvePath(filePath),
				fileStream:FileStream = new FileStream(),
				fileBytes:ByteArray = new ByteArray(),
				fileLoader:FileLoader;
			// Read bytes
			fileStream.open(file, FileMode.READ);
			fileStream.readBytes(fileBytes);
			fileStream.close();
			// Load
			fileLoader = loaderPool.allocate() as FileLoader;
			loaders.push(fileLoader);
			fileLoader.load(fileReference, fileBytes, handleFileBytesLoaded);
		}
		
		/**
		 * Will remove a file reference from the list.
		 * @param groupName
		 * @param fileName 
		 */		
		public function removeFileReference(groupName:String, fileName:String):void
		{
			// Assert reference exists
			AssertHelpers.assertCondition((getFileReferenceExists(groupName, fileName) != null),
											"File reference for ["+groupName+"]["+fileName+"] doesn't exist!");
			// Internals
			var assetFileVO:FileReferenceVO = localFileReferenceDictionary[groupName][fileName],
				file:File = File.applicationStorageDirectory.resolvePath(assetFileVO.getFullPath());
			// Remove
			assetFileVO.dispose();
			delete localFileReferenceDictionary[groupName][fileName];
			delete sharedObject.data[groupName][fileName];
			file.deleteFile();
			// Save to SO
			saveSharedData();
		}

		/**
		 * Removes a file reference content
		 * @param groupName
		 * @param fileName
		 */
		public function removeFileReferenceContent(groupName:String, fileName:String):void
		{
			// Assert reference exists
			AssertHelpers.assertCondition((getFileReferenceExists(groupName, fileName) != null),
											"File reference for ["+groupName+"]["+fileName+"] doesn't exist!");
			// Internals
			var assetFileVO:FileReferenceVO = localFileReferenceDictionary[groupName][fileName];
			// Remove
			assetFileVO.setContent(null);
		}

		/**
		 * Retrieves the group file reference dictionary 
		 * @return Dictionary 
		 */		
		public function getGroupLocalFileReferences(groupName:String):Dictionary
		{
			return localFileReferenceDictionary[groupName];
		}
		
		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================

		/**
		 * Pauses all active loaders
		 */
		public function pause():void
		{
			IRunnableHelpers.pause(loaders);
		}

		/**
		 * Resumes all active loaders
		 */
		public function resume():void
		{
			IRunnableHelpers.resume(loaders);
		}

		/**
		 * Proper memory management 
		 */		
		public function dispose():void
		{
			loaderPool = null;
			IRunnableHelpers.dispose(loaders);
			loaders = null;
			DictionaryHelpers.deleteValues(localFileReferenceDictionary);
			localFileReferenceDictionary = null;
			sharedObject = null;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[FileReferenceProxy]";
		}

		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		/**
		 * File loaded handler
		 * @param fileLoader FileLoader
		 */
		private function handleFileBytesLoaded(fileLoader:FileLoader):void
		{
			// Internals
			var fileReference:FileReferenceVO = fileLoader.getFile(),
				noteObjectPool:ObjectPool = ObjectPoolManager.getInstance().retrievePool(RetrieveFileReferenceContentNotificationVO.NAME),
				note:RetrieveFileReferenceContentNotificationVO = noteObjectPool.allocate() as RetrieveFileReferenceContentNotificationVO;
			// Initialize note
			note.initialize(fileReference.getDirectoryName(), fileReference.getFileName());
			// Remove loader
			removeLoader(fileLoader);
			// Send note
			note.setFileContents(fileReference.getContent());
			facade.sendNotification(GameConstants.FILE_REFERENCE_LOADED, note);
			// Release note
			noteObjectPool.release(note);
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		/**
		 * Removes the given loader from the active loading loaders
		 * @param fileLoader FileLoader
		 */
		private function removeLoader(fileLoader:FileLoader):void
		{
			var index:int = loaders.indexOf(fileLoader);
			if (index >= 0)
			{
				loaders.splice(index, 1);
			}
			// Return to pool
			fileLoader.clear();
			loaderPool.release(fileLoader);
		}

		/**
		 * Will populate the localFileReferenceDictionary based on the shared data object
		 */		
		private function readFromSharedData():void
		{
			// Internals
			var groupName:String,
				fileName:String,
				group:Object,
				groupDictionary:Dictionary;
			// Parse and create reference dictionary
			for (groupName in sharedObject.data)
			{
				group = sharedObject.data[groupName];
				groupDictionary = new Dictionary();
				localFileReferenceDictionary[groupName] = groupDictionary;
				for (fileName in group)
				{
					groupDictionary[fileName] = FileReferenceVO.fromObject(group[fileName]);
				}
			}
		}
		
		/**
		 * Saves the shared data object
		 */		
		private function saveSharedData():void
		{
			trace(sharedObject.flush());
		}
	}
}