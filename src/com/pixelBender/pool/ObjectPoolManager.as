package com.pixelBender.pool
{
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.interfaces.IDispose;

	import flash.utils.Dictionary;

	public class ObjectPoolManager implements IDispose
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static var instance									:ObjectPoolManager;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Object pool map
		 */
		private var poolMap											:Dictionary;

		//==============================================================================================================
		// CONSTRUCTOR. Should be private :(
		//==============================================================================================================

		public function ObjectPoolManager(enforcer:SingletonEnforcer)
		{
			AssertHelpers.assertCondition(enforcer != null, "Enforcer cannot be null");
			poolMap = new Dictionary(false);
		}

		//==============================================================================================================
		// STATIC API
		//==============================================================================================================

		public static function getInstance():ObjectPoolManager
		{
			if (instance == null)
			{
				instance = new ObjectPoolManager(new SingletonEnforcer());
			}
			return instance;
		}

		public static function dispose():void
		{
			if (instance != null)
			{
				instance.dispose();
				instance = null;
			}
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		/**
		 * Registers ( if needed ) a new object pool
		 * @param poolName String
		 * @param poolClass Class
		 * @param initialObjectsCount int
		 * @return ObjectPool
		 */
		public function registerPool(poolName:String, poolClass:Class, initialObjectsCount:int = ObjectPool.DEFAULT_COUNT):ObjectPool
		{
			if (poolMap[poolName] != null)
			{
				// Check class
				if (ObjectPool(poolMap[poolName]).getClass() != poolClass)
				{
					throw new ArgumentError(this + "Pool with name:" + poolName + "is already registered but with a different class!");
				}
			}
			else
			{
				poolMap[poolName] = new ObjectPool(poolClass, initialObjectsCount);
			}
			return poolMap[poolName];
		}

		/**
		 * Retrieves an already registered object pool
		 * @param poolName String - identifier
		 * @return ObjectPool
		 */
		public function retrievePool(poolName:String):ObjectPool
		{
			AssertHelpers.assertCondition(poolMap[poolName] != null, "Object pool with name:" + poolName + " does not exist!");
			return poolMap[poolName];
		}

		/**
		 * Removes an already registered object pool
		 * @param poolName String - identifier
		 */
		public function removeObjectPool(poolName:String):void
		{
			AssertHelpers.assertCondition(poolMap[poolName] != null, "Object pool with name:" + poolName + " does not exist!");
			ObjectPool(poolMap[poolName]).dispose();
			delete poolMap[poolName];
		}

		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================

		/**
		 * Proper memory management
		 */
		public function dispose():void
		{
			DictionaryHelpers.deleteValues(poolMap, true);
			poolMap = null;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[ObjectPoolManager]";
		}
	}
}
class SingletonEnforcer{}
