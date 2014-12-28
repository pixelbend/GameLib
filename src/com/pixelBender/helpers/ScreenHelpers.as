package com.pixelBender.helpers
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.controller.gameScreen.vo.ShowGameScreenCommandVO;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.GameScreenProxy;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.view.gameScreen.GameScreenMediator;

	public class ScreenHelpers extends GameHelpers
	{
		//==============================================================================================================
		// STATIC API
		//==============================================================================================================

		public static function initialize():void
		{
			objectPoolMap[ShowGameScreenCommandVO.NAME] = objectPoolManager.retrievePool(ShowGameScreenCommandVO.NAME);
		}
		
		public static function showScreen(screenName:String, transitionName:String=null):void
		{
			var pool:ObjectPool = objectPoolMap[ShowGameScreenCommandVO.NAME],
				noteVO:ShowGameScreenCommandVO = pool.allocate() as ShowGameScreenCommandVO;
			noteVO.initialize(screenName, transitionName);
			facade.sendNotification(GameConstants.SHOW_GAME_SCREEN, noteVO);
			pool.release(noteVO);
		}

		public static function unregisterDefaultPackageSounds(gameScreen:GameScreenMediator):void
		{

		}


	}
}