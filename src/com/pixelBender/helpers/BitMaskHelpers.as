package com.pixelBender.helpers
{
	public class BitMaskHelpers
	{
		public static function addBit(mask:int, bit:int):int
		{
			return mask |= bit;
		}
		
		public static function removeBit(mask:int, bit:int):int
		{
			return mask &= ~bit;	
		}
		
		public static function switchMaskState(mask:int, bitToRemove:int, bitToAdd:int):int
		{
			return addBit(removeBit(mask, bitToRemove), bitToAdd);
		}
		
		public static function isBitActive(mask:int, bit:int):Boolean
		{
			return ( mask & bit ) === bit;
		}
	}
}