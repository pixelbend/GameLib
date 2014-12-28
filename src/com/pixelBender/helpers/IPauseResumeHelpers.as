package com.pixelBender.helpers
{
	import com.pixelBender.interfaces.IPauseResume;

	public class IPauseResumeHelpers
	{
		/**
		 * Will pause every IPauseResume instance found in the pauseResumeInstance parameter given.
		 * Helper function, able to iterate all usual object containers (array, dictionary, vector)
		 * @param pauseResumeInstances * - iterable object containing IPauseResume instances
		 */
		public static function pause(pauseResumeInstances:*):void
		{
			var iPauseResume:IPauseResume;
			if (pauseResumeInstances == null)
			{
				return;
			}
			iPauseResume = pauseResumeInstances as IPauseResume;
			if (iPauseResume != null)
			{
				iPauseResume.pause();
				return;
			}
			for each (var object:Object in pauseResumeInstances)
			{
				iPauseResume = object as IPauseResume;
				if ( iPauseResume != null )
				{
					iPauseResume.pause();
				}
			}
		}

		/**
		 * Will resume every IPauseResume instance found in the pauseResumeInstance parameter given.
		 * Helper function, able to iterate through all usual object containers (array, dictionary, vector)
		 * @param pauseResumeInstances * - iterable object containing IPauseResume instances
		 */
		public static function resume(pauseResumeInstances:*):void
		{
			var iPauseResume:IPauseResume;
			if (pauseResumeInstances == null)
			{
				return;
			}
			iPauseResume = pauseResumeInstances as IPauseResume;
			if (iPauseResume != null)
			{
				iPauseResume.resume();
				return;
			}
			for each (var object:Object in pauseResumeInstances)
			{
				iPauseResume = object as IPauseResume;
				if ( iPauseResume != null )
				{
					iPauseResume.resume();
				}
			}
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
