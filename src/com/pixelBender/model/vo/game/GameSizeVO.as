package com.pixelBender.model.vo.game
{
	public class GameSizeVO
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Game window width
		 */
		private var width															:int;
		
		/**
		 * Game window height
		 */
		private var height															:int;
		
		/**
		 * Game window ratio
		 */
		private var ratio															:Number;
		
		/**
		 * Game scale
		 */
		private var scale															:Number;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function GameSizeVO(width:int, height:int, ratio:Number=NaN)
		{
			this.width = width;
			this.height = height;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function update(width:int, height:int, scale:Number):void
		{
			this.width = width;
			this.height = height;
			this.scale = scale;
			this.ratio = width/height;
		}
		
		//==============================================================================================================
		// GETTERS
		//==============================================================================================================
		
		public function getWidth():int
		{
			return width;
		}
		
		public function getHeight():int
		{
			return height;
		}
		
		public function getRatio():Number
		{
			return ratio;
		}
		
		public function getScale():Number
		{
			return scale;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[GameSizeVO width:" + width + " height: " + height + " ratio:" + ratio + " scale:" + scale + "]";
		}
	}
}