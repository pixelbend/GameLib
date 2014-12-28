package com.pixelBender.model.vo
{
	import com.pixelBender.interfaces.IDispose;

	public class InitTransitionVO implements IDispose
	{

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The unique identifier of the transition view that will be initialized once the global package has loaded. 
		 */		
		private var transitionName															:String;
		
		/**
		 * The Swf asset name. It's content will be set as the transition view component. 
		 */		
		private var initSWFAssetVOName														:String;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function InitTransitionVO(transitionName:String, swfAssetName:String)
		{
			this.transitionName = transitionName;
			this.initSWFAssetVOName = swfAssetName;
		}
		
		//==============================================================================================================
		// GETTERS
		//==============================================================================================================
		
		public function getTransitionName():String
		{
			return transitionName;
		}
		
		public function getInitSWFAssetVOName():String
		{
			return initSWFAssetVOName;
		}
		
		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Memory management 
		 */		
		public function dispose():void
		{
			transitionName = null;
			initSWFAssetVOName = null;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[InitTransitionVO transitionName:" + transitionName +
						" initSWFAssetVOName: " + initSWFAssetVOName + "]";
		}
	}
}