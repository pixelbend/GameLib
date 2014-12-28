package com.pixelBender.controller.asset
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.constants.GameReflections;
	import com.pixelBender.controller.asset.vo.ParseAndRegisterAssetPackageCommandVO;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.model.AssetProxy;
	import com.pixelBender.model.vo.asset.AssetPackageVO;
	import com.pixelBender.model.vo.asset.AssetVO;
	
	import flash.system.ApplicationDomain;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ParseAndRegisterAssetPackageCommand extends SimpleCommand
	{
		
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Will parse the package XML given in the notification body
		 * @param notification INotification
		 */		
		override public function execute(notification:INotification):void
		{
			// Internals
			var commandVO:ParseAndRegisterAssetPackageCommandVO = notification.getBody() as ParseAndRegisterAssetPackageCommandVO,
				packageXML:XML = commandVO.getPackageXML(),
				parentPackage:AssetPackageVO = commandVO.getParentPackage(),
				isGlobalPackage:Boolean = commandVO.getIsGlobalPackage(),
				addPackageToQueue:Boolean = commandVO.getAddToQueue(),
				packageName:String = String(packageXML.@name),
				packageType:String = String(packageXML.@type),
				assetPackageVO:AssetPackageVO, // Root package
				children:XMLList = packageXML.children(),
				assetProxy:AssetProxy = facade.retrieveProxy(GameConstants.ASSET_PROXY_NAME) as AssetProxy,
				child:XML; 
			// Check data
			AssertHelpers.assertCondition((packageName.length>0), "Asset package has no name!");
			// Default package type
			if (packageType.length == 0) {
				packageType = GameConstants.ASSET_PACKAGE_TYPE_GENERIC;
			}
			assetPackageVO = new AssetPackageVO(packageName, packageType);
			// Parse children
			for each ( child in children )
			{
				switch (String(child.name()))
				{
					case GameConstants.ASSET_PACKAGE_XML_NAME:
						sendNotification(GameConstants.PARSE_AND_REGISTER_ASSET_PACKAGE,
											new ParseAndRegisterAssetPackageCommandVO(child, assetPackageVO));
						break;
					default:
						createAsset(child, assetPackageVO);
						break;
				}
			}
			// Assign to parent
			if (parentPackage != null)
			{
				parentPackage.addChild(assetPackageVO);				
			}
			// Register to asset proxy
			assetProxy.registerPackage(assetPackageVO);
			// Assign to command
			commandVO.setRegisteredPackage(assetPackageVO);
			// Check package priority
			if (isGlobalPackage)
			{
				assetProxy.setGlobalPackageName(assetPackageVO.getName());
			}
			// Add to queue if necessary
			if (addPackageToQueue)
			{
				assetProxy.addPackageToLoadQueue(assetPackageVO.getName());
			}
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Will initialize the AssetVO using the reflection dictionary
		 */
		private static function createAsset(assetXML:XML, parentPackage:AssetPackageVO):void
		{
			// Internals
			var assetType:String = String(assetXML.name()),
				className:String = GameReflections.getAssetQualifiedClassName(assetType),
				assetClass:Class = ApplicationDomain.currentDomain.getDefinition(className) as Class,
				assetVO:AssetVO = new assetClass(String(assetXML.@name), String(assetXML.@url));
			// Add asset to parent package
			parentPackage.addChild(assetVO);
		}
	}
}