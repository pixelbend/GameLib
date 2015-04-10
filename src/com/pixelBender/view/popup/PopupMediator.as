package com.pixelBender.view.popup
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.interfaces.IPopup;
	import com.pixelBender.model.PopupProxy;

	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PopupMediator extends Mediator implements IPopup
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Popup proxy. Used to parse the configuration XML and for any other data related needs
		 */		
		protected var popupProxy																:PopupProxy;

		/**
		 * Reference to the game facade
		 */
		protected var gameFacade																:GameFacade;

		/**
		 * Flag
		 */
		protected var state																		:int;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function PopupMediator(mediatorName:String)
		{
			super(mediatorName);
			state = GameConstants.STATE_CLOSED;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		/**
		 * Setter
		 * @param xml XML
		 */
		public final function setLogicXML(xml:XML):void
		{
			popupProxy.setLogicXML(xml);
		}

		public final function openPopup():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_PREPARING_FOR_OPEN)) return;
			open();
			state = GameConstants.STATE_OPENED;
		}

		public final function pausePopup():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_OPENED)) return;
			pause();
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
		}

		public final function resumePopup():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED)) return;
			resume();
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
		}

		public final function setPopupVisible(visible:Boolean):void
		{
			setVisible(visible);
		}

		public final function closePopup():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_OPENED)) return;
			close();
			state = GameConstants.STATE_CLOSED;
		}

		public final function disposePopup():void
		{
			closePopup();
			dispose();
			if (popupProxy != null)
			{
				gameFacade.removeProxy(popupProxy.getProxyName());
				popupProxy.dispose();
				popupProxy = null;
			}
			gameFacade = null;
			state = GameConstants.STATE_DISPOSED;
		}

		//==============================================================================================================
		// IMediator OVERRIDES
		//==============================================================================================================

		public override function onRegister():void
		{
			gameFacade = facade as GameFacade;
			popupProxy = createPopupProxy();
			AssertHelpers.assertCondition((popupProxy!=null), "Popup proxy cannot be null!");
			gameFacade.registerProxy(popupProxy);
		}

		public override function onRemove():void
		{
			gameFacade.removeProxy(popupProxy.getProxyName());
		}

		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================

		/**
		 * Open functionality. MUST be overridden!
		 */
		public function open():void
		{
			AssertHelpers.assertCondition(false, "Override this!");
		}

		/**
		 * Pause functionality. MUST be overridden!
		 */		
		public function pause():void
		{
			AssertHelpers.assertCondition(false, "Override this!");
		}
		
		/**
		 * Resume functionality. MUST be overridden!
		 */
		public function resume():void
		{
			AssertHelpers.assertCondition(false, "Override this!");
		}

		/**
		 * Show/hide mechanism
		 * @param visible Boolean
		 */
		public function setVisible(visible:Boolean):void
		{
			AssertHelpers.assertCondition(false, "Override this!");
		}

		/**
		 * Remove the popup from screen.
		 */
		public function close():void
		{
			AssertHelpers.assertCondition(false, "Override this!");
		}
		
		/**
		 * Memory management 
		 */		
		public function dispose():void
		{
			AssertHelpers.assertCondition(false, "Override this!");
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[PopupMediator name:" + mediatorName + "]";
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		/**
		 * Must be overridden. Provide a concrete implementation for the popup proxy.
		 */		
		protected function createPopupProxy():PopupProxy
		{
			throw new Error("Override this and create a PopupProxy extended class");
		}
	}
}