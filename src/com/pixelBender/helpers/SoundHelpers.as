package com.pixelBender.helpers
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.component.sound.SoundPlayer;
	import com.pixelBender.model.component.sound.SoundQueuePlayer;
	import com.pixelBender.model.vo.sound.PlayQueuePropertiesVO;
	import com.pixelBender.model.vo.sound.PlaySoundPropertiesVO;
	import com.pixelBender.model.vo.sound.RetrieveCurrentPlayingSoundVO;
	import com.pixelBender.pool.ObjectPool;

	public class SoundHelpers extends GameHelpers
	{
		//==============================================================================================================
		// OBJECT POOL API
		//==============================================================================================================

		/**
		 * Initialize all needed object pools
		 */
		public static function initialize():void
		{
			objectPoolMap[PlaySoundPropertiesVO.NAME] = objectPoolManager.retrievePool(PlaySoundPropertiesVO.NAME);
			objectPoolMap[RetrieveCurrentPlayingSoundVO.NAME] = objectPoolManager.retrievePool(RetrieveCurrentPlayingSoundVO.NAME);
		}

		//==============================================================================================================
		// STATIC SOUND API
		//==============================================================================================================

		/**
		 * Wrapper over the play sound notification. Creates the notification VO on the spot, with the specified parameters,
		 *    setting the sound channel to voice.
		 * @param soundName String - sound identifier. Must be already registered with the sound proxy in order to work
		 * @param channelID int - the channel on which the sound will be played
		 * @param completeCallback Function - callback called when sound is complete
		 * @param priority int = 0 - the sound priority. If there is a sound with a higher priority already playing,
		 *                                this sound will not start if checkPriority is true
		 * @param volume int = 100 - the volume of the sound. Between 0 (mute) and 100 (full volume)
		 * @param loops int = 1 - the number of loops the sound will play
		 */
		public static function playSound(soundName:String, channelID:int, completeCallback:Function, priority:int = 0, volume:int = 100, loops:int = 1):void
		{
			var pool:ObjectPool = objectPoolMap[PlaySoundPropertiesVO.NAME],
				noteVO:PlaySoundPropertiesVO = pool.allocate() as PlaySoundPropertiesVO;
			noteVO.initialize(soundName, channelID, completeCallback, priority, volume, loops);
			facade.sendNotification(GameConstants.PLAY_SOUND_ON_CHANNEL, noteVO);
			noteVO.clear();
			pool.release(noteVO);
		}

		/**
		 * Wrapper over the play sound notification. Creates the notification VO on the spot, with the specified parameters,
		 *    setting the sound channel to voice.
		 * @param soundName String - sound identifier. Must be already registered with the sound proxy in order to work
		 * @param completeCallback Function - callback called when sound is complete
		 * @param priority int = 0 - the sound priority. If there is a sound with a higher priority already playing,
		 *                                this sound will not start if checkPriority is true
		 * @param volume int = 100 - the volume of the sound. Between 0 (mute) and 100 (full volume)
		 * @param loops int = 1 - the number of loops the sound will play
		 */
		public static function playSoundOnVoiceChannel(soundName:String, completeCallback:Function, priority:int = 0, volume:int = 100, loops:int = 1):void
		{
			playSound(soundName, GameConstants.CHANNEL_VOICE, completeCallback, priority, volume, loops);
		}

		/**
		 * Wrapper over the play sound notification. Creates the notification VO on the spot, with the specified parameters,
		 *    setting the sound channel to SFX.
		 * @param soundName String - sound identifier. Must be already registered with the sound proxy in order to work
		 * @param completeCallback Function - callback called when sound is complete
		 * @param priority int = 0 - the sound priority. If there is a sound with a higher priority already playing,
		 *                                this sound will not start if checkPriority is true
		 * @param volume int = 100 - the volume of the sound. Between 0 (mute) and 100 (full volume)
		 * @param loops int = 1 - the number of loops the sound will play
		 */
		public static function playSoundOnSFXChannel(soundName:String, completeCallback:Function, priority:int = 0, volume:int = 100, loops:int = 1):void
		{
			playSound(soundName, GameConstants.CHANNEL_SFX, completeCallback, priority, volume, loops);
		}

		/**
		 * Wrapper over the play sound notification. Creates the notification VO on the spot, with the specified parameters,
		 *    setting the sound channel to ambiance.
		 * @param soundName String - sound identifier. Must be already registered with the sound proxy in order to work
		 * @param completeCallback Function - callback called when sound is complete
		 * @param priority int = 0 - the sound priority. If there is a sound with a higher priority already playing,
		 *                                this sound will not start if checkPriority is true
		 * @param volume int = 100 - the volume of the sound. Between 0 (mute) and 100 (full volume)
		 * @param loops int = 1 - the number of loops the sound will play
		 */
		public static function playSoundOnAmbianceChannel(soundName:String, completeCallback:Function, priority:int = 0, volume:int = 100, loops:int = int.MAX_VALUE):void
		{
			playSound(soundName, GameConstants.CHANNEL_AMBIANCE, completeCallback, priority, volume, loops);
		}

		/**
		 * Retrieves the current playing sound (if any) on the specified channel
		 * @channelID int - sound channel identifier
		 * @return :
		 * 		- SoundPlayer instance if the there is a sound playing
		 * 		- null otherwise
		 */
		public static function retrievePlayingSoundOnChannel(channelID:int):SoundPlayer
		{
			// Internals
			var pool:ObjectPool = objectPoolMap[RetrieveCurrentPlayingSoundVO.NAME],
				noteVO:RetrieveCurrentPlayingSoundVO = pool.allocate() as RetrieveCurrentPlayingSoundVO,
				player:SoundPlayer;
			// Retrieve
			noteVO.initialize(channelID);
			facade.sendNotification(GameConstants.RETRIEVE_CURRENT_PLAYING_SOUND, noteVO);
			player = noteVO.getPlayer();
			// Clear VO
			noteVO.clear();
			pool.release(noteVO);
			// Done
			return player;
		}

		/**
		 * Wrapper over retrievePlayingSoundOnChannel API call. Retrieves the player on the voice channel
		 */
		public static function retrievePlayingSoundOnVoiceChannel():SoundPlayer
		{
			return retrievePlayingSoundOnChannel(GameConstants.CHANNEL_VOICE);
		}

		/**
		 * Wrapper over retrievePlayingSoundOnChannel API call. Retrieves the player on the SFX channel
		 */
		public static function retrievePlayingSoundOnSFXChannel():SoundPlayer
		{
			return retrievePlayingSoundOnChannel(GameConstants.CHANNEL_SFX);
		}

		/**
		 * Wrapper over retrievePlayingSoundOnChannel API call. Retrieves the player on the ambiance channel
		 */
		public static function retrievePlayingSoundOnAmbianceChannel():SoundPlayer
		{
			return retrievePlayingSoundOnChannel(GameConstants.CHANNEL_AMBIANCE);
		}

		/**
		 * Wrapper over the resume/pause sound notification. Will pause the sound on the specified channel.
		 * @param channelID int
		 */	
		public static function pauseSoundOnChannel(channelID:int):void
		{
			facade.sendNotification(GameConstants.PAUSE_RESUME_SOUND_ON_CHANNEL, channelID, GameConstants.TYPE_PAUSE_SOUND);
		}

		/**
		 * Wrapper over pauseSoundOnChannel API call. Will pause the current play sound (if any) on the voice channel
		 */
		public static function pauseSoundOnVoiceChannel():void
		{
			pauseSoundOnChannel(GameConstants.CHANNEL_VOICE);
		}

		/**
		 * Wrapper over pauseSoundOnChannel API call. Will pause the current play sound (if any) on the SFX channel
		 */
		public static function pauseSoundOnSFXChannel():void
		{
			pauseSoundOnChannel(GameConstants.CHANNEL_SFX);
		}

		/**
		 * Wrapper over pauseSoundOnChannel API call. Will pause the current play sound (if any) on the Ambiance channel
		 */
		public static function pauseSoundOnAmbianceChannel():void
		{
			pauseSoundOnChannel(GameConstants.CHANNEL_AMBIANCE);
		}
		
		/** 
		 * Wrapper over the resume/pause sound notification. Will resume the sound on the specified channel.
		 * @param channelID int
		 */	
		public static function resumeSoundOnChannel(channelID:int):void
		{
			facade.sendNotification(GameConstants.PAUSE_RESUME_SOUND_ON_CHANNEL, channelID, GameConstants.TYPE_RESUME_SOUND);
		}

		/**
		 * Wrapper over resumeSoundOnChannel API call. Will pause the current play sound (if any) on the voice channel
		 */
		public static function resumeSoundOnVoiceChannel():void
		{
			resumeSoundOnChannel(GameConstants.CHANNEL_VOICE);
		}

		/**
		 * Wrapper over resumeSoundOnChannel API call. Will pause the current play sound (if any) on the SFX channel
		 */
		public static function resumeSoundOnSFXChannel():void
		{
			resumeSoundOnChannel(GameConstants.CHANNEL_SFX);
		}

		/**
		 * Wrapper over resumeSoundOnChannel API call. Will pause the current play sound (if any) on the ambiance channel
		 */
		public static function resumeSoundOnAmbianceChannel():void
		{
			resumeSoundOnChannel(GameConstants.CHANNEL_AMBIANCE);
		}
		
		/** 
		 * Wrapper over the stop sound notification. Will stop the sound on the specified channel.
		 * @param channelID int
		 */	
		public static function stopSoundOnChannel(channelID:int):void
		{
			facade.sendNotification(GameConstants.STOP_SOUND_ON_CHANNEL, channelID);
		}
		
		/** 
		 * Wrapper over the stop sound wrapper. Will stop the sound on the voice channel.
		 */	
		public static function stopSoundOnVoiceChannel():void
		{
			stopSoundOnChannel(GameConstants.CHANNEL_VOICE);
		}

		/** 
		 * Wrapper over the stop sound wrapper. Will stop the sound on the SFX channel.
		 */	
		public static function stopSoundOnSFXChannel():void
		{
			stopSoundOnChannel(GameConstants.CHANNEL_SFX);
		}

		/**
		 * Wrapper over the stop sound wrapper. Will stop the sound on the ambiance channel.
		 */
		public static function stopSoundOnAmbianceChannel():void
		{
			stopSoundOnChannel(GameConstants.CHANNEL_AMBIANCE);
		}

		/** 
		 * Wrapper over the stop sound notification. Will stop all sounds.
		 */	
		public static function stopAllSoundsOnChannels():void
		{
			facade.sendNotification(GameConstants.STOP_SOUNDS_ON_ALL_CHANNELS);
		}
		
		/** 
		 * Wrapper over the register/unregister asset package sound notification. 
		 * Will register the SoundAssetVO in the given package name. 
		 */	
		public static function registerAssetPackageSounds(assetPackageName:String):void
		{
			facade.sendNotification(GameConstants.REGISTER_UNREGISTER_ASSET_PACKAGE_SOUNDS, assetPackageName,
												GameConstants.TYPE_REGISTER_ASSET_PACKAGE_SOUNDS);
		}
		
		/** 
		 * Wrapper over the register/unregister asset package sound notification. 
		 * Will unregister the SoundAssetVO in the given package name. 
		 */	
		public static function unregisterAssetPackageSounds(assetPackageName:String):void
		{
			facade.sendNotification(GameConstants.REGISTER_UNREGISTER_ASSET_PACKAGE_SOUNDS, assetPackageName,
												GameConstants.TYPE_UNREGISTER_ASSET_PACKAGE_SOUNDS);
		}
		
		//==============================================================================================================
		// STATIC SOUND QUEUE API
		//==============================================================================================================
		
		/**
		 * Will create a new queue player with the specified parameters
		 * @param queueName String - queue name identifier.
		 * @param soundNames Vector.<String> - sound identifiers. Must be already registered with the sound proxy in order to work
		 * @param channelID int - the channel identifier on which all the sounds in the queue will be played
		 * @param completeCallback Function - callback called when sound is complete
		 * @param priority int = 0 - the sound priority. If there is a sound with a higher priority already playing,
		 * 								this sound will not start if checkPriority is true
		 * @param volume int = 100 - the volume of the sound. Between 0 (mute) and 100 (full volume)
		 * @param loops int = 1 - the number of loops the sound will play
		 */
		public static function createQueuePlayer(queueName:String, soundNames:Vector.<String>, channelID:int, completeCallback:Function,
												 	priority:int=0, volume:int=100, loops:int=1):SoundQueuePlayer
		{
			var queuePlayProperties:PlayQueuePropertiesVO = new PlayQueuePropertiesVO();
			queuePlayProperties.initialize(queueName, soundNames, channelID, completeCallback, priority, volume, loops);
			return new SoundQueuePlayer(queuePlayProperties);
		}
		
		/**
		 * Will create a new queue player with the specified parameters
		 * @param queueName String - queue name identifier.
		 * @param soundNames Vector.<String> - sound identifiers. Must be already registered with the sound proxy in order to work
		 * @param completeCallback Function - callback called when sound is complete
		 * @param priority int = 0 - the sound priority. If there is a sound with a higher priority already playing,
		 * 							this sound will not start if checkPriority is true
		 * @param volume int = 100 - the volume of the sound. Between 0 (mute) and 100 (full volume)
		 * @param loops int = 1 - the number of loops the sound will play
		 */
		public static function createQueuePlayerOnVoiceChannel(queueName:String, soundNames:Vector.<String>, completeCallback:Function,
															   	priority:int=0, volume:int=100, loops:int=1):SoundQueuePlayer
		{
			return createQueuePlayer(queueName, soundNames, GameConstants.CHANNEL_VOICE, completeCallback, priority, volume, loops);
		}

		/**
		 * Will create a new queue player with the specified parameters
		 * @param queueName String - queue name identifier.
		 * @param soundNames Vector.<String> - sound identifiers. Must be already registered with the sound proxy in order to work
		 * @param completeCallback Function - callback called when sound is complete
		 * @param priority int = 0 - the sound priority. If there is a sound with a higher priority already playing,
		 * 							this sound will not start if checkPriority is true
		 * @param volume int = 100 - the volume of the sound. Between 0 (mute) and 100 (full volume)
		 * @param loops int = 1 - the number of loops the sound will play
		 */
		public static function createQueuePlayerOnSWFChannel(queueName:String, soundNames:Vector.<String>, completeCallback:Function,
															 priority:int=0, volume:int=100, loops:int=1):SoundQueuePlayer
		{
			return createQueuePlayer(queueName, soundNames, GameConstants.CHANNEL_SFX, completeCallback, priority, volume, loops);
		}
		
		/**
		 * Will create a new queue player with the specified parameters
		 * @param queueName String - queue name identifier.
		 * @param soundNames Vector.<String> - sound identifiers. Must be already registered with the sound proxy in order to work
		 * @param completeCallback Function - callback called when sound is complete
		 * @param priority int = 0 - the sound priority. If there is a sound with a higher priority already playing,
		 * 							this sound will not start if checkPriority is true
		 * @param volume int = 100 - the volume of the sound. Between 0 (mute) and 100 (full volume)
		 * @param loops int = 1 - the number of loops the sound will play
		 */
		public static function createQueuePlayerOnAmbianceChannel(queueName:String, soundNames:Vector.<String>, completeCallback:Function,
																  	priority:int=0, volume:int=100, loops:int=1):SoundQueuePlayer
		{
			return createQueuePlayer(queueName, soundNames, GameConstants.CHANNEL_AMBIANCE, completeCallback, priority, volume, loops);
		}

		//==============================================================================================================
		// CHANNEL API
		//==============================================================================================================
		
		public static function channelIDToString(channelID:int):String
		{
			switch (channelID) 
			{
				case GameConstants.CHANNEL_VOICE: 
					return GameConstants.CHANNEL_VOICE_NAME;
				case GameConstants.CHANNEL_AMBIANCE:
					return GameConstants.CHANNEL_AMBIANCE_NAME;
				case GameConstants.CHANNEL_SFX: 
					return GameConstants.CHANNEL_SFX_NAME;
				case GameConstants.CHANNEL_PLAN_B: 
					return GameConstants.CHANNEL_PLAN_B_NAME;
				case GameConstants.CHANNEL_PLAN_C: 
					return GameConstants.CHANNEL_PLAN_C_NAME;
				default: 
					return channelID.toString();
			}
		}
	}
}