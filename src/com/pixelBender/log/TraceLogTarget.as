package com.pixelBender.log
{
	import com.pixelBender.interfaces.ILogTarget;
	
	public class TraceLogTarget implements ILogTarget
	{
		//==============================================================================================================
		// ILogTarget IMPLEMENTATION
		//==============================================================================================================
		
		public function info(message:String):void
		{
			trace("[INFO]" + message);
		}
		
		public function debug(message:String):void
		{
			trace("[DEBUG]" + message);
		}
		
		public function warning(message:String):void
		{
			trace("[WARNING]" + message);
		}
		
		public function error(message:String):void
		{
			trace("[ERROR]" + message);
		}
		
		public function fatal(message:String):void
		{
			trace("[FATAL]" + message);
		}

		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================

		public function dispose():void
		{
			// Nothing to do I guess
		}
	}
}