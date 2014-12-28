package com.pixelBender.model.vo.popup
{
	import com.pixelBender.helpers.MathHelpers;

	public class PopupTranslucentLayerVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Flag whether the translucent layer is enabled or not
		 */
		private var layerEnabled														:Boolean;

		/**
		 * The translucent layer color
		 */		
		private var layerColor															:int;
		
		/**
		 * The translucent layer alpha. Between 0 and 1.
		 */		
		private var layerAlpha															:Number;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function PopupTranslucentLayerVO(layerEnabled:Boolean=true, layerColor:int=0x000000, layerAlpha:Number=0.5)
		{
			this.layerEnabled = layerEnabled;
			this.layerColor = layerColor;
			this.layerAlpha = layerAlpha;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function clone():PopupTranslucentLayerVO
		{
			return new PopupTranslucentLayerVO(layerEnabled, layerColor, layerAlpha);
		}
		
		//==============================================================================================================v
		// GETTERS/SETTERS
		//==============================================================================================================

		public function getLayerEnabled():Boolean
		{
			return layerEnabled;
		}

		public function setLayerEnabled(enabled:Boolean):void
		{
			this.layerEnabled = enabled;
		}

		public function getLayerColor():int
		{
			return layerColor;
		}
		
		public function setLayerColor(color:int):void
		{
			this.layerColor = color;
		}
		
		public function getLayerAlpha():Number
		{
			return layerAlpha;
		}
		
		public function setLayerAlpha(alpha:Number):void
		{
			this.layerAlpha = MathHelpers.clamp(alpha, 0, 1);
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[PopupTranslucentLayerVO layerEnabled:" + layerEnabled + " layerColor:" + layerColor
						+ " layerAlpha: " + layerAlpha + "]";
		}
	}
}