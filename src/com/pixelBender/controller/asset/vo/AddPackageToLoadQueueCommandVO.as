package com.pixelBender.controller.asset.vo
{
	public class AddPackageToLoadQueueCommandVO
	{
		
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * The asset package name.
		 */		
		private var packageName																			:String;
		
		/**
		 * Flag whether we should include or not sub packages. 
		 */		
		private var includeSubPackages																	:Boolean;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function AddPackageToLoadQueueCommandVO(packageName:String, includeSubPackages:Boolean=true)
		{
			this.packageName = packageName;
			this.includeSubPackages = includeSubPackages;
		}
		
		//==============================================================================================================
		// GETTERS
		//==============================================================================================================
		
		public function getPackageName():String
		{
			return packageName;
		}

		public function getIncludeSubPackages():Boolean
		{
			return includeSubPackages;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[AddPackageToLoadQueueCommandVO packageName:" + packageName +
						" includeSubPackages:" + includeSubPackages + "]";
		}
	}
}