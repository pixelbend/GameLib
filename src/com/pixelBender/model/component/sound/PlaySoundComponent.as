package com.pixelBender.model.component.sound
{
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.IRunnableHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.log.Logger;
	import com.pixelBender.model.vo.sound.CompleteSoundPropertiesVO;
	import com.pixelBender.model.vo.sound.PlaySoundPropertiesVO;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.pool.ObjectPoolManager;
	import flash.media.Sound;

	public class PlaySoundComponent implements IPauseResume
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * The maximum number of sound channels
		 */
		protected var maxSoundChannels													:uint;

		/**
		 * The sound players.
		 */		
		protected var soundPlayers														:Vector.<SoundPlayer>;

		/**
		 * The object pool used to spawn sound players
		 */
		protected var soundPlayerPool													:ObjectPool;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor
		 * @param numPlayers int - the initial number of channels.
		 */		
		public function PlaySoundComponent(numPlayers:int)
		{
			maxSoundChannels = numPlayers;
			soundPlayers = new Vector.<SoundPlayer>(numPlayers);
			soundPlayerPool = ObjectPoolManager.getInstance().retrievePool(SoundPlayer.NAME);
		}
		
		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Pause all playing sounds 
		 */		
		public function pause():void
		{
			IRunnableHelpers.pause(soundPlayers);
		}
		
		/**
		 * Resume all playing sounds 
		 */
		public function resume():void
		{
			IRunnableHelpers.resume(soundPlayers);
		}
		
		/**
		 * Memory management 
		 */
		public function dispose():void
		{
			IRunnableHelpers.dispose(soundPlayers);
			soundPlayers = null;
			soundPlayerPool = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Starts to play the given sound on the specified channel
		 * @param sound Sound
		 * @param playProperties PlaySoundPropertiesVO
		 * @param masterVolume Number
		 */		
		public function playSoundOnChannel(sound:Sound, playProperties:PlaySoundPropertiesVO, masterVolume:Number):void
		{
			// Check channel available
			var channelID:int = playProperties.getChannelID();
			AssertHelpers.assertCondition((channelID < maxSoundChannels),
											this + "Channel ID:[" + channelID + "] is not allocated!");
			// Play
			tryPlaySound(sound, playProperties, masterVolume);
		}
		
		/**
		 * Pauses the playing sound (if any) on the specified channel
		 * @param channelID int
		 */
		public function pauseSoundOnChannel(channelID:int):void
		{
			// Check channel available
			AssertHelpers.assertCondition((channelID < maxSoundChannels),
											this + "Channel ID:[" + channelID + "] is not allocated!");
			if (soundPlayers[channelID] != null)
			{
				soundPlayers[channelID].pause();
			}
		}
		
		/**
		 * Resumes the playing sound (if any) on the specified channel
		 * @param channelID int
		 */
		public function resumeSoundOnChannel(channelID:int):void
		{
			// Check channel available
			AssertHelpers.assertCondition((channelID < maxSoundChannels),
											this + "Channel ID:[" + channelID + "] is not allocated!");
			if (soundPlayers[channelID] != null)
			{
				soundPlayers[channelID].resume();
			}
		}
		
		/**
		 * Stops the playing sound (if any) on the specified channel
		 * @param channelID int
		 */
		public function stopSoundOnChannel(channelID:int):void
		{
			// Check channel available
			AssertHelpers.assertCondition((channelID < maxSoundChannels),
											this + "Channel ID:[" + channelID + "] is not allocated!");
			if (soundPlayers[channelID] != null)
			{
				soundPlayers[channelID].stop();
			}
		}
		
		/**
		 * Checks whether if there is a playing sound on the specified channel
		 * @param channelID int
		 * @return Boolean
		 */		
		public function isSoundPlaying(channelID:int):Boolean
		{
			// Check channel available
			AssertHelpers.assertCondition((channelID < maxSoundChannels),
											this + "Channel ID:[" + channelID + "] is not allocated!");
			// If no player allocated, no sound is playing now is it?
			if (soundPlayers[channelID] == null)
			{
				return false;
			}
			return soundPlayers[channelID].getIsPlaying();
		}

		/**
		 * Updates all playing sounds with the new volume
		 * @param value
		 */
		public function setMasterVolume(value:Number):void
		{
			for (var i:int=0; i<soundPlayers.length; i++)
			{
				if (soundPlayers[i] != null)
				{
					soundPlayers[i].setMasterVolume(value);
				}
			}
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[PlaySoundComponent]";
		}
		
		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================
		
		/**
		 * Retrieves the player on the specified channel
		 * @param channelID int
		 * @return SoundPlayer
		 */		
		public function getChannelPlayer(channelID:int):SoundPlayer
		{
			// Check channel available
			AssertHelpers.assertCondition((channelID < maxSoundChannels),
											this + "Channel ID:[" + channelID + "] is not allocated!");
			return soundPlayers[channelID];
		}
				
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Will validate if the sound described by it's properties can be started on the given channel.
		 * @param sound Sound - the new sound that should be started
		 * @param playProperties PlaySoundPropertiesVO - the sound play properties
		 * @param masterVolume Number - The master volume for all sounds. Will be taken into consideration when computing
		 * 									each individual sound volume
		 */
		protected function tryPlaySound(sound:Sound, playProperties:PlaySoundPropertiesVO, masterVolume:Number):void
		{
			// Internals
			var channelID:int = playProperties.getChannelID(),
				soundPlayer:SoundPlayer = soundPlayers[channelID],
				currentPlayPropertiesVO:PlaySoundPropertiesVO,
				completeCallback:Function;
			// Info
			Logger.info(this + " Trying to start sound[" + playProperties.getSoundName() + "] on channel[" +
							SoundHelpers.channelIDToString(playProperties.getChannelID()) + "]");
			// Check new sound properties to validate start
			if (soundPlayer != null)
			{
				currentPlayPropertiesVO = soundPlayer.getCurrentPlayingProperties();
				// Check sound priority
				if (currentPlayPropertiesVO.getPriority() > playProperties.getPriority())
				{
					// We can't even start the new sound now can we?
					completeCallback = playProperties.getCompleteCallback();
					if (completeCallback != null)
					{
						// Call complete with startAborted flag set in complete VO
						Logger.info(this + " Aborting start sound[" + playProperties.getSoundName() + "] on channel[" +
									channelID + "] due to priority check fail");
						// Create complete VO
						var pool:ObjectPool = ObjectPoolManager.getInstance().retrievePool(CompleteSoundPropertiesVO.NAME),
							completeVO:CompleteSoundPropertiesVO = pool.allocate() as CompleteSoundPropertiesVO;
						// Initialize VO
						completeVO.initializeVO(true, true, playProperties.getSoundName(), playProperties.getChannelID(),
												playProperties.getCompleteCallback(), playProperties.getPriority(),
												playProperties.getVolume(), playProperties.getLoops());
						// Invoke
						completeCallback(completeVO);
						// Release back to pool
						pool.release(completeVO);
					}
					return;
				}
				else
				{
					soundPlayer.stop();
				}
			}
			// Start the new sound (overriding if necessary the old one)
			Logger.info(this + " Starting sound[" + playProperties.getSoundName() + "] on channel[" + channelID + "]");
			soundPlayer = soundPlayerPool.allocate() as SoundPlayer;
			soundPlayers[channelID] = soundPlayer;
			soundPlayer.play(sound, playProperties, masterVolume, handleSoundComplete);
		}
		
		/**
		 * The sound complete handler
		 * @param completeSoundVO CompleteSoundPropertiesVO
		 */		
		protected function handleSoundComplete(completeSoundVO:CompleteSoundPropertiesVO):void
		{
			// Internals
			var completeCallback:Function = completeSoundVO.getCompleteCallback(),
				channelID:int = completeSoundVO.getChannelID(),
				soundPlayer:SoundPlayer = soundPlayers[channelID];
			// Terminate the sound on the current channel
			if (soundPlayer != null)
			{
				soundPlayers[channelID] = null;
				soundPlayer.clear();
				soundPlayerPool.release(soundPlayer);
			}
			// Call the complete callback
			if (completeCallback != null)
			{
				completeCallback(completeSoundVO);
			}
		}
	}
}