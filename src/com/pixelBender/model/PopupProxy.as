package com.pixelBender.model
{
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.interfaces.IDispose;

	import org.puremvc.as3.patterns.proxy.Proxy;

	public class PopupProxy extends Proxy implements IDispose
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		public static const SUFFIX										:String = "_popupProxy";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Configuration XML
		 */
		protected var popupLogicXML										:XML;

		/**
		 * Reference to the game facade
		 */
		protected var gameFacade										:GameFacade;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function PopupProxy(popupName:String)
		{
			super(popupName + SUFFIX);
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function setLogicXML(xml:XML):void
		{
			popupLogicXML = xml;
			parseLogicXML();
		}

		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================

		public function dispose():void
		{
			popupLogicXML = null;
			gameFacade = null;
		}

		//==============================================================================================================
		// IProxy OVERRIDES
		//==============================================================================================================

		public override function onRegister():void
		{
			gameFacade = facade as GameFacade;
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		/**
		 * Parses the logic XML in order to obtain popup configuration
		 */
		protected function parseLogicXML():void
		{
			// Override in concrete implementation
		}
	}
}
