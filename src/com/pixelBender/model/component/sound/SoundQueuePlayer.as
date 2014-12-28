package com.pixelBender.model.component.sound
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.model.vo.sound.CompleteQueuePropertiesVO;
	import com.pixelBender.model.vo.sound.CompleteSoundPropertiesVO;
	import com.pixelBender.model.vo.sound.PlayQueuePropertiesVO;
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.pool.ObjectPoolManager;

	public class SoundQueuePlayer implements IPauseResume
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Player state mask 
		 */		
		protected var state																:int;
		
		/**
		 * Queue name
		 */
		protected var name																:String;
		
		/**
		 * The sound names, that will be played in order
		 */
		protected var soundNames														:Vector.<String>;
		
		/**
		 * Queue playing properties
		 */
		protected var playingProperties													:PlayQueuePropertiesVO;
		
		/**
		 * Queue index
		 */
		protected var index																:int;
				
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================

		/**
		 * Constructor
		 * @param playProperties PlayQueuePropertiesVO
		 */
		public function SoundQueuePlayer(playProperties:PlayQueuePropertiesVO)
		{
			// Internals
			var queueName:String = playProperties.getQueueName(),
				sounds:Vector.<String> = playProperties.getSounds();
			// Data integrity check
			AssertHelpers.assertCondition((queueName != null && queueName.length > 0), "The sound queue name cannot be null or empty");
			AssertHelpers.assertCondition((sounds != null && sounds.length > 0), this + " the sound names array cannot be null or empty");
			// Assign members
			this.name = queueName;
			this.soundNames = sounds;
			this.playingProperties = playProperties;
			this.state = GameConstants.STATE_IDLE;
			this.index = 0;
		}
		
		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Pauses the queue by pausing the current playing sound
		 */
		public function pause():void
		{
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_PLAYING)) 
			{
				state = BitMaskHelpers.addBit(state, GameConstants.STATE_PAUSED);
				SoundHelpers.pauseSoundOnChannel(playingProperties.getChannelID());
			}
		}
		
		/**
		 * Resumes the queue by resuming the current playing sound
		 */
		public function resume():void
		{
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_PAUSED)) 
			{
				state = BitMaskHelpers.removeBit(state, GameConstants.STATE_PAUSED);
				SoundHelpers.resumeSoundOnChannel(playingProperties.getChannelID());
			}
		}
		
		/**
		 * Proper memory management
		 */
		public function dispose():void
		{
			if (playingProperties != null)
			{
				playingProperties.dispose();
				playingProperties = null;
			}
			name = null;
			soundNames = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Plays the queue
		 */
		public function play():void
		{
			// Assert state
			AssertHelpers.assertCondition(!BitMaskHelpers.isBitActive(state, GameConstants.STATE_PLAYING),
											this + " cannot start an already started queue!");
			// Update state
			index = 0;
			state = BitMaskHelpers.addBit(state, GameConstants.STATE_PLAYING);
			// Start playing
			SoundHelpers.playSound(soundNames[index], playingProperties.getChannelID(), handleSoundComplete,
										playingProperties.getPriority(), playingProperties.getVolume(), 1);
		}
		
		/**
		 * Stops the queue
		 */
		public function stop():void
		{
			// Check proper state
			if (BitMaskHelpers.isBitActive(state, GameConstants.STATE_PLAYING))
			{
				state = GameConstants.STATE_IDLE;
				SoundHelpers.stopSoundOnChannel(playingProperties.getChannelID());
			}
		}
		
		/**
		 * Debug info
		 */
		public function toString():String
		{
			return "[SoundQueuePlayer queueName:" + name + " state:" + state + " soundNames:" +
						soundNames + " playProperties:" + playingProperties + "]";
		}
		
		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================
		
		/**
		 * Sound complete handler. Will move to next position in the queue and call complete, or stop it if the
		 * 	sound was forcibly stopped.
		 * @param completeVO CompleteSoundPropertiesVO
		 */
		protected function handleSoundComplete(completeVO:CompleteSoundPropertiesVO):void
		{
			// Check stopped by force
			if (completeVO.getStartAborted() || completeVO.getForced())
			{
				// Queue stopped by force
				handleQueueEnded(true, completeVO.getStartAborted());
				return;
			}
			// Advance index
			++index;
			// Check end
			if (index >= soundNames.length)
			{
				// Queue complete
				handleQueueEnded(false, false);
				return;
			}
			// Play next sound
			SoundHelpers.playSound(soundNames[index], playingProperties.getChannelID(), handleSoundComplete,
									playingProperties.getPriority(), playingProperties.getVolume(),
										playingProperties.getLoops());
		}

		/**
		 * Queue ended handler
		 * @param forced Boolean
		 * @param startAborted Boolean
		 */
		protected function handleQueueEnded(forced:Boolean, startAborted:Boolean):void
		{
			// Internals
			var completeCallback:Function = playingProperties.getCompleteCallback();
			// Reset members
			state = GameConstants.STATE_IDLE;
			index = 0;
			// Invoke callback if need be
			if (completeCallback != null)
			{
				var pool:ObjectPool = ObjectPoolManager.getInstance().retrievePool(CompleteQueuePropertiesVO.NAME),
					completeVO:CompleteQueuePropertiesVO = pool.allocate() as CompleteQueuePropertiesVO;
				completeVO.initializeVO(forced, startAborted, playingProperties.getQueueName(), playingProperties.getSounds().concat(),
											playingProperties.getChannelID(), playingProperties.getCompleteCallback(),
											playingProperties.getPriority(), playingProperties.getVolume(), playingProperties.getLoops());
				completeCallback(completeVO);
				pool.release(completeVO);
			}
		}
	}
}