package com.pixelBender.view.transition
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.MovieClipHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.log.Logger;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class TransitionView implements IPauseResume
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Transition unique identifier 
		 */		
		protected var name														:String;
		
		/**
		 * Transition state 
		 */		
		protected var state														:int;
		
		/**
		 * Callback invoked when transition is complete 
		 */		
		protected var completeCallback											:Function;
		
		/**
		 * Transition view component 
		 */		
		protected var transitionViewComponent									:flash.display.DisplayObject;

		/**
		 * Starling transition view component
		 */
		protected var starlingTransitionViewComponent							:starling.display.DisplayObject;
		
		/**
		 * Transition view component casted as MovieClip 
		 */		
		protected var transitionMovieClip										:MovieClip;
		
		/**
		 * Internal flag 
		 */		
		protected var transitionStopPending										:Boolean;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor 
		 * @param name String
		 */		
		public function TransitionView(name:String)
		{
			this.name = name;
			state = GameConstants.STATE_IDLE;
		}
		
		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Pauses the transition 
		 */		
		public function pause():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_PLAYING)) return;
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
			pauseTransition();
		}
		
		/**
		 * Resumes the transition 
		 */
		public function resume():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED)) return;
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
			resumeTransition();
		}
		
		/**
		 * Memory management 
		 */
		public function dispose():void
		{
			state = GameConstants.STATE_DISPOSED;
			stop();
			name = null;
			completeCallback = null;
			MovieClipHelpers.removeFromParent(transitionViewComponent);
			transitionViewComponent = null;
			StarlingHelpers.removeFromParent(starlingTransitionViewComponent);
			starlingTransitionViewComponent = null;
			transitionMovieClip = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * 
		 * @param graphics DisplayObject
		 */		
		public function initTransitionGraphics(graphics:flash.display.DisplayObject):void
		{
			transitionViewComponent = graphics;
			transitionMovieClip = graphics as MovieClip;
		}
		
		/**
		 * Plays the transition
		 * @param completeCallback Function
		 * @param loop Boolean
		 */		
		public function play(completeCallback:Function, loop:Boolean):void
		{
			// Check state
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_IDLE)) return;
			// Start playing
			this.state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_IDLE, GameConstants.STATE_PLAYING);
			this.transitionStopPending = !loop;
			this.completeCallback = completeCallback;
			playTransition();
		}
		
		/**
		 * Marks that the transition should be stopped upon next loop done.
		 */		
		public function stopOnNextLoopComplete():void
		{
			transitionStopPending = true;
		}
		
		/**
		 * Stops the transition from playing. 
		 */		
		public function stop():void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_PLAYING)) return;
			state = BitMaskHelpers.switchMaskState(state, GameConstants.STATE_PLAYING, GameConstants.STATE_IDLE);
			stopTransition();
			transitionStopPending = false;
			invokeCallback();
		}
		
		/**
		 * Sets transition parents, both.
		 * @param parent DisplayObjectContainer
		 * @param starlingParent DisplayObjectContainer
		 */		
		public function addViewComponentParents(parent:flash.display.DisplayObjectContainer,
													starlingParent:starling.display.DisplayObjectContainer):void
		{
			// Some transitions may not have transition view components. Skip step in this case.
			if (transitionViewComponent != null && parent != null)
			{
				parent.addChild(transitionViewComponent);
			}
			// Some transitions may not have transition view components. Skip step in this case.
			if (starlingTransitionViewComponent != null && starlingParent != null)
			{
				starlingParent.addChild(starlingTransitionViewComponent);
			}
		}

		/**
		 * Removes the transition view components from their respective parents
		 */
		public function removeViewComponentParents():void
		{
			MovieClipHelpers.removeFromParent(transitionViewComponent);
			StarlingHelpers.removeFromParent(starlingTransitionViewComponent, false);
		}

		/**
		 * Unique identifier
		 * @return String 
		 */		
		public function getName():String
		{
			return name;
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Loop complete handler
		 * @param e Event
		 */		
		protected function handleLoopComplete(e:Event=null):void
		{
			Logger.debug(this + " loop complete received!");
			if (transitionStopPending)
			{
				Logger.debug(this + " invoking stop!");
				stop();

			}
		}
		
		/**
		 * Invokes the complete callback 
		 */		
		protected function invokeCallback():void
		{
			// Assert proper state
			if (state == GameConstants.STATE_DISPOSED) return;
			// Clone reference so that invoke() is the LAST call made.
			var invoke:Function = completeCallback;
			if (completeCallback != null)
			{
				completeCallback = null;
				invoke();
			}
		}
		
		//==============================================================================================================
		// EMPTY LOCALS. FOR EXTENDED CLASSES TO USE.
		//==============================================================================================================
		
		/**
		 * Called from play(). Useful for extended classes to implement concrete functionality. 
		 */		
		protected function playTransition():void {}
		
		/**
		 * Called from pause(). Useful for extended classes to implement concrete functionality. 
		 */
		protected function pauseTransition():void{}
		
		/**
		 * Called from resume(). Useful for extended classes to implement concrete functionality. 
		 */
		protected function resumeTransition():void{}
		
		/**
		 * Called from stop(). Useful for extended classes to implement concrete functionality. 
		 */
		protected function stopTransition():void{}
	}
}