package com.pixelBender.helpers
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.model.LocalizationProxy;

	/**
	 * Helper class that will reference the localization proxy.
	 * 	The hard coupled reference is kept due to optimization reasons.
	 */	
	public class LocalizationHelpers extends GameHelpers implements IDispose
	{
		
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================
		
		/**
		 * Reference to the localization proxy
		 */		
		private static var localizationProxy											:LocalizationProxy;

		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Memory management 
		 */		
		public function dispose():void
		{
			localizationProxy = null;
		}
		
		//==============================================================================================================
		// STATIC API
		//==============================================================================================================

		/**
		 * Will create the static instance 
		 */		
		public static function initialize():void
		{
			if (localizationProxy == null)
			{
				localizationProxy = facade.retrieveProxy(GameConstants.LOCALIZATION_PROXY_NAME) as LocalizationProxy;
				AssertHelpers.assertCondition(localizationProxy != null,
						"Localization proxy not yet created. Call helper methods facade has been initialized!");
			}
		}
		
		/**
		 * Memory management
		 */		
		public static function dispose():void
		{
			localizationProxy = null;
		}
		
		/**
		 * Retrieves the localized text value given the correct moduleName/textName.
		 * @param moduleName String
		 * @param textName String
		 * @return String 
		 */		
		public static function getLocalizedText(moduleName:String, textName:String):String
		{
			return localizationProxy.getLocalizedText(moduleName, textName);
		}

		/**
		 * Retrieves the current active locale language
		 * @return String
		 */
		public static function getCurrentLocale():String
		{
			return localizationProxy.getLocale();
		}

		/**
		 * Changes the application locale
		 * @param newLocale String
		 */
		public static function changeLocale(newLocale:String):void
		{
			facade.sendNotification(GameConstants.CHANGE_APPLICATION_LOCALE, newLocale);
		}
	}
}