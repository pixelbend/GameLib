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
			{
				return length;
			}
			for (var key:String in dictionary)
			{
				length++;
			}
			return length;
		}
	}
}