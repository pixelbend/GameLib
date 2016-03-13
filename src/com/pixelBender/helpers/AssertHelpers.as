package com.pixelBender.helpers
{
	public class AssertHelpers
	{
		/**
		 * Throws an error if the condition fails to check (aka (condition==false) => BOOM)
		 * @param conditionToCheck Boolean
		 * @param errorMessage String
		 */		
		public static function assertCondition(conditionToCheck:Boolean, errorMessage:String):void
		{
			if (!conditionToCheck)
				throw new Error(errorMessage);
		}
	}
}