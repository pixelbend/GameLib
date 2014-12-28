package com.pixelBender.helpers
{
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.pool.ObjectPoolManager;

	import flash.utils.Dictionary;

	public class GameHelpers
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		/**
		 * Static private instance
		 */
		protected static var facade																:GameFacade;

		/**
		 * Reference to the object pool manager
		 */
		protected static var objectPoolManager													:ObjectPoolManager;

		/**
		 * Reference to a common pool map
		 */
		protected static var objectPoolMap														:Dictionary;

		//==============================================================================================================
		// STATIC FUNCTIONS
		//==============================================================================================================

		public static function initialize(gameFacade:GameFacade):void
		{
			facade = gameFacade;
			objectPoolManager = ObjectPoolManager.getInstance();
			objectPoolMap = new Dictionary(false);
		}

		public static function dispose():void
		{
			if (objectPoolMap != null)
			{
				for (var key:String in objectPoolMap)
				{
					objectPoolManager.removeObjectPool(key);
					delete objectPoolMap[key];
				}
				objectPoolMap = null;
			}
			objectPoolManager = null;
			facade = null;
		}
	}
}
