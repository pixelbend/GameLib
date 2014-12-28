package com.pixelBender.controller.asset.vo
{
	import com.pixelBender.model.vo.asset.AssetPackageVO;

	public class ParseAndRegisterAssetPackageCommandVO
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The XML 
		 */		
		private var packageXML																:XML;
		
		/**
		 * The parent package VO 
		 */		
		private var parentPackage															:AssetPackageVO;
		
		/**
		 * Flag whether the package is the global packaged 
		 */		
		private var globalPackage															:Boolean;
		
		/**
		 * Flag whether the newly registered package should also be added to the load queue 
		 */		
		private var addToQueue																:Boolean;
		
		/**
		 * The result of the notification 
		 */		
		private var registeredPackage														:AssetPackageVO;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function ParseAndRegisterAssetPackageCommandVO(xml:XML, parent:AssetPackageVO,
															  	globalPackage:Boolean=false, addToQueue:Boolean=false)
		{
			packageXML = xml;
			parentPackage = parent;
			this.globalPackage = globalPackage;
			this.addToQueue = addToQueue;
		}
		
		//==============================================================================================================
		// GETTERS
		//==============================================================================================================
		
		public function getPackageXML():XML
		{
			return packageXML;
		}
		
		public function getParentPackage():AssetPackageVO
		{
			return parentPackage;
		}
		
		public function getIsGlobalPackage():Boolean
		{
			return globalPackage;
		}
		
		public function getAddToQueue():Boolean
		{
			return addToQueue;
		}
		
		public function getRegisteredPackage():AssetPackageVO
		{
			return registeredPackage;
		}
		
		public function setRegisteredPackage(value:AssetPackageVO):void
		{
			registeredPackage = value;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[ParseAndRegisterAssetPackageCommandVO]";
		}
	}
}