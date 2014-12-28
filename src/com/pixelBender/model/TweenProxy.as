package com.pixelBender.model
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.interfaces.IFrameUpdate;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.model.vo.tween.TweenTargetPropertyVO;
	import com.pixelBender.model.vo.tween.TweenVO;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.pool.ObjectPoolManager;
	import com.pixelBender.update.FrameUpdateManager;

	import flash.utils.Dictionary;

	import flash.utils.getTimer;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class TweenProxy extends Proxy implements IPauseResume, IFrameUpdate
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Pool for tween VO instances 
		 */		
		private var tweenVOPool															:ObjectPool;
		
		/**
		 * Pool for tween property VO instances 
		 */		
		private var tweenTargetPropertyVOPool											:ObjectPool;
		
		/**
		 * Local reference 
		 */		
		private var updateManager														:FrameUpdateManager;
		
		/**
		 * The active running tweens 
		 */		
		private var activeTweens														:Dictionary;

		/**
		 * The inactive (still running) tween. Explicitly paused by the user.
		 */
		private var inactiveTweens														:Dictionary;
		
		/**
		 * Proxy state 
		 */		
		private var state 																:int;
		
		/**
		 * Keeps all newly added tweens during the update phase 
		 */		
		private var toAdd																:Vector.<TweenVO>;
		
		/**
		 * Keeps all removed tweens during the update phase 
		 */		
		private var toRemove															:Vector.<TweenVO>;

		/**
		 * Keeps all inactivated tweens during the update phase
		 */
		private var toInactivate														:Vector.<TweenVO>;
		
		/**
		 * Flag
		 */
		private var pauseTime															:int;
		
		/**
		 * Flag 
		 */		
		private var frameTime															:int;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor 
		 * @param proxyName String
		 */		
		public function TweenProxy(proxyName:String)
		{
			super(proxyName);
			tweenVOPool = ObjectPoolManager.getInstance().retrievePool(TweenVO.NAME);
			tweenTargetPropertyVOPool = ObjectPoolManager.getInstance().retrievePool(TweenTargetPropertyVO.NAME);
			updateManager = FrameUpdateManager.getInstance();
			activeTweens = new Dictionary();
			inactiveTweens = new Dictionary();
			toAdd = new <TweenVO>[];
			toRemove = new <TweenVO>[];
			toInactivate = new <TweenVO>[];
			state = GameConstants.STATE_IDLE;
		}
		
		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================
				
		/**
		 * Pauses all the active tweens  
		 */		
		public function pause():void
		{
			// Check state
			if (!getIsStarted()) return;
			// Add pause 
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
			// Unregister from update manager and keep time
			updateManager.unregisterFromUpdate(this);
			pauseTime = updateManager.getFrameTime();
		}
		
		/**
		 * Resumes all active tweens 
		 */		
		public function resume():void
		{
			// Check state
			if (!getIsStarted()) return;
			// Remove pause 
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
			// Internals
			var tween:TweenVO,
				diff:int = getTimer() - pauseTime;
			// Advance tween time
			for each (tween in activeTweens)
			{
				tween.startTime += diff;
			}
			// Re-register to update manager
			updateManager.registerForUpdate(this);
		}
		
		/**
		 * Proper memory management 
		 */		
		public function dispose():void
		{
			if (updateManager != null)
			{
				updateManager.unregisterFromUpdate(this);
				updateManager = null;
			}
			tweenVOPool = null;
			tweenTargetPropertyVOPool = null;
			DictionaryHelpers.deleteValues(activeTweens, true);
			activeTweens = null;
			DictionaryHelpers.deleteValues(inactiveTweens, true);
			inactiveTweens = null;
			toAdd = null;
			toRemove = null;
			toInactivate = null;
		}
		
		//==============================================================================================================
		// IFrameUpdate IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Update 
		 * @param dt int - the number of milliseconds of the last frame 
		 */		
		public function frameUpdate(dt:int):void
		{
			// Set state
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_UPDATING);
			// Get synchronized frame time
			frameTime = updateManager.getFrameTime();
			// Parse
			for each(var tween:TweenVO in activeTweens)
			{
				updateTween(tween);
			}
			// Remove state
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_UPDATING);
			// Now process the added/removed tweens during the update phase
			processTemporaryTweens();
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Creates a tween VO from the given parameters and adds it to the update queue
		 * @param target Object
		 * @param duration int - in milliseconds
		 * @param properties Object - what properties will be tweened
		 * @param completeCallback Function - complete callback invoked when the tween has finished
		 * @param ease Function
		 * @param startDelay int - in milliseconds
		 */		
		public function createAndAddTween(target:Object, duration:int, properties:Object, completeCallback:Function,
										  	ease:Function = null, startDelay:int = 0):int
		{
			// Check data
			AssertHelpers.assertCondition(target != null, "Tween target cannot be null!");
			AssertHelpers.assertCondition(properties != null, "Tween properties cannot be null!");
			// Internals
			var tweenTargetProperties:Vector.<TweenTargetPropertyVO> = new <TweenTargetPropertyVO>[],
				tweenTargetProperty:TweenTargetPropertyVO,
				tweenVO:TweenVO,
				propertyName:String;
			// Parse and create properties
			for (propertyName in properties) 
			{
				tweenTargetProperty = tweenTargetPropertyVOPool.allocate() as TweenTargetPropertyVO;
				tweenTargetProperty.init(propertyName, target[propertyName], properties[propertyName]);
				tweenTargetProperties.push(tweenTargetProperty);
			}
			// Init and add tween
			tweenVO = tweenVOPool.allocate() as TweenVO;
			tweenVO.init(target, duration, tweenTargetProperties, completeCallback, ease, startDelay);
			addTween(tweenVO);
			// Done
			return tweenVO.ID;
		}

		/**
		 * Pauses a tween given the tween ID
		 * @param tweenID int - tween identifier
		 */
		public function pauseTweenByID(tweenID:int):void
		{
			var tween:TweenVO = activeTweens[tweenID];
			if (tween != null)
			{
				pauseTween(tween);
			}
		}

		/**
		 * Resumes an inactive tween
		 * @param tweenID int - tween identifier
		 */
		public function resumeTweenByID(tweenID:int):void
		{
			var tween:TweenVO = inactiveTweens[tweenID];
			if (tween != null)
			{
				resumeTween(tween);
			}
		}
		
		/**
		 * Removes an active tween
		 * @param tweenID int 
		 */		
		public function removeTweenByID(tweenID:int):void
		{
			var tween:TweenVO = activeTweens[tweenID];
			if (tween != null)
			{
				removeTween(tween);
			}
		}

		/**
		 * Removes al active tweens for a given target
		 * @param targetObject Object
		 */
		public function removeTweenForTarget(targetObject:Object):void
		{
			for each(var tween:TweenVO in activeTweens)
			{
				if (tween.target == targetObject)
				{
					removeTween(tween);
				}
			}
		}
		
		//==============================================================================================================
		// GETTERS
		//==============================================================================================================
		
		/**
		 * Returns if the proxy has any active tweens
		 * @return Boolean
		 */		
		public function getIsStarted():Boolean
		{
			return BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED);
		}
		
		/**
		 * Returns if the proxy is in the update state
		 * @return Boolean 
		 */		
		public function getIsUpdating():Boolean
		{
			return BitMaskHelpers.isBitActive(state, GameConstants.STATE_UPDATING);
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[TweenProxy state:" + state + "]";
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Advances the tween
		 * @param tween TweenVO
		 */		
		protected function updateTween(tween:TweenVO):void
		{
			// Internals
			var time:int, // Time passed since tween start time (in ms)
				tweenTargetProperty:TweenTargetPropertyVO;
			// Initialize tween if it hasn't been started yet
			if (tween.startTime < 0)
			{
				// Start condition
				tween.startTime = frameTime + tween.delay;
				for each (tweenTargetProperty in tween.tweenTargetProperties)
				{
					tween.target[tweenTargetProperty.name] = tweenTargetProperty.initialValue;
				}
				return;
			} 
			// Check end condition
			if (frameTime >= tween.startTime + tween.duration)
			{
				for each (tweenTargetProperty in tween.tweenTargetProperties)
				{
					tween.target[tweenTargetProperty.name] = tweenTargetProperty.finalValue;
				}
				toRemove.push(tween);
				return;
			}
			// Normal update procedure
			time = frameTime - tween.startTime;
			if (time < 0)
			{
				return;
			}
			for each (tweenTargetProperty in tween.tweenTargetProperties)
			{
				tween.target[tweenTargetProperty.name] = tween.easeFunction(time, tweenTargetProperty.initialValue,
																				tweenTargetProperty.diffValue, tween.duration);
			}
		}
				
		/**
		 * Adds a tween to the update queue
		 * @param tweenVO TweenVO
		 */		
		protected function addTween(tweenVO:TweenVO):void
		{
			if (getIsUpdating()) 
			{
				toAdd.push(tweenVO);
				return;
			}
			addActiveTween(tweenVO);
		}
		
		/**
		 * Adds an active tween
		 * @param tweenVO TweenVO 
		 */		
		protected function addActiveTween(tweenVO:TweenVO):void
		{
			activeTweens[tweenVO.ID] = tweenVO;
			if (!getIsStarted()) 
			{
				state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_IDLE, GameConstants.STATE_STARTED);
				updateManager.registerForUpdate(this);
			}
		}

		/**
		 * Pauses an active tween
		 * @param tweenVO TweenVO
		 */
		protected function pauseTween(tweenVO:TweenVO):void
		{
			tweenVO.lastUpdate = updateManager.getFrameTime();
			inactiveTweens[tweenVO.ID] = tweenVO;
			inactivateTween(tweenVO);
		}

		/**
		 * Resumes an active tween
		 * @param tweenVO TweenVO
		 */
		protected function resumeTween(tweenVO:TweenVO):void
		{
			delete inactiveTweens[tweenVO.ID];
			tweenVO.startTime += updateManager.getFrameTime() - tweenVO.lastUpdate;
			tweenVO.lastUpdate = 0;
			addTween(tweenVO);
		}

		/**
		 * Removes a tween from the update queue
		 * @param tweenVO TweenVO
		 */		
		protected function removeTween(tweenVO:TweenVO):void
		{
			if (getIsUpdating()) 
			{
				toRemove.push(tweenVO);
				return;
			}
			removeActiveTween(tweenVO);
		}

		/**
		 * Inactivates a tween putting it in dormant state
		 * @param tweenVO TweenVO
		 */
		protected function inactivateTween(tweenVO:TweenVO):void
		{
			if (getIsUpdating())
			{
				toInactivate.push(tweenVO);
				return;
			}
			delete activeTweens[tweenVO.ID];
		}
		
		/**
		 * Removes an active tween
		 * @param tweenVO TweenVO 
		 */		
		protected function removeActiveTween(tweenVO:TweenVO):void
		{
			// Internals
			var callback:Function = tweenVO.completeCallback,
				tweenID:int = tweenVO.ID;
			// Properly release tween
			delete activeTweens[tweenID];
			// Release all its objects back in the pool
			for each (var property:TweenTargetPropertyVO in tweenVO.tweenTargetProperties)
			{
				property.dispose();
				tweenVOPool.release(property);
			}
			tweenVO.dispose();
			tweenVOPool.release(tweenVO);
			// Check any tweens left
			if (DictionaryHelpers.dictionaryLength(activeTweens) == 0)
			{
				state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_STARTED, GameConstants.STATE_IDLE);
				updateManager.unregisterFromUpdate(this);
			}
			// Invoke callback
			if (callback != null)
			{
				callback(tweenID);
			}
		}
		
		/**
		 * Will remove/add all the tweens that have been removed or added exactly during the update process
		 */		
		protected function processTemporaryTweens():void
		{
			// Internals
			var tweenVO:TweenVO;
			// First remove
			if (toRemove.length > 0)
			{
				for each (tweenVO in toRemove)
				{
					removeActiveTween(tweenVO);
				}
				toRemove = new <TweenVO>[];
			}
			// Add
			if (toAdd.length > 0)
			{
				for each (tweenVO in toAdd)
				{
					addActiveTween(tweenVO);
				}
				toAdd = new <TweenVO>[];
			}
			// Inactivate
			if (toInactivate.length > 0)
			{
				for each (tweenVO in toRemove)
				{
					delete activeTweens[tweenVO.ID];
				}
				toInactivate = new <TweenVO>[];
			}
		}
	}
}