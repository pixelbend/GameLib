package com.pixelBender.interfaces
{
	import com.pixelBender.model.vo.asset.AssetPackageVO;
	import com.pixelBender.model.vo.asset.AssetVO;
	
	import org.puremvc.as3.interfaces.IProxy;

	public interface IAssetProxy extends IPauseResume,IProxy
	{
		function registerPackage(assetPackage:AssetPackageVO):void;
		function getPackage(name:String):*;
		function getAsset(packageName:String, assetName:String):AssetVO;
		function clearPackage(name:String):void;
		function clearAsset(packageName:String, name:String):void;
		function setGenericPath(path:String):void;
		function setLocalePath(path:String):void;
		function addPackageToLoadQueue(name:String, includeSubPackages:Boolean=true):void;
		function load():void;
	}
}