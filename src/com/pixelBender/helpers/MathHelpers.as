package com.pixelBender.helpers
{

	public class MathHelpers
	{
		/**
		 * Generates a random number between min and max.
		 * @param min Number
		 * @param max Number
		 * @return Number
		 * 
		 */
		static public function random(min:Number = 0, max:Number = 1):Number
		{
			return (min + Math.random()*(max - min));
		}
		
		/**
		 * Generates a random integer number between min and max 
		 * @param min int
		 * @param max int 
		 * @return int
		 * 
		 */
		static public function randomInt(min:int, max:int):int
		{
			return int(Math.floor(random(min, max + 1)));
		}
		
		/**
		 * Clamps the number between min and max.
		 * @param value Number
		 * @param min Number
		 * @param max Number 
		 * @return Number - the clamped value
		 * 
		 */
		static public function clamp(value:Number, min:Number, max:Number):Number
		{
			if (value < min) return min;
			if (value > max) return max;
			return value;
		}
		
		/**
		 * Will constrain the given value to be between higher than min and lower equals to max. 
		 * Useful for constraining values to be inside array/vector indices (0, length-1)
		 * @param value
		 * @param min
		 * @param max
		 * @return int - the constrained value
		 * 
		 */		
		static public function constrainIndex(value:int, min:int, max:int):int
		{
			var intervalLength:int = max - min;
			while (value >= max) 
			{
				value -= intervalLength;
			}
			while (value < min)
			{
				value += intervalLength;
			}
			return value;	
		}
		
		/**
		 * Constrains the value to be between min and max
		 * @param value
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */		
		public static function constrain(value:Number, min:Number, max:Number):Number
		{
			var intervalLength:int = max + 1 - min;
			while (value > max) 
			{
				value -= intervalLength;
			}
			while (value < min)
			{
				value += intervalLength;
			}
			return value;
		}
	}
}