package com.pixelBender.controller.sound
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.AssetProxy;
	import com.pixelBender.model.SoundProxy;
	import com.pixelBender.model.vo.asset.AssetPackageVO;
	import com.pixelBender.model.vo.asset.AssetVO;
	import com.pixelBender.model.vo.asset.SoundAssetVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class RegisterUnregisterAssetPackageSoundsCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Will register all sound assets from the given package.
		 * @param notification INotification
		 */		
		override public function execute(notification:INotification):void
		{
			// Internals
			var assetProxy:AssetProxy = facade.retrieveProxy(GameConstants.ASSET_PROXY_NAME) as AssetProxy,
				soundProxy:SoundProxy = facade.retrieveProxy(GameConstants.SOUND_PROXY_NAME) as SoundProxy,
				assetPackageName:String = notification.getBody() as String,
				soundsToHandle:Vector.<SoundAssetVO> = new Vector.<SoundAssetVO>(),
				assetPackage:AssetPackageVO = assetProxy.getPackage(assetPackageName),
				assetChildren:Vector.<AssetVO>,
				assetVO:AssetVO;

			// Check data integrity
			if (assetPackage != null) 
			{
				// Get asset children
				assetChildren = assetPackage.getAssetChildren();
				// Filter package assets and register with the sound proxy.
				for each (assetVO in assetChildren )
				{
					if (assetVO is SoundAssetVO)
					{
						soundsToHandle.push(assetVO);
					}
				}
				// Register
				if (notification.getType() == GameConstants.TYPE_REGISTER_ASSET_PACKAGE_SOUNDS)
				{
					soundProxy.registerSounds(soundsToHandle);
				}
				else
				{
					soundProxy.unregisterSounds(soundsToHandle);
				}
			} 
			else 
			{
				Logger.warning(this + "Asset package with name["+assetPackageName+"] is not registered with AssetProxy");
			}
		}
		
		//==============================================================================================================
		// DEBUG
		//==============================================================================================================
		
		public function toString():String
		{
			return "[RegisterAssetPackageSoundsCommand]";
		}
	}
}