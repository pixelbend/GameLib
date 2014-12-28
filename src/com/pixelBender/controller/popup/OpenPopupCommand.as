package com.pixelBender.controller.popup
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.AssetProxy;
	import com.pixelBender.model.GameComponentProxy;
	import com.pixelBender.model.vo.note.popup.ShowPopupNotificationVO;
	import com.pixelBender.view.popup.PopupManagerMediator;
	import com.pixelBender.view.popup.PopupMediator;
	
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
			// Internals
			var popupName:String = notification.getBody() as String,
				gameComponentProxy:GameComponentProxy = facade.retrieveProxy(GameConstants.GAME_COMPONENT_PROXY_NAME) as GameComponentProxy,
				popupMediator:PopupMediator = gameComponentProxy.getPopup(popupName),
				assetProxy:AssetProxy = facade.retrieveProxy(GameConstants.ASSET_PROXY_NAME) as AssetProxy;
			// Check data consistency
			if (popupName == null || popupName.length == 0)
			{
				Logger.error(this + " Popup name cannot be null!");
				return;
			}
			if (popupMediator == null)
			{
				Logger.error(this + " Popup with name provided:[" + popupName + "] was not found!");
				return;
			}
			// Log
			Logger.info(this + " executing!");
			// Show popup
			facade.sendNotification(GameConstants.OPEN_POPUP, new ShowPopupNotificationVO(popupMediator, assetProxy));
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