package com.pixelBender.helpers
{
	import com.pixelBender.interfaces.IDispose;

	import flash.utils.Dictionary;

	public class DictionaryHelpers
	{
		/**
		 * Will delete all dictionary key/value sets
		 * If the values are IDispose instances, the dispose function will be called.
		 * @param dictionary Dictionary
		 * @param disposeValues Boolean
		 */
		static public function deleteValues(dictionary:Dictionary, disposeValues:Boolean=false):void
		{
			var key:String;

			if (dictionary != null) 
			{
				for (key in dictionary) 
				{
					if (disposeValues && dictionary[key] is IDispose)
					{
						IDispose(dictionary[key]).dispose();
					}
					dictionary[key] = null;
					delete dictionary[key];
				}
			}
		}

		static public function dictionaryLength(dictionary:Dictionary):int
		{
			var length:int = 0;

			if (dictionary == null)
				return length;

			for (var key:String in dictionary)
				length++;

			return length;
		}

		static public function getDictionaryEmpty(dictionary:Dictionary):Boolean
		{
			if (dictionary == null)
				AssertHelpers.assertCondition(false, "Dictionary cannot be null!");

			for (var key:String in dictionary)
				// At least one element encountered. Not empty
				return false;

			return true;
		}

		static public function clone(dictionary:Dictionary):Dictionary
		{
			if (dictionary == null)
				AssertHelpers.assertCondition(false, "Dictionary cannot be null!");

			var clone:Dictionary = new Dictionary();

			for (var key:String in dictionary)
				clone[key] = dictionary[key];

			return clone;
		}
	}
}