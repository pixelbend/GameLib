package com.pixelBender.model.component.loader
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.interfaces.IAssetLoader;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.vo.CallbackVO;
	import com.pixelBender.model.vo.asset.AssetVO;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import avmplus.getQualifiedClassName;
	
	public class AssetLoader implements IAssetLoader
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The loading asset 
		 */		
		protected var asset																		:AssetVO;
		
		/**
		 * The list of accumulated callbacks while the asset loader was in the paused state.
		 * 	Will get invoked once the loader resumes.
		 */		
		protected var delayedCallbacks															:Vector.<CallbackVO>;
		
		/**
		 * Callback when loading is done 
		 */		
		protected var completeCallback															:Function;
		
		/**
		 * State flag 
		 */		
		protected var state																		:int;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function AssetLoader():void
		{
			delayedCallbacks = new Vector.<CallbackVO>();
			state = GameConstants.STATE_IDLE;
		}
		
		//==============================================================================================================
		// IAssetLoader IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Will actually start the loading procedure 
		 * @param asset AssetVO
		 * @param callback Function
		 */		
		public function load(asset:AssetVO, callback:Function):void
		{
			state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_IDLE, GameConstants.STATE_LOADING);
			this.asset = asset;
			completeCallback = callback;
		}
		
		/**
		 * Getter for the asset member
		 * @return AssetVO 
		 */		
		public function getAsset():AssetVO
		{
			return asset;
		}

		/**
		 * Clears all loading related components. Must be called while not in loading procedure 
		 */		
		public function clear():void
		{
			AssertHelpers.assertCondition((!BitMaskHelpers.isBitActive(state, GameConstants.STATE_LOADING)),
												"Cannot call clear while in loading state!");
			asset = null;
			completeCallback = null;
		}
		
		/**
		 * Set pause state. Will keep all events in a queue.
		 */		
		public function pause():void
		{
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
		}
		
		/**
		 * Remove pause state. Release all queued events.
		 */		
		public function resume():void
		{
			var callbackVO:CallbackVO;
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
			while (delayedCallbacks.length > 0)
			{
				callbackVO = delayedCallbacks.pop();
				callbackVO.invoke();
				callbackVO.dispose();
				callbackVO = null;
			}
		}
		
		/**
		 * Proper memory management 
		 */		
		public function dispose():void
		{
			var callbackVO:CallbackVO;
			asset = null;
			completeCallback = null;
			if (delayedCallbacks != null)
			{
				for each (callbackVO in delayedCallbacks) 
				{
					callbackVO.dispose();
					callbackVO = null;
				}
				delayedCallbacks = null;
			}
		}
				
		//==============================================================================================================
		// DEBUG
		//==============================================================================================================
		
		public function toString():String
		{
			return "[" + getQualifiedClassName(this) + " asset:" + asset + "]";
		}
		
		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================

		/**
		 * Error handler 
		 * @param error Event
		 * 
		 */		
		protected function handleErrorEvent(error:Event):void
		{
			Logger.error(this + " " + error + " while loading!");
			state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_LOADING, GameConstants.STATE_IDLE);
			if (getIsAbleToInvokeCompleteHandlers())
			{
				completeCallback(this);
			}
		}
		
		/**
		 * Complete handler 
		 * @param event Event
		 */		
		protected function handleCompleteEvent(event:Event):void
		{
			state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_LOADING, GameConstants.STATE_IDLE);
			if (getIsAbleToInvokeCompleteHandlers())
			{
				completeCallback(this);
			}
		}
		
		//==============================================================================================================
		// EVENT LISTENERS
		//==============================================================================================================
		
		/**
		 * Adds all the necessary listeners to the asset loader.
		 * @param loader IEventDispatcher
		 */		
		protected function addListeners(loader:IEventDispatcher):void
		{
			loader.addEventListener(Event.COMPLETE, handleCompleteEvent, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleErrorEvent, false, 0, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleErrorEvent, false, 0, true);
		}
		
		/**
		 * Removes all listeners assigned to the asset loader.
		 * @param loader IEventDispatcher
		 */
		protected function removeListeners(loader:IEventDispatcher):void
		{
			loader.removeEventListener(Event.COMPLETE, handleCompleteEvent);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handleErrorEvent);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleErrorEvent);
		}
		
		/**
		 * Will check if the loader is in the necessary state to invoke the complete callback.
		 * @return Boolean
		 */
		protected function getIsAbleToInvokeCompleteHandlers():Boolean
		{
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED))
			{
				delayedCallbacks.push(new CallbackVO(completeCallback, [this]));
				return false;
			}
			return true;
		}
	}
}