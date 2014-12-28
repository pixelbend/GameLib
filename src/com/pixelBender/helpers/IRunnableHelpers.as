package com.pixelBender.helpers
{
	import com.pixelBender.interfaces.IRunnable;

	public class IRunnableHelpers
	{
		
		//==============================================================================================================
		// STATIC API
		//==============================================================================================================
		
		/**
		 * Will start every IRunnable instance found in the runnableInstances parameter given.
		 * Helper function, able to iterate all usual object containers (array, dictionary, vector)
		 * @param runnableInstances * - iterable object containing IRunnable instances
		 */
		public static function start(runnableInstances:*):void
		{
			var iRunnable:IRunnable;
			if (runnableInstances == null)
			{
				return;
			}
			iRunnable = runnableInstances as IRunnable;
			if (iRunnable != null)
			{
				runnableInstances.start();
				return;
			}
			for each (var iterable:Object in runnableInstances)
			{
				iRunnable = iterable as IRunnable;
				if ( iRunnable != null )
				{
					iRunnable.start();
				}
			}
		}
		
		/**
		 * Will pause every IPauseResume instance found in the pauseResumeInstance parameter given.
		 * Helper function, able to iterate all usual object containers (array, dictionary, vector)
		 * @param pauseResumeInstances * - iterable object containing IPauseResume instances
		 */
		public static function pause(pauseResumeInstances:Object):void
		{
			IPauseResumeHelpers.pause(pauseResumeInstances);
		}
		
		/**
		 * Will resume every IPauseResume instance found in the pauseResumeInstance parameter given.
		 * Helper function, able to iterate through all usual object containers (array, dictionary, vector)
		 * @param pauseResumeInstances * - iterable object containing IPauseResume instances
		 */
		public static function resume(pauseResumeInstances:Object):void
		{
			IPauseResumeHelpers.resume(pauseResumeInstances);
		}

		/**
		 * Will dispose every IDispose instance found in the disposableInstances parameter given.
		 * Helper function, able to iterate through all usual object containers (array, dictionary, vector)
		 * @param disposableInstances * - iterable object containing IDispose instances
		 */
		public static function dispose(disposableInstances:Object):void
		{
			IDisposeHelpers.dispose(disposableInstances);
		}
	}
}