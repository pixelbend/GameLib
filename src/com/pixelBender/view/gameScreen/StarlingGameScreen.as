package com.pixelBender.view.gameScreen
{
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.model.GameScreenProxy;

	import starling.display.DisplayObjectContainer;

	public class StarlingGameScreen extends GameScreenMediator
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function StarlingGameScreen(mediatorName:String)
		{
			super(mediatorName);
		}

		//==============================================================================================================
		// API THAT MUST BE OVERRIDDEN
		//==============================================================================================================

		public function prepareForStart(starlingScreenContainer:DisplayObjectContainer,
										gameScreenProxy:GameScreenProxy):void
		{
			AssertHelpers.assertCondition(false, "Implement this!");
		}
	}
}
