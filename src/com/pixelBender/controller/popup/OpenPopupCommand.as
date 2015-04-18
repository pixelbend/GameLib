package com.pixelBender.controller.popup
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.AssetProxy;
	import com.pixelBender.model.GameComponentProxy;
	import com.pixelBender.model.vo.note.popup.ShowPopupNotificationVO;
	import com.pixelBender.view.popup.PopupMediator;
	import com.pixelBender.view.popup.vo.OpenPopupVO;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class OpenPopupCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Pauses all game components
		 * @param notification INotification
		 */		
		override public function execute(notification:INotification):void
		{
			var openPopupVO:OpenPopupVO = notification.getBody() as OpenPopupVO,
				popupName:String = openPopupVO.getPopupName(),
				popupVO:Object = openPopupVO.getPopupVO(),
				gameComponentProxy:GameComponentProxy = facade.retrieveProxy(GameConstants.GAME_COMPONENT_PROXY_NAME) as GameComponentProxy,
				assetProxy:AssetProxy = facade.retrieveProxy(GameConstants.ASSET_PROXY_NAME) as AssetProxy,
				popupMediator:PopupMediator;

			AssertHelpers.assertCondition((popupName != null && popupName.length > 0), "Popup name cannot be null!");

			popupMediator = gameComponentProxy.getPopup(popupName);
			AssertHelpers.assertCondition(popupMediator != null, "Popup with name provided:[" + popupName + "] was not found!");

			Logger.info(this + " executing!");
			facade.sendNotification(GameConstants.OPEN_POPUP, new ShowPopupNotificationVO(popupMediator, assetProxy, popupVO));
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function toString():String
		{
			return "[OpenPopupCommand]";
		}
	}
}