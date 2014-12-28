package com.pixelBender.view.gameScreen
{
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.model.GameScreenProxy;
	import flash.display.DisplayObjectContainer;
	import starling.display.DisplayObjectContainer;

	public class DualGameScreenMediator extends GameScreenMediator
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function DualGameScreenMediator(mediatorName:String)
		{
			super(mediatorName);
		}

		//==============================================================================================================
		// API THAT MUST BE OVERRIDDEN
		//==============================================================================================================

		public function prepareForStart(screenContainer:flash.display.DisplayObjectContainer,
										starlingScreenContainer:starling.display.DisplayObjectContainer,
										gameScreenProxy:GameScreenProxy):void
		{
			AssertHelpers.assertCondition(false, "Implement this!");
		}
	}
}
