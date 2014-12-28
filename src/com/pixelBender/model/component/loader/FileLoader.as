package com.pixelBender.model.component.loader
{
	import avmplus.getQualifiedClassName;

	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.vo.CallbackVO;
	import com.pixelBender.model.vo.asset.FileReferenceVO;

	import flash.display.Loader;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;

	public class FileLoader implements IPauseResume
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const NAME													:String = "FileLoader";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The loading asset
		 */
		protected var file															:FileReferenceVO;

		/**
		 * The list of accumulated callbacks while the asset loader was in the paused state.
		 * 	Will get invoked once the loader resumes.
		 */
		protected var delayedCallbacks												:Vector.<CallbackVO>;

		/**
		 * Callback when loading is done
		 */
		protected var completeCallback												:Function;

		/**
		 * Callback when any kind of loading error occurs
		 */
		protected var errorCallback													:Function;

		/**
		 * State flag
		 */
		protected var state															:int;

		/**
		 * The actual file loader
		 */
		protected var loader														:Loader;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function FileLoader()
		{
			delayedCallbacks = new Vector.<CallbackVO>();
			state = GameConstants.STATE_IDLE;
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		/**
		 * Will actually start the loading procedure
		 * @param file FileReferenceVO
		 * @param bytes ByteArray
		 * @param completeCallback Function
		 * @param errorCallback Function
		 */
		public function load(file:FileReferenceVO, bytes:ByteArray, completeCallback:Function,
							 	errorCallback:Function = null):void
		{
			state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_IDLE, GameConstants.STATE_LOADING);
			this.file = file;
			this.completeCallback = completeCallback;
			this.errorCallback = errorCallback;
			loader = new Loader();
			addListeners(loader.contentLoaderInfo);
			loader.loadBytes(bytes);
		}

		/**
		 * Getter for the file member
		 * @return FileReference
		 */
		public function getFile():FileReferenceVO
		{
			return file;
		}

		/**
		 * Clears all loading related components. Must be called while not in loading procedure
		 */
		public function clear():void
		{
			AssertHelpers.assertCondition((!BitMaskHelpers.isBitActive(state, GameConstants.STATE_LOADING)),
											"Cannot call clear while in loading state!");
			if (loader != null)
			{
				removeListeners(loader);
				loader = null;
			}
			file = null;
			completeCallback = null;
			errorCallback = null;
		}

		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================

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
			file = null;
			completeCallback = null;
			errorCallback = null;
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
			return "[" + getQualifiedClassName(this) + " file:" + file + " ]";
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
			if (errorCallback != null && getIsAbleToInvokeCompleteHandlers(errorCallback))
			{
				errorCallback(this);
			}
		}

		/**
		 * Complete handler
		 * @param event Event
		 */
		protected function handleCompleteEvent(event:Event):void
		{
			state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_LOADING, GameConstants.STATE_IDLE);
			if (getIsAbleToInvokeCompleteHandlers(completeCallback))
			{
				file.setContent(loader.content);
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
		 * @param invoke Boolean
		 * @return Boolean
		 */
		protected function getIsAbleToInvokeCompleteHandlers(invoke:Function):Boolean
		{
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED))
			{
				delayedCallbacks.push(new CallbackVO(invoke, [this]));
				return false;
			}
			return true;
		}
	}
}
