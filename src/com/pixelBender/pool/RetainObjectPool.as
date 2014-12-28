package com.pixelBender.pool
{
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.interfaces.IDispose;
	import flash.utils.getQualifiedClassName;

	public class RetainObjectPool implements IDispose
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

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
		 * @param seed Object - initial object. Needed to compute qualified class name verification
		 */
		public function RetainObjectPool(seed:Object)
		{
			AssertHelpers.assertCondition(seed != null, "Initial seed cannot be null!");
			objectClassName = getQualifiedClassName(seed);
			availableObjects = [seed];
			allocatedObjects = [];
		}

		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================

		/**
		 * Proper memory management
		 */
		public function dispose():void
		{
			IRunnableHelpers.dispose(allocatedObjects);
			IRunnableHelpers.dispose(availableObjects);
			allocatedObjects = null;
			availableObjects = null;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		/**
		 * Retrieves if current pool has available objects left
		 * @return Boolean
		 */
		public function getPoolEmpty():Boolean
		{
			return availableObjects.length == 0;
		}

		/**
		 * Will retain new object
		 * @param object Object
		 */
		public function retain(object:Object):void
		{
			AssertHelpers.assertCondition(getQualifiedClassName(object) == objectClassName, "Object class does not match!");
			availableObjects.push(object);
		}

		/**
		 * Will release the allocated object back in the pool.
		 * @param object Object
		 */
		public function release(object:Object):void
		{
			AssertHelpers.assertCondition(getQualifiedClassName(object) == objectClassName, "Object class does not match!");
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
			if (getPoolEmpty())
			{
				return null;
			}
			allocatedObject = availableObjects.pop();
			allocatedObjects.push(allocatedObject);
			return allocatedObject;
		}
	}
}
