package com.pixelBender.update
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.interfaces.IFrameUpdate;
	import com.pixelBender.interfaces.IPauseResume;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class FrameUpdateManager implements IPauseResume
	{
				
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================
		
		/**
		 * Static instance 
		 */		
		private static var instance															:FrameUpdateManager;
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Instance vector. Each instance will be updated once per frame 
		 */		
		private var frameUpdateInstances													:Vector.<IFrameUpdate>;
		
		/**
		 * Beacon reference. Used for EnterFrame event. 
		 */		
		private var beacon																	:Sprite;
		
		/**
		 * Last frame time 
		 */		
		private var lastFrameTime															:int;
		
		/**
		 * Current frame time 
		 */		
		private var currentFrameTime														:int;
				
		/**
		 * Manager state
		 */
		private var state																	:int;
		
		/**
		 * Temporary vector for added IFrameUpdate instances while the manager is in update mode
		 */
		private var toAdd																	:Vector.<IFrameUpdate>;
		
		/**
		 * Temporary vector for removed IFrameUpdate instances while the manager is in update mode
		 */
		private var toRemove																:Vector.<IFrameUpdate>;
		
		//==============================================================================================================
		// CONSTRUCTOR - should be PRIVATE :(
		//==============================================================================================================
		
		/**
		 * Constructor 
		 * @param singletonEnforcer - enforcer
		 * 
		 */		
		public function FrameUpdateManager(singletonEnforcer:SingletonEnforcer)
		{
			if (singletonEnforcer == null) {
				AssertHelpers.assertCondition(false, this + " cannot call constructor from outside. Sorry!");
			}
			frameUpdateInstances = new <IFrameUpdate>[];
			toAdd = new <IFrameUpdate>[];
			toRemove = new <IFrameUpdate>[];
			beacon = new Sprite();
			currentFrameTime = lastFrameTime = getTimer();
			activateBeacon();
			state = GameConstants.STATE_IDLE;
		}
		
		//==============================================================================================================
		// STATIC API
		//==============================================================================================================
		
		/**
		 * Singleton implementation 
		 * @return EnterFrameBeacon
		 * 
		 */		
		static public function getInstance():FrameUpdateManager
		{
			if (instance == null)
			{
				instance = new FrameUpdateManager(new SingletonEnforcer());
			}
			return instance;
		}
		
		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Removes the beacon if need be
		 */		
		public function pause():void
		{
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
			lastFrameTime = currentFrameTime;
		}
		
		/**
		 * Reactivates the beacon if need be
		 */	
		public function resume():void
		{
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
			currentFrameTime = lastFrameTime = getTimer();
		}
		
		/**
		 * Proper memory management
		 */		
		public function dispose():void
		{
			frameUpdateInstances = null;
			if (beacon != null)
			{
				beacon.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				beacon = null;
			}
			instance = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Registers a new frame update instance to the frame update instances list
		 * @param frameUpdate IFrameUpdate
		 */		
		public function registerForUpdate(frameUpdate:IFrameUpdate):void
		{
			// Assert data consistency
			AssertHelpers.assertCondition( (frameUpdate != null), this + " IFrameUpdate instance must not be null!");
			// Check update state
			if (getIsUpdating())
			{
				toAdd.push(frameUpdate); return;
			}
			// Add
			addFrameUpdateInstance(frameUpdate);
		}
		
		/**
		 * Unregister a new frame update instance to the frame update instances list
		 * @param frameUpdate IFrameUpdate
		 */		
		public function unregisterFromUpdate(frameUpdate:IFrameUpdate):void
		{
			// Assert data consistency
			AssertHelpers.assertCondition( (frameUpdate != null), this + " IFrameUpdate instance must not be null!");
			// Check update state
			if (getIsUpdating())
			{
				toRemove.push(frameUpdate); return;
			}
			// Remove frame update
			removeFrameUpdateInstance(frameUpdate);
		}
		
		/**
		 * Returns if the manager is started (has any active instances)
		 * @return Boolean
		 */		
		public function getIsStarted():Boolean
		{
			return BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED);
		}
		
		/**
		 * Returns if the manager is in the update loop
		 * @return Boolean 
		 */		
		public function getIsUpdating():Boolean
		{
			return BitMaskHelpers.isBitActive(state, GameConstants.STATE_UPDATING);
		}
		
		/**
		 * Returns the current frame time
		 * @return int 
		 */		
		public function getFrameTime():int
		{
			return currentFrameTime;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[FrameUpdateManager state:" + state + "]";
		}
		
		//==============================================================================================================
		// Event handlers
		//==============================================================================================================
		
		protected function handleEnterFrame(event:Event):void
		{
			// Internals
			var diff:int,
				frameUpdate:IFrameUpdate;
			// Add state
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_UPDATING);
			// Update time flags
			lastFrameTime = currentFrameTime;
			currentFrameTime = getTimer();
			//  Compute diff (in ms)
			diff = currentFrameTime - lastFrameTime;
			// Update each instance with the last frame time (in ms)
			for each (frameUpdate in frameUpdateInstances)
			{
				frameUpdate.frameUpdate(diff);
			}
			// Done updating
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_UPDATING);
			// Since in the update state more register/unregister calls may have been invoked, 
			// process them now
			processTemporaryFrameUpdateInstances();
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		protected function activateBeacon():void
		{
			beacon.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
		}

		protected function processTemporaryFrameUpdateInstances():void
		{
			// Internals
			var frameUpdate:IFrameUpdate;
			// First remove
			if ( toRemove.length > 0 ) 
			{
				for each (frameUpdate in toRemove)
				{
					removeFrameUpdateInstance(frameUpdate);
				}
				toRemove = new Vector.<IFrameUpdate>();
			}
			// Add
			if ( toAdd.length > 0 ) 
			{
				for each (frameUpdate in toAdd)
				{
					addFrameUpdateInstance(frameUpdate);
				}
				toAdd = new Vector.<IFrameUpdate>();
			}
		}
		
		protected function removeFrameUpdateInstance(frameUpdate:IFrameUpdate):void
		{
			// Internals
			var index:int = frameUpdateInstances.indexOf(frameUpdate);
			if ( index >= 0 )
			{
				frameUpdateInstances.splice(index, 1);
			}
			// Check any update instances left
			if (frameUpdateInstances.length == 0) 
			{
				state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_STARTED, GameConstants.STATE_IDLE);
			}
		}
		
		protected function addFrameUpdateInstance(frameUpdate:IFrameUpdate):void
		{
			// Add frame update instance
			frameUpdateInstances.push(frameUpdate);
			if (!getIsStarted()) 
			{
				state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_IDLE, GameConstants.STATE_STARTED);
				activateBeacon();
			}
		}
	}
}
class SingletonEnforcer {}