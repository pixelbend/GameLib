package com.pixelBender.model.component.sound
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.MathHelpers;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.model.vo.sound.CompleteSoundPropertiesVO;
	import com.pixelBender.model.vo.sound.PlaySoundPropertiesVO;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.pool.ObjectPoolManager;

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SoundPlayer implements IPauseResume
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const NAME														:String = "SoundPlayer";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
				
		/**
		 * Player state mask 
		 */		
		protected var state																:int;
		
		/**
		 * The current sound channel 
		 */		
		protected var channel															:SoundChannel;
		
		/**
		 * The playing sound 
		 */		
		protected var sound																:Sound;
		
		/**
		 * Reference to the current playing properties VO
		 */
		protected var currentPlayProperties												:PlaySoundPropertiesVO;

		/**
		 * Reference to the master volume
		 */
		protected var masterVolume														:Number;
		
		/**
		 * Callback invoked when the sound is complete or stopped. 
		 */		
		protected var completeCallback													:Function;
				
		/**
		 * Internal flag 
		 */		
		protected var pauseTime															:Number;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function SoundPlayer()
		{
			state = GameConstants.STATE_IDLE;
			this.currentPlayProperties = new PlaySoundPropertiesVO();
		}
		
		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Pauses the playing sound 
		 */		
		public function pause():void
		{
			if (!getIsPlaying())
			{
				return;
			}
			// Set state
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
			// Flash sometimes reports an invalid position value
			pauseTime = MathHelpers.clamp(this.getPosition(), 0, this.getLength() - 100);
			// Kill the channel. Will be restored on resume
			stopChannel();		
		}
		
		/**
		 * Resumes the playing sound 
		 */		
		public function resume():void
		{
			// Remove state
			if (getIsPaused())
			{
				state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
				startChannel(pauseTime);
				pauseTime = -1;
			}
		}
		
		/**
		 * Memory management 
		 */		
		public function dispose():void
		{
			stopChannel();
			if (currentPlayProperties)
			{
				currentPlayProperties.dispose();
				currentPlayProperties = null;
			}
			sound = null;
			completeCallback = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
			
		/**
		 * Start playing the given sound.
		 * @param sound Sound - the sound to play
		 * @param properties PlaySoundPropertiesVO - reference to the playing properties. Used in playing the sound
		 * @param masterVolume Number - the master volume for all sounds
		 * @param completeCallback Function - invoked when the sound is complete/stopped
		 */
		public function play(sound:Sound, properties:PlaySoundPropertiesVO, masterVolume:Number, completeCallback:Function):void
		{
			// Check state integrity
			AssertHelpers.assertCondition(!getIsPlaying(), "Already playing! Call stop first!");
			// Assign members
			this.sound = sound;
			this.completeCallback = completeCallback;
			this.currentPlayProperties.initializeFromVO(properties);
			this.masterVolume = masterVolume;
			// Start
			startChannel();
		}
		
		/**
		 * Stops the playing sound (if any)
		 */
		public function stop():void
		{
			if (getIsPlaying() || getIsPaused())
			{
				handleSoundComplete(null);
			}
		}

		/**
		 * Clear the sound player of all the members, making it ready for object pool release
		 */
		public function clear():void
		{
			state = GameConstants.STATE_IDLE;
			currentPlayProperties.clear();
			sound = null;
			channel = null;
			completeCallback = null;
		}
		
		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================
		
		public function getIsPlaying():Boolean
		{
			return BitMaskHelpers.isBitActive(state, GameConstants.STATE_PLAYING); 
		}
		
		public function getIsPaused():Boolean
		{
			return BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED);
		}
		
		public function getCurrentPlayingProperties():PlaySoundPropertiesVO
		{
			return currentPlayProperties;
		}
		
		public function getVolume():int
		{
			if (currentPlayProperties != null)
			{
				return masterVolume * currentPlayProperties.getVolume();
			}
			return 0;
		}
		
		public function setMasterVolume(value:Number):void
		{
			masterVolume = value;
			// Adjust sound channel also
			if (getIsPlaying())
			{
				channel.soundTransform = new SoundTransform(masterVolume * currentPlayProperties.getVolume() * 0.01, channel.soundTransform.pan);
			}
		}
		
		/**
		 * The sounds length in milliseconds 
		 * @return Number
		 */
		public function getLength():Number
		{
			if (sound != null)
			{
				return sound.length;
			}
			return -1;
		}
		
		/**
		 * The sounds position in milliseconds if it is playing or paused.
		 * It will return -1 otherwise 
		 * @return Number
		 */
		public function getPosition():Number
		{
			if (this.getIsPlaying())
			{
				return channel.position;
			}
			if ( BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED) )
			{
				return pauseTime;
			}
			return -1;
		}

		/**
		 * Retrieves the sound amplitude computed as the mean between the right/left channel amplitudes
		 * @return Number:
		 * 		- between 0 and 1 if sound is playing
		 * 		- NaN otherwise
		 */
		public function getAmplitude():Number
		{
			if (this.getIsPlaying())
			{
				return (channel.leftPeak + channel.rightPeak) * 0.5;
			}
			return Number.NaN;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[SoundPlayer state:" + state + " playProperties:" + currentPlayProperties + "]";
		}
		
		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================
		
		/**
		 * Sound complete handler
		 * @param event Event
		 */		
		protected function handleSoundComplete(event:Event=null):void
		{
			// Stop channel
			stopChannel();
			// Send callback
			invokeCallback(event == null);
		}
		
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Starts the channel from the specified position
		 * @param position - the position from which the sound will start from
		 */
		protected function startChannel(position:Number = 0):void
		{
			// Internals
			var aggregatedVolume:Number = masterVolume * currentPlayProperties.getVolume(),
				volume:Number = MathHelpers.clamp(aggregatedVolume * 0.01, 0, 1),
				loops:int = currentPlayProperties.getLoops();
			// Set state
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_PLAYING);
			// Start channel
			try
			{
				GameFacade.getInstance().sendNotification(GameConstants.SOUND_STARTED, currentPlayProperties);
				channel = sound.play(position, loops, new SoundTransform(volume));
				channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete, false, 0, true);
			}
			catch (error:Error)
			{
				handleSoundComplete(null);
			}
		}
		
		/**
		 * Stops the channel 
		 */
		protected function stopChannel():void
		{
			// State
			state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PLAYING);
			// Stop channel
			if (channel != null)
			{
				channel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
				channel.stop();
				channel = null;
			}
		}
		
		/**
		 * Will call the complete callback if any defined.
		 */		
		protected function invokeCallback(forced:Boolean):void
		{
			if (completeCallback != null)
			{
				// Internals
				var pool:ObjectPool = ObjectPoolManager.getInstance().retrievePool(CompleteSoundPropertiesVO.NAME),
					completeVO:CompleteSoundPropertiesVO = pool.allocate() as CompleteSoundPropertiesVO,
					callbackReference:Function = completeCallback;
				// Initialize VO
				completeVO.initializeVO(forced, false, currentPlayProperties.getSoundName(), currentPlayProperties.getChannelID(),
											currentPlayProperties.getCompleteCallback(), currentPlayProperties.getPriority(),
											currentPlayProperties.getVolume(), currentPlayProperties.getLoops());
				// Remove current properties
				currentPlayProperties.clear();
				completeCallback = null;
				// Invoke
				callbackReference(completeVO);
				GameFacade.getInstance().sendNotification(GameConstants.SOUND_COMPLETED, completeVO);
				// Release objects
				pool.release(completeVO);
			}
		}
	}
}