package com.pixelBender.helpers
{
	import com.pixelBender.interfaces.IDispose;

	public class IDisposeHelpers
	{
		/**
		 * Will dispose every IDispose instance found in the disposableInstances parameter given.
		 * Helper function, able to iterate through all usual object containers (array, dictionary, vector)
		 * @param disposableInstances * - iterable object containing IDispose instances
		 */
		public static function dispose(disposableInstances:*):void
		{
			var iDispose:IDispose;
			if (disposableInstances == null)
			{
				return;
			}
			iDispose = disposableInstances as IDispose;
			if (iDispose != null)
			{
				iDispose.dispose();
				return;
			}
			for each (var object:Object in disposableInstances)
			{
				iDispose = object as IDispose;
				if (iDispose != null)
				{
					iDispose.dispose();
				}
			}
		}
	}
}
