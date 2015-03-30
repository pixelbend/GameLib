package com.pixelBender.interfaces
{
	import com.pixelBender.model.vo.sound.PlaySoundPropertiesVO;
	import com.pixelBender.model.component.sound.SoundPlayer;
	import com.pixelBender.model.vo.asset.SoundAssetVO;
	import org.puremvc.as3.interfaces.IProxy;

	public interface ISoundProxy extends IPauseResume,IProxy
	{
		function registerSounds(sounds:Vector.<SoundAssetVO>):void;
		function unregisterSounds(sounds:Vector.<SoundAssetVO>):void;
		function isSoundRegistered(soundName:String):Boolean;
		function playSoundOnChannel(playSoundProperties:PlaySoundPropertiesVO):void;
		function stopSoundOnChannel(channelID:int):void;
		function pauseSoundOnChannel(channelID:int):void;
		function resumeSoundOnChannel(channelID:int):void;
		function stopSoundOnChannels(channelList:Vector.<int>):void;
		function stopAllSoundChannels():void;
		function isSoundPlaying(channelID:int):Boolean;
		function getChannelPlayer(channelID:int):SoundPlayer;
		function setMasterVolume(value:Number):void;
	}
}