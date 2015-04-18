package com.pixelBender.view.popup.vo
{
	public class OpenPopupVO
	{
		//==============================================================================================================
		// NAME
		//==============================================================================================================

		public static const NAME							:String = "OpenPopupVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Popup identifier
		 */
		private var popupName								:String;

		/**
		 * Popup initialization object
		 */
		private var popupVO									:Object;

		//==============================================================================================================
		// INIT
		//==============================================================================================================

		public function initialize(popupName:String, popupVO:Object):void
		{
			this.popupName = popupName;
			this.popupVO = popupVO;
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		public function getPopupName():String
		{
			return popupName;
		}

		public function getPopupVO():Object
		{
			return popupVO;
		}
	}
}