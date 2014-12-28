package com.pixelBender.interfaces
{
	public interface ITreeNode extends ITreeLeaf
	{
		function addChild(child:ITreeLeaf):void;
		function removeChild(child:ITreeLeaf):void;
		function getChildrenVector():Vector.<ITreeLeaf>;
		function getChildAtIndex(index:int):ITreeLeaf;
		function getChild(name:String):ITreeLeaf;
	}
}