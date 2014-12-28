package com.pixelBender.controller.asset
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.GameComponentProxy;
	import com.pixelBender.model.LocalizationProxy;
	import com.pixelBender.model.vo.InitTransitionVO;
	import com.pixelBender.model.vo.asset.AssetPackageVO;
	import com.pixelBender.model.vo.asset.SWFAssetVO;
	import com.pixelBender.model.vo.asset.XMLAssetVO;
	import com.pixelBender.view.popup.PopupMediator;
	import com.pixelBender.view.transition.TransitionView;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class GlobalAssetPackageLoadedCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Handles the global package queue loaded notification. Will init transition views that depend on lazy assets,
		 * 	popups and localization proxy.
		 * @param notification INotification
		 */		
		override public function execute(notification:INotification):void
		{
			// Internals
			var completedAssetPackage:AssetPackageVO = notification.getBody() as AssetPackageVO,
				gameComponentProxy:GameComponentProxy = facade.retrieveProxy(GameConstants.GAME_COMPONENT_PROXY_NAME) as GameComponentProxy,
				transitionView:TransitionView,
				initSWFAssetVO:SWFAssetVO,
				transitionInitVOs:Dictionary = gameComponentProxy.getTransitionInitVOs(),
				transitionInitVO:InitTransitionVO,
				transitionName:String,
				allPopupLogicXMLAsset:XMLAssetVO = completedAssetPackage.getXMLAsset(GameConstants.POPUP_LOGIC_XML_ASSET_NAME), 
				allPopupLogicXML:XML = (allPopupLogicXMLAsset != null) ? allPopupLogicXMLAsset.getXML() : null,
				popup:PopupMediator,
				popupLogicList:XMLList,
				popupLogicXML:XML,
				popupName:String,
				localizationProxy:LocalizationProxy = facade.retrieveProxy(GameConstants.LOCALIZATION_PROXY_NAME) as LocalizationProxy,
				localeTextsXMLAssetVO:XMLAssetVO = completedAssetPackage.getXMLAsset(GameConstants.LOCALE_TEXTS_ASSET_NAME),
				localeList:XMLList,
				localeTexts:XML,
				localeTextsXML:XML = (localeTextsXMLAssetVO != null) ? localeTextsXMLAssetVO.getXML() : null;
			// Parse all init VOs and initialize corresponding transition views 
			for each (transitionInitVO in transitionInitVOs) 
			{
				transitionName = transitionInitVO.getTransitionName();
				transitionView = gameComponentProxy.getTransition(transitionName);
				initSWFAssetVO = completedAssetPackage.getSWFAsset(transitionInitVO.getInitSWFAssetVOName());
				if (initSWFAssetVO == null)
				{
					Logger.error(this + " SWF Asset given as init asset for transition[" + transitionName + "] was not found in global package!");
					continue;
				}
				if (initSWFAssetVO.getContent() == null)
				{
					Logger.error(this + " SWF Asset given as init asset for transition[" + transitionName + "] has an empty content!");
					continue;
				}
				transitionView.initTransitionGraphics(initSWFAssetVO.getSwf());
				// The init VO is one shot only. Dispose
				transitionInitVO.dispose();
				delete transitionInitVOs[transitionName];
			}
			// Set back null dict. One shot
			gameComponentProxy.setTransitionInitVOs(null);
			// Now try init all popup logic
			if (allPopupLogicXML != null) 
			{
				popupLogicList = allPopupLogicXML.popup;
				for each (popupLogicXML in popupLogicList) 
				{
					popupName = String(popupLogicXML.@name);
					popup = gameComponentProxy.getPopup(popupName);
					if (popup != null)
					{
						popup.setLogicXML(popupLogicXML);	
					}
					else
					{
						Logger.warning(this+"The logic popup XML node with name identifier[" + popupName + "] did not find a corresponding popup mediator!");
					}
				}
			}
			// Now localization proxy
			if (localeTextsXML != null) 
			{
				localeList = localeTextsXML.locale;
				for each (localeTexts in localeList)
				{
					localizationProxy.parseLocale(localeTexts);
				}
			}
		}
		
		//==============================================================================================================
		// DEBUG
		//==============================================================================================================
		
		public function toString():String
		{
			return "[GlobalAssetPackageLoadedCommand]";
		}
	}
}