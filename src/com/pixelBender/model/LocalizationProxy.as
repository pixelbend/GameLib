package com.pixelBender.model
{
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.log.Logger;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class LocalizationProxy extends Proxy implements IDispose
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * All localized texts in dictionary form. It is actually a 3-dimensional key value pair:
		 * 	- level 0 -> key : locale name (en/fr/etc.), value: dictionary
		 *  - level 1 -> key : module identifier, value: dictionary
		 *  - level 2 -> key : text identifier : value: String (the actually localized text)
		 */		
		protected var locales																		:Dictionary;
		
		/**
		 * The current locale language
		 */		
		protected var currentLocale																	:String;		
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function LocalizationProxy(proxyName:String)
		{
			super(proxyName);
			locales = new Dictionary();
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================

		public function getLocale():String
		{
			return currentLocale;
		}

		public function setLocale(newLocale:String):void
		{
			currentLocale = newLocale;
		}
		
		/**
		 * Parse all localized texts
		 * @param localeXML XML
		 */		
		public function parseLocale(localeXML:XML):void
		{
			// Internals
			var xmlLocale:String = String(localeXML.@name),
				moduleList:XMLList,
				module:XML,
				moduleName:String,
				textList:XMLList,
				localizedText:XML,
				localizedTextName:String,
				localeDictionary:Dictionary,
				moduleDictionary:Dictionary;
			// Check locale dictionary
			if (locales[xmlLocale] == null)
			{
				locales[xmlLocale] = new Dictionary();
			}
			localeDictionary = locales[xmlLocale];
			// Create and parse locale modules
			moduleList = localeXML.module;
			for each (module in moduleList) 
			{
				moduleName = String(module.@name);
				if (localeDictionary[moduleName] == null)
				{
					localeDictionary[moduleName] = new Dictionary();
				}
				moduleDictionary = localeDictionary[moduleName];
				// Create texts now
				textList = module.text;
				for each (localizedText in textList) 
				{
					localizedTextName = String(localizedText.@name);
					moduleDictionary[localizedTextName] = localizedText.toString();
				}
			}
		}
		
		/**
		 * Retrieves the localized text for the current locale, given the module and text identifiers.
		 * @param moduleName String
		 * @param textName String
		 * @return String 
		 */		
		public function getLocalizedText(moduleName:String, textName:String):String
		{
			// Internals
			var defaultText:String = "["+moduleName+"]["+textName+"]",
				localeDictionary:Dictionary,
				moduleDictionary:Dictionary; 
			// Check data
			AssertHelpers.assertCondition((locales!=null), "No localization available. Initialize localization proxy first!");
			AssertHelpers.assertCondition((locales[currentLocale]!=null),
											"No localization for current locale[" + currentLocale + "] available. " +
																			"Initialize localization proxy first!");
			// Try retrieve
			localeDictionary = locales[currentLocale];
			// Check module available
			if (localeDictionary[moduleName] == null)
			{
				Logger.warning("The module name["+moduleName+"] was not found!");
				return defaultText;
			}
			// Check text available
			moduleDictionary = localeDictionary[moduleName];
			if (moduleDictionary[textName] == null)
			{
				Logger.warning("The text name["+textName+"] was not found, but module["+moduleName+"] exists!");
				return defaultText;
			}
			// Done
			return moduleDictionary[textName];
		}
		
		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Memory management 
		 */		
		public function dispose():void
		{
			if (locales != null)
			{
				DictionaryHelpers.deleteValues(locales);
				locales = null;
			}
			currentLocale = null;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[LocalizationProxy currentLocale:" + currentLocale + "]";
		}
	}
}