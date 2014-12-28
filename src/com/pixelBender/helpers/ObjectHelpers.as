package com.pixelBender.helpers
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	public class ObjectHelpers
	{
		/**
		 * Gets a clone of the object 
		 * @param source
		 * @return the cloned object
		 */
		static public function objectClone(source:Object):*
		{
			// Integrity check
			AssertHelpers.assertCondition(source!=null, "Source object is null!!!");
			// Internals
			var className:String = getQualifiedClassName(source),
				byteArray:ByteArray = new ByteArray();
			// Register class
			className = className.replace("::", ".");
			registerClassAlias(className, source.constructor as Class);
			// Write object
			byteArray.writeObject(source);
			byteArray.position = 0;
			return byteArray.readObject();
		}
	}
}