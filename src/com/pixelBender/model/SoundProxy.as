package com.pixelBender.model
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.MathHelpers;
	import com.pixelBender.model.vo.sound.PlaySoundPropertiesVO;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.interfaces.ISoundProxy;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.component.sound.PlaySoundComponent;
	import com.pixelBender.model.component.sound.SoundPlayer;
	import com.pixelBender.model.vo.asset.SoundAssetVO;
	import flash.utils.Dictionary;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SoundProxy extends Proxy implements ISoundProxy
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The component responsible for actually playing the registered sounds. 
		 */		
		protected var playingComponent														:PlaySoundComponent;
		
		/**
		 * All the registered sounds as a hash map. 
		 */		
		protected var librarySounds															:Dictionary;
		
		/**
		 * The maximum allowed number of channels. 
		 */		
		protected var maxSoundChannels														:int;

		/**
		 * Master volume for all sounds. Between 0 and 1
		 */
		protected var masterVolume															:Number;

		/**
		 * Internal state flag
		 */
		protected var state																	:int;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function SoundProxy(proxyName:String)
		{
			super(proxyName);
			maxSoundChannels = GameConstants.MAX_CHANNELS;
			playingComponent = new PlaySoundComponent(maxSoundChannels);
			librarySounds = new Dictionary();
			masterVolume = 1;
			state = GameConstants.STATE_IDLE;
		}
		
		//==============================================================================================================
		// ISoundProxy IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Will register each sound asset in the register hash map
		 * @param sounds Vector.<SoundAssetVO>
		 */		
		public function registerSounds(sounds:Vector.<SoundAssetVO>):void
		{
			var soundVO:SoundAssetVO;
			for each (soundVO in sounds)
			{
				// Check duplicate
				AssertHelpers.assertCondition((librarySounds[soundVO.getName()] == null),
												"Sound with name["+soundVO.getName()+"] is already registered! " +
												"Cannot register duplicate sounds!");
				if ( soundVO.getSound() != null )
				{
					librarySounds[soundVO.getName()] = soundVO.getSound();	
				}
			}
		}
		
		/**
		 * Will unregister each sound asset in the register hash map
		 * @param sounds Vector.<SoundAssetVO>
		 */
		public function unregisterSounds(sounds:Vector.<SoundAssetVO>):void
		{
			var soundVO:SoundAssetVO;
			for each (soundVO in sounds)
			{
				if ( librarySounds[soundVO.getName()] != null )
				{
					delete librarySounds[soundVO.getName()];
				}
			}
		}
		
		/**
		 * States if a sound is present in the library
		 * @param soundName String
		 * @return Boolean
		 */		
		public function isSoundRegistered(soundName:String):Boolean
		{
			return (librarySounds[soundName] != null);
		}
		
		/**
		 * Starts to play using the play sound properties
		 * @param playSoundProperties PlaySoundPropertiesVO
		 */		
		public function playSoundOnChannel(playSoundProperties:PlaySoundPropertiesVO):void
		{
			// Internals
			var soundName:String = playSoundProperties.getSoundName(),
				channelID:int = playSoundProperties.getChannelID();
			// Play 
			if (checkChannel(channelID))
			{
				if (!isSoundRegistered(soundName) )
				{
					Logger.error("Sound with ID["+soundName+"] is not registered. Cannot start playing this sound!");
				}
				else
				{
					playingComponent.playSoundOnChannel(librarySounds[soundName], playSoundProperties, masterVolume);
				}
			}
		}
		
		/**
		 * Will stop the playing sound on the specified channel
		 * @param channelID int
		 */		
		public function stopSoundOnChannel(channelID:int):void
		{
			if ( checkChannel(channelID) )
			{
				playingComponent.stopSoundOnChannel(channelID);
			}
		}
		
		/**
		 * Will pause the playing sound on the specified channel
		 */
		public function pauseSoundOnChannel(channelID:int):void
		{
			if ( checkChannel(channelID) )
			{
				playingComponent.pauseSoundOnChannel(channelID);
			}
		}
		
		/**
		 * Will resume the playing sound on the specified channel
		 */
		public function resumeSoundOnChannel(channelID:int):void
		{
			if ( checkChannel(channelID) )
			{
				playingComponent.resumeSoundOnChannel(channelID);
			}
		}
		
		/**
		 * Wrapper over stopSoundOnChannel. Can receive multiple channels. 
		 * @param channelList Vector.<int>
		 */		
		public function stopSoundOnChannels(channelList:Vector.<int>):void
		{
			var channelID:int;
			for each (channelID in channelList)
			{
				stopSoundOnChannel(channelID);
			}
		}
		
		/**
		 * Wrapper over stopSoundOnChannel. Stops all the channels. 
		 */
		public function stopAllSoundChannels():void
		{
			var i:int = 0;
			for (;i<maxSoundChannels;i++)
			{
				stopSoundOnChannel(i);
			}
		}
		
		/**
		 * Checks whether there is a playing sound on the specified channel
		 * @param channelID int
		 * @return Boolean 
		 */		
		public function isSoundPlaying(channelID:int):Boolean
		{
			return playingComponent.isSoundPlaying(channelID);
		}
		
		/**
		 * Retrieves the player on the specified channel.
		 * @param channelID int
		 * @return SoundPlayer 
		 */		
		public function getChannelPlayer(channelID:int):SoundPlayer
		{
			return playingComponent.getChannelPlayer(channelID);
		}

		/**
		 * Changes the master volume
		 * @param value Number
		 */
		public function setMasterVolume(value:Number):void
		{
			masterVolume = MathHelpers.clamp(value, 0, 1);
			playingComponent.setMasterVolume(masterVolume);
			facade.sendNotification(GameConstants.SOUND_MASTER_VOLUME_CHANGED, masterVolume);
		}

		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Pause all playing sounds 
		 */		
		public function pause():void
		{
			if (state != GameConstants.STATE_IDLE) return;
			state = GameConstants.STATE_PAUSED;
			playingComponent.pause();
		}
		
		/**
		 * Resume all playing sounds 
		 */
		public function resume():void
		{
			if (state != GameConstants.STATE_PAUSED) return;
			state = GameConstants.STATE_IDLE;
			playingComponent.resume();
		}
		
		/**
		 * Memory management 
		 */
		public function dispose():void
		{
			state = GameConstants.STATE_DISPOSED;
			if (playingComponent != null) 
			{
				playingComponent.dispose();
				playingComponent = null;
			}
			DictionaryHelpers.deleteValues(librarySounds);
			librarySounds = null;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[SoundProxy maxSoundChannels:" + maxSoundChannels + "]";
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Checks if the channel ID is valid or not.
		 * @param channelToCheck int
		 * @return Boolean 
		 */		
		protected function checkChannel(channelToCheck:int):Boolean
		{
			return channelToCheck >= 0 && channelToCheck <= maxSoundChannels;
		}
	}
}