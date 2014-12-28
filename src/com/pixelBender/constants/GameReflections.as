package com.pixelBender.constants
{
	import flash.utils.Dictionary;

	public class GameReflections
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The reflection type dictionary. Every key is another dictionary which hold reflection name
		 * 	identifiers as keys and class names as values
		 */		
		private static var reflectionDictionary										:Dictionary = new Dictionary();
		
		//==============================================================================================================
		// STATIC API
		//==============================================================================================================
		
		/**
		 * Will populate the reflection dictionary
		 * @param reflectionType String
		 * @param name String
		 * @param className String
		 * 
		 */		
		public static function addReflectionComponent(reflectionType:String, name:String, className:String):void
		{
			if (reflectionDictionary[reflectionType] == null)
			{
				reflectionDictionary[reflectionType] = new Dictionary();
			}
			reflectionDictionary[reflectionType][name] = className;
		}
		
		/**
		 * Retrieves the associated class name for the reflectionType/name given
		 * @param reflectionType String
		 * @param name String
		 * @return String - the class name 
		 */		
		public static function getReflectionQualifiedClassName(reflectionType:String, name:String):String
		{
			if (reflectionDictionary[reflectionType] != null)
			{
				return reflectionDictionary[reflectionType][name];
			}
			return null;
		}
		
		/**
		 * Retrieves the reflection sub reflectionType dictionary
		 * @param reflectionType String
		 * @return Dictionary 
		 */		
		public static function getAllReflectionsByType(reflectionType:String):Dictionary
		{
			return reflectionDictionary[reflectionType];
		}
		
		/**
		 * Wrapper over the getReflectionQualifiedClassName function.
		 * 	Will only search in the game component type sub dictionary.
		 * @param name String
		 * @return String - the class name
		 */		
		public static function getGameComponentQualifiedClassName(name:String):String
		{
			return getReflectionQualifiedClassName(GameConstants.REFLECTION_TYPE_GAME_COMPONENT, name);
		}
		
		/**
		 * Wrapper over the getReflectionQualifiedClassName function. Will only search in the asset type sub dictionary.
		 * @param name String
		 * @return String - the class name
		 */	
		public static function getAssetQualifiedClassName(name:String):String
		{
			return getReflectionQualifiedClassName(GameConstants.REFLECTION_TYPE_ASSET, name);
		}
		
		/**
		 * Wrapper over the getReflectionQualifiedClassName function. Will only search in the loader type sub dictionary.
		 * @param name String
		 * @return String - the class name
		 */
		public static function getAssetLoaderQualifiedClassName(name:String):String
		{
			return getReflectionQualifiedClassName(GameConstants.REFLECTION_TYPE_LOADER, name);
		}
	}
}