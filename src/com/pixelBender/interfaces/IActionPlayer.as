package com.pixelBender.interfaces
{
	public interface IActionPlayer
	{
		function startAction(actionID:String, completeCallback:Function):void;
		function pauseAction(actionID:String):void;
		function resumeAction(actionID:String):void;
		function stopAction(actionID:String):void;
		function stopAllActions():void;
	}
}
