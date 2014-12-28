package com.pixelBender.view.gameScreen
{
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.model.GameScreenProxy;

	import flash.display.DisplayObjectContainer;

	public class NormalDisplayGameScreen extends GameScreenMediator
	{
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		public function NormalDisplayGameScreen(mediatorName:String)
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
