package com.pixelBender.log
{
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.interfaces.ILogTarget;
	
	public class Logger implements IDispose
	{
		//==============================================================================================================
		// PUBLIC CONSTANTS
		//==============================================================================================================

		public static const LEVEL_VERBOSE									:int = 1 << 0;
		public static const LEVEL_INFO										:int = 1 << 1;
		public static const LEVEL_WARNING									:int = 1 << 2;
		public static const LEVEL_ERROR										:int = 1 << 3;

		//==============================================================================================================
		// PRIVATE CONSTANTS
		//==============================================================================================================
		
		private static const SPACE											:String = " ";
		private static const AVAILABLE_LOG_LEVELS							:Vector.<int> = new <int> [
																										LEVEL_VERBOSE,
																										LEVEL_INFO,
																										LEVEL_ERROR,
																										LEVEL_ERROR
																										];

		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================
		
		/**
		 * Single static instance 
		 */		
		private static var instance											:Logger;
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The available log targets
		 */		
		private var logTargets												:Vector.<ILogTarget>;

		/**
		 * Log level mask. Used to identify which logs are eligible for output
		 */
		private var logLevelMask											:int;

		
		//==============================================================================================================
		// STATIC API
		//==============================================================================================================

		/**
		 * Creates the logger instance
		 */
		public static function createInstance():void
		{
			if (instance == null)
			{
				instance = new Logger();
			}
		}

		/**
		 * Adds a new log target in the known targets list
		 * @param logTarget ILogTarget
		 */
		public static function addLogTarget(logTarget:ILogTarget):void
		{
			AssertHelpers.assertCondition(logTarget != null, "Log target cannot be null!");
			instance.logTargets.push(logTarget);
		}

		/**
		 * Activates a certain log level mask. Will start logging the corresponding messages.
		 * @param logLevel int. One of the Logger constants
		 */
		public static function activateLogLevel(logLevel:int):void
		{
			assertLogLevel(logLevel);
			if (!BitMaskHelpers.isBitActive(instance.logLevelMask, logLevel))
			{
				instance.logLevelMask = BitMaskHelpers.addBit(instance.logLevelMask, logLevel);
			}
		}

		/**
		 * Deactivates a certain log level mask. Will suppress the corresponding log.
		 * @param logLevel int. One of the Logger constants
		 */
		public static function deactivateLogLevel(logLevel:int):void
		{
			assertLogLevel(logLevel);
			if (BitMaskHelpers.isBitActive(instance.logLevelMask, logLevel))
			{
				instance.logLevelMask = BitMaskHelpers.removeBit(instance.logLevelMask, logLevel);
			}
		}

		/**
		 * Logs a debug message
		 * @param messages Array
		 */
		public static function debug(...messages):void
		{
			instance.debug.apply(instance, messages);
		}

		/**
		 * Logs a system info message
		 * @param messages String
		 */
		public static function info(...messages):void
		{
			instance.info.apply(instance, messages);
		}
		
		/**
		 * Logs a warning message.
		 * Warnings are code occurrences that did not function properly, but the system was able to resolve them.
		 * @param messages Array
		 */
		public static function warning(...messages):void
		{
			instance.warning.apply(instance, messages);
		}
		
		/**
		 * Logs an error message.
		 * Errors are code occurrences that did not function properly, but the system was able to go past them
		 * 	without any warranty that the system is now stable.
		 * @param messages String
		 */
		public static function error(...messages):void
		{
			instance.error.apply(instance, messages);
		}
		
		/**
		 * Logs a fatal error message.
		 * Fatal errors are code occurrences that will most likely crash the system.
		 * @param messages String
		 */
		public static function fatal(...messages):void
		{
			instance.fatal.apply(instance, messages);
		}

		/**
		 * Static dispose 
		 */		
		public static function dispose():void
		{
			instance.dispose();
			instance = null;
		}

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor 
		 */		
		public function Logger()
		{
			logTargets = new Vector.<ILogTarget>();
			logTargets.push(new TraceLogTarget());
			logLevelMask = LEVEL_VERBOSE | LEVEL_INFO | LEVEL_WARNING | LEVEL_ERROR;
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		protected function debug(...messages:Array):void
		{
			if (BitMaskHelpers.isBitActive(logLevelMask, LEVEL_VERBOSE))
			{
				var availableTargets:Vector.<ILogTarget> = logTargets,
					logTarget:ILogTarget;
				for each (logTarget in availableTargets)
				{
					logTarget.debug(messages.join(SPACE));
				}
			}
		}

		protected function info(...messages:Array):void
		{
			if (BitMaskHelpers.isBitActive(logLevelMask, LEVEL_INFO))
			{
				var availableTargets:Vector.<ILogTarget> = logTargets,
					logTarget:ILogTarget;
				for each (logTarget in availableTargets)
				{
					logTarget.info(messages.join(SPACE));
				}
			}
		}

		protected function warning(...messages:Array):void
		{
			if (BitMaskHelpers.isBitActive(logLevelMask, LEVEL_WARNING))
			{
				var availableTargets:Vector.<ILogTarget> = logTargets,
					logTarget:ILogTarget;
				for each (logTarget in availableTargets)
				{
					logTarget.warning(messages.join(SPACE));
				}
			}
		}

		protected function error(...messages:Array):void
		{
			if (BitMaskHelpers.isBitActive(logLevelMask, LEVEL_ERROR))
			{
				var availableTargets:Vector.<ILogTarget> = logTargets,
					logTarget:ILogTarget;
				for each (logTarget in availableTargets)
				{
					logTarget.error(messages.join(SPACE));
				}
			}
		}

		protected function fatal(...messages:Array):void
		{
			var availableTargets:Vector.<ILogTarget> = logTargets,
				logTarget:ILogTarget;
			for each (logTarget in availableTargets)
			{
				logTarget.info(messages.join(SPACE));
			}
		}

		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Memory management 
		 */		
		public function dispose():void
		{
			IRunnableHelpers.dispose(logTargets);
			logTargets = null;
		}

		//==============================================================================================================
		// STATIC LOCALS
		//==============================================================================================================

		private static function assertLogLevel(logLevel:int):void
		{
			AssertHelpers.assertCondition(AVAILABLE_LOG_LEVELS.indexOf(logLevel) >= 0, "Log level unrecognized! " +
					"Use one of the provided Logger constants!");
		}
	}
}