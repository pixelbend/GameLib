package com.pixelBender.ease
{
	public class Linear
	{
		public static function linear(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c*t/d + b;
		}
	}
}