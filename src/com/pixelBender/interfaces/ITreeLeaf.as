package com.pixelBender.interfaces
{
	public interface ITreeLeaf extends IDispose
	{
		function setParent(parent:ITreeNode):void;
		function getParent():ITreeNode;
		function hasParent():Boolean;
		function getName():String;
	}
}