package com.pixelBender.pool
{
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.interfaces.IDispose;

	import flash.utils.getQualifiedClassName;

	public class ObjectPool implements IDispose
	{
		
		//==============================================================================================================
		// STATIC CONSTANTS
		//==============================================================================================================
		
		public static const DEFAULT_COUNT													:int = 10;
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The class used to create new instances 
		 */		
		private var objectClass																:Class;

		/**
		 * The object qualified class name
		 */
		private var objectClassName															:String;
		
		/**
		 * The list of allocated objects 
		 */		
		private var allocatedObjects														:Array;
		
		/**
		 * All the created objects 
		 */		
		private var availableObjects														:Array;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor
		 * @param objectClass Class
		 * @param count int - the initial number of instances that will be created
		 */		
		public function ObjectPool(objectClass:Class, count:int = DEFAULT_COUNT)
		{
			this.objectClass = objectClass;
			availableObjects = [];
			allocatedObjects = [];
			createObjects(count);
		}
		
		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		public function dispose():void
		{
			IRunnableHelpers.dispose(allocatedObjects);
			IRunnableHelpers.dispose(availableObjects);
			objectClass = null;
			allocatedObjects = null;
			availableObjects = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Will release the allocated object back in the pool. 
		 * @param object Object
		 */		
		public function release(object:Object):void
		{
			var index:int = allocatedObjects.indexOf(object);
			if (index >= 0)
			{
				allocatedObjects.splice(index,1);
				availableObjects.push(object);
			}
		}

		/**
		 * Will allocate a new object
		 * @return Object 
		 */		
		public function allocate():Object
		{
			var allocatedObject:Object;
			if (availableObjects.length == 0)
			{
				createObjects(1);
			}
			allocatedObject = availableObjects.pop();
			allocatedObjects.push(allocatedObject);
			return allocatedObject;
		}

		//==============================================================================================================
		// INTERNAL FUNCTIONALITY
		//==============================================================================================================

		internal function getClass():Class
		{
			return objectClass;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			if (objectClassName == null)
			{
				if (availableObjects.length > 0)
				{
					objectClassName = getQualifiedClassName(availableObjects[0]);
				}
				else if (allocatedObjects.length > 0)
				{
					objectClassName = getQualifiedClassName(allocatedObjects[0]);
				}
			}
			return "[ObjectPool objectClassName:" + objectClassName + "]";
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Will create the given number of new instances
		 * @param count int
		 */		
		private function createObjects(count:int=1):void
		{
			for (var i:int =0; i<count; i++)
			{
				availableObjects.push(new objectClass());
			}
		}
	}
}