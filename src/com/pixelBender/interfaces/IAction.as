package com.pixelBender.interfaces
{
	public interface IAction extends IActionVO, IPauseResume
	{
		function start(completeCallback:Function):void;
		function stop():void;
	}
}
