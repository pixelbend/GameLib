package com.pixelBender.interfaces
{
	import com.pixelBender.model.vo.asset.AssetVO;

	public interface IAssetLoader extends IPauseResume
	{
		function load(asset:AssetVO, callback:Function):void;
		function getAsset():AssetVO;
		function clear():void;
	}
}