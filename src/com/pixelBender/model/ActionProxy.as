package com.pixelBender.model
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.interfaces.IAction;
	import com.pixelBender.interfaces.IActionPlayer;
	import com.pixelBender.interfaces.IActionVO;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.model.component.action.ParallelAction;
	import com.pixelBender.model.component.action.ParallelAction;
	import com.pixelBender.model.component.action.PlaySoundAction;
	import com.pixelBender.model.component.action.SequenceAction;
	import com.pixelBender.model.component.action.TweenAction;
	import com.pixelBender.model.component.action.WaitAction;
	import com.pixelBender.model.vo.action.CompleteActionPropertiesVO;
	import com.pixelBender.model.vo.action.ParallelActionVO;
	import com.pixelBender.model.vo.action.PlaySoundActionVO;
	import com.pixelBender.model.vo.action.RunningActionVO;
	import com.pixelBender.model.vo.action.SequenceActionVO;
	import com.pixelBender.model.vo.action.TweenActionVO;
	import com.pixelBender.model.vo.action.WaitActionVO;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.pool.ObjectPoolManager;

	import flash.utils.Dictionary;

	import org.puremvc.as3.patterns.proxy.Proxy;

	public class ActionProxy extends Proxy implements IPauseResume, IActionPlayer
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		/**
		 * Collection of object pools needed
		 */
		protected static var objectPools												:Dictionary;

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * All the registered actions with this proxy
		 */
		private var registeredActions													:Dictionary;

		/**
		 * The running actions
		 */
		private var runningActions														:Dictionary;

		/**
		 * Proxy state
		 */
		private var state 																:int;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		/**
		 * Constructor
		 * @param proxyName String
		 */
		public function ActionProxy(proxyName:String = null)
		{
			super(proxyName);

			if (objectPools == null)
			{
				var poolManager:ObjectPoolManager = ObjectPoolManager.getInstance();
				objectPools = new Dictionary();
				objectPools[RunningActionVO.NAME] = poolManager.retrievePool(RunningActionVO.NAME);
				objectPools[GameConstants.ACTION_TYPE_WAIT] = poolManager.retrievePool(WaitAction.NAME);
				objectPools[GameConstants.ACTION_TYPE_PLAY_SOUND] = poolManager.retrievePool(PlaySoundAction.NAME);
				objectPools[GameConstants.ACTION_TYPE_TWEEN] = poolManager.retrievePool(TweenAction.NAME);
				objectPools[GameConstants.ACTION_TYPE_SEQUENTIAL] = poolManager.retrievePool(SequenceAction.NAME);
				objectPools[GameConstants.ACTION_TYPE_PARALLEL] = poolManager.retrievePool(ParallelAction.NAME);
			}

			registeredActions = new Dictionary();
			runningActions = new Dictionary();

			state = GameConstants.STATE_IDLE;
		}

		//==============================================================================================================
		// IRunnable IMPLEMENTATION
		//==============================================================================================================

		/**
		 * Pauses all the running actions
		 */
		public function pause():void
		{
			if (!getIsStarted())
				return;

			state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
			for each(var runningAction:RunningActionVO in runningActions)
			{
				runningAction.getAction().pause();
			}
		}

		/**
		 * Resumes all running actions
		 */
		public function resume():void
		{
			if (!getIsPaused())
				return;

			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
			for each(var runningAction:RunningActionVO in runningActions)
			{
				runningAction.getAction().resume();
			}
		}

		/**
		 * Proper memory management
		 */
		public function dispose():void
		{
			var actionID:String,
				runningActionVO:RunningActionVO,
				action:IAction,
				registeredActionPool:ObjectPool,
				runningActionPool:ObjectPool = objectPools[RunningActionVO.NAME];

			// Update state
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_DISPOSING);

			// Remove all registered actions
			if (registeredActions)
			{
				for (actionID in registeredActions)
				{
					action = registeredActions[actionID];

					registeredActionPool = objectPools[action.getType()];
					action.dispose();
					registeredActionPool.release(action);

					delete registeredActions[actionID];
				}
				registeredActions = null;
			}

			// Properly dispose all running action VOs
			if (runningActions)
			{
				for (actionID in runningActions)
				{
					runningActionVO = runningActions[actionID];

					runningActionVO.dispose();
					runningActionPool.release(action);

					delete runningActionVO[actionID];
				}
				runningActions = null;
			}

			state = GameConstants.STATE_DISPOSED;
		}

		//==============================================================================================================
		// IActionPlayer implementation
		//==============================================================================================================

		/**
		 * Starts a previously registered action
		 * @param actionID String - action unique identifier
		 * @param completeCallback Function - function that will be invoked when the action is complete
		 */
		public function startAction(actionID:String, completeCallback:Function):void
		{
			if (getIsPaused())
			{
				AssertHelpers.assertCondition(false, "Cannot start action while action proxy is paused!");
				return;
			}

			var action:IAction = registeredActions[actionID],
				runningActionVO:RunningActionVO;

			AssertHelpers.assertCondition(action != null, "Action with ID[" + actionID + "] is not registered!");

			if (!getIsStarted())
				state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_IDLE, GameConstants.STATE_STARTED);

			var runningActionPool:ObjectPool = objectPools[RunningActionVO.NAME];
			runningActionVO = runningActionPool.allocate() as RunningActionVO;
			runningActionVO.initialize(action, completeCallback);
			runningActions[action.getID()] = runningActionVO;

			prepareActionForStart(action, completeCallback);
			action.start(handleActionComplete);
		}

		/**
		 * Pauses a certain action
		 * @param actionID String
		 */
		public function pauseAction(actionID:String):void
		{
			var runningActionVO:RunningActionVO = runningActions[actionID];
			AssertHelpers.assertCondition(runningActionVO != null, "Action with ID[" + actionID + "] is not running. Cannot pause!");

			runningActionVO.getAction().pause();
		}

		/**
		 * Resumes a certain action
		 * @param actionID String
		 */
		public function resumeAction(actionID:String):void
		{
			if (getIsPaused())
			{
				AssertHelpers.assertCondition(false, "Cannot resume action while action proxy is paused!");
				return;
			}

			var runningActionVO:RunningActionVO = runningActions[actionID];
			AssertHelpers.assertCondition(runningActionVO != null, "Action with ID[" + actionID + "] is not running. Cannot resume!");

			runningActionVO.getAction().resume();
		}

		/**
		 * Stops the action with the given ID
		 * @param actionID String
		 */
		public function stopAction(actionID:String):void
		{
			if (getIsPaused())
			{
				AssertHelpers.assertCondition(false, "Cannot stop action while action proxy is paused!");
				return;
			}

			var action:RunningActionVO = runningActions[actionID];
			if (action == null)
				return;

			action.getAction().stop();
		}

		/**
		 * Stops all running actions
		 */
		public function stopAllActions():void
		{
			if (getIsPaused())
			{
				AssertHelpers.assertCondition(false, "Cannot stop actions while action proxy is paused!");
				return;
			}

			// Make a clone. Stopping one action can create a chain reaction that will stop others
			var clone:Dictionary = DictionaryHelpers.clone(runningActions);

			// Go through the cloned running dict and stop still valid actions one by one
			for each(var runningAction:RunningActionVO in clone)
			{
				if (runningAction.getAction() != null)
					runningAction.getAction().stop();
			}
		}

		//==============================================================================================================
		// API
		//==============================================================================================================

		/**
		 * Registers an action with the proxy.
		 * Depending on the actionVO type, it will spawn the corresponding action.
		 * If another action with the same ID is already registered, an error will be thrown.
		 *
		 * @param actionVO IActionVO
		 */
		public function registerAction(actionVO:IActionVO):void
		{
			// TODO -> move this somewhere else, in a factory perhaps ?!
			switch (actionVO.getType())
			{
				case GameConstants.ACTION_TYPE_WAIT:
					var waitActionVO:WaitActionVO = actionVO as WaitActionVO,
						waitActionPool:ObjectPool = objectPools[actionVO.getType()],
						waitAction:WaitAction = waitActionPool.allocate() as WaitAction,
						waitActionID:String = waitActionVO.getID();
					AssertHelpers.assertCondition((registeredActions[waitActionID] == null), "Cannot override action with ID:" + waitActionID);
					waitAction.initialize(waitActionVO);
					registeredActions[waitActionID] = waitAction;
					break;
				case GameConstants.ACTION_TYPE_PLAY_SOUND:
					var playSoundActionVO:PlaySoundActionVO = actionVO as PlaySoundActionVO,
						playSoundActionPool:ObjectPool = objectPools[actionVO.getType()],
						playSoundAction:PlaySoundAction = playSoundActionPool.allocate() as PlaySoundAction,
						playSoundActionID:String = playSoundActionVO.getID();
					AssertHelpers.assertCondition((registeredActions[playSoundActionID] == null), "Cannot override action with ID:" + playSoundActionID);
					playSoundAction.initialize(playSoundActionVO);
					registeredActions[playSoundActionID] = playSoundAction;
					break;
				case GameConstants.ACTION_TYPE_TWEEN:
					var tweenActionVO:TweenActionVO = actionVO as TweenActionVO,
						tweenActionPool:ObjectPool = objectPools[actionVO.getType()],
						tweenAction:TweenAction = tweenActionPool.allocate() as TweenAction,
						tweenActionID:String = tweenActionVO.getID();
					AssertHelpers.assertCondition((registeredActions[tweenActionID] == null), "Cannot override action with ID:" + tweenActionID);
					tweenAction.initialize(tweenActionVO);
					registeredActions[tweenActionID] = tweenAction;
					break;
				case GameConstants.ACTION_TYPE_SEQUENTIAL:
					var sequenceActionVO:SequenceActionVO = actionVO as SequenceActionVO,
						sequenceActionPool:ObjectPool = objectPools[actionVO.getType()],
						sequenceAction:SequenceAction = sequenceActionPool.allocate() as SequenceAction,
						sequenceActionID:String = sequenceActionVO.getID();
					AssertHelpers.assertCondition((registeredActions[sequenceActionID] == null), "Cannot override action with ID:" + sequenceActionID);
					sequenceActionVO.setActionPlayer(this);
					sequenceAction.initialize(sequenceActionVO);
					registeredActions[sequenceActionID] = sequenceAction;
					break;
				case GameConstants.ACTION_TYPE_PARALLEL:
					var parallelActionVO:ParallelActionVO = actionVO as ParallelActionVO,
						parallelActionPool:ObjectPool = objectPools[actionVO.getType()],
						parallelAction:ParallelAction = parallelActionPool.allocate() as ParallelAction,
						parallelActionID:String = parallelActionVO.getID();
					AssertHelpers.assertCondition((registeredActions[parallelActionID] == null), "Cannot override action with ID:" + parallelActionID);
					parallelActionVO.setActionPlayer(this);
					parallelAction.initialize(parallelActionVO);
					registeredActions[parallelActionID] = parallelAction;
					break;
			}
		}

		//==============================================================================================================
		// GETTERS
		//==============================================================================================================

		/**
		 * Returns if the proxy has any running actions
		 * @return Boolean
		 */
		public function getIsStarted():Boolean
		{
			return BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED);
		}

		/**
		 * Returns if the proxy is in paused mode
		 * @return Boolean
		 */
		public function getIsPaused():Boolean
		{
			return BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED);
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		/**
		 * Action complete handler
		 * @param completeActionVO CompleteActionPropertiesVO
		 */
		protected function handleActionComplete(completeActionVO:CompleteActionPropertiesVO):void
		{
			var completeActionID:String = completeActionVO.getID(),
				runningAction:RunningActionVO = runningActions[completeActionID],
				runningActionCompleteCallback:Function = runningAction.getActionCompleteCallback();

			// Propagate the complete event unaltered that came from the action itself
			runningActionCompleteCallback(completeActionVO);

			// Remove from the list
			var runningActionPool:ObjectPool = objectPools[RunningActionVO.NAME];
			runningAction.dispose();
			runningActionPool.release(runningAction);
			delete runningActions[completeActionID];

			// Check state
			if (DictionaryHelpers.getDictionaryEmpty(runningActions))
				state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_STARTED, GameConstants.STATE_IDLE);
		}

		protected static function prepareActionForStart(action:IAction, completeCallback:Function):void
		{
			switch (action.getType())
			{
				case GameConstants.ACTION_TYPE_SEQUENTIAL:
					var sequence:SequenceAction = action as SequenceAction;
					sequence.setChildCompleteCallback(completeCallback);
					break;
				case GameConstants.ACTION_TYPE_PARALLEL:
					var parallel:ParallelAction= action as ParallelAction;
					parallel.setChildCompleteCallback(completeCallback);
					break;
			}
		}
	}
}
