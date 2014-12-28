package com.pixelBender.interfaces
{
	public interface ILogTarget extends IDispose
	{
		function info(message:String):void;
		function debug(message:String):void;
		function warning(message:String):void;
		function error(message:String):void;
		function fatal(message:String):void;
	}
}