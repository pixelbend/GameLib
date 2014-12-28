package com.pixelBender.model.vo
{
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.view.transition.TransitionView;
	
	public class ScreenTransitionSequenceVO implements IDispose
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Sequence identifier
		 */
		private var name																:String;

		/**
		 * The transitions in the sequence
		 */
		private var transitions															:Vector.<TransitionView>;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function ScreenTransitionSequenceVO(name:String)
		{
			this.name = name;
		}

		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		public function dispose():void
		{
			IRunnableHelpers.dispose(transitions);
			transitions = null;
		}

		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================
		
		public function setTransitionViews(transitionViews:Vector.<TransitionView>):void
		{
			this.transitions = transitionViews;
		}
		
		public function getTransitionAtIndex(index:int):TransitionView
		{
			if (index >=0 && index < transitions.length)
			{
				return transitions[index];
			}
			return null;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[ScreenTransitionSequenceVO name:" + name + "]";
		}
	}
}