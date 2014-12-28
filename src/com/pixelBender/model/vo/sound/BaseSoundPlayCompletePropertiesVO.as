package com.pixelBender.model.vo.sound
{
	import com.pixelBender.interfaces.IDispose;

	/**
	 * Base PlayPropertiesVO class. Any play/complete properties VO used in the SoundProxy will extend this class.
	 */
	public class BaseSoundPlayCompletePropertiesVO implements IDispose
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The channel where to play the sound 
		 */		
		protected var channelID													:int;
		
		/**
		 * The sound volume. Can take values from 0 to 100. 
		 */		
		protected var volume													:int;
		
		/**
		 * The sound priority. Used to override  
		 */		
		protected var priority													:int;
		
		/**
		 * The number of loops the sound should play before it is considered complete 
		 */		
		protected var loops														:int;
				
		/**
		 * The complete callback invoked. 
		 * The callback takes 2 parameters:
		 * 	1 - the PlaySoundPropertiesVO given to start the sound
		 *  2 - forced:Boolean - if the sound completed simply or it was forced
		 */
		protected var completeCallback											:Function;
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function initializeBase(channelID:int, completeCallback:Function, priority:int = 0, volume:int = 100,
									   	loops:int = 1):BaseSoundPlayCompletePropertiesVO
		{
			this.channelID = channelID;
			this.volume = volume;
			this.priority = priority;
			this.loops = loops;
			this.completeCallback = completeCallback;
			return this;
		}
		
		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Proper memory management
		 */
		public function dispose():void
		{
			completeCallback = null;
		}

		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================
		
		public function getChannelID():int
		{
			return channelID;
		}
		
		public function getCompleteCallback():Function
		{
			return completeCallback;
		}
		
		public function getVolume():int
		{
			return volume;
		}
		
		public function setVolume(volume:int):void
		{
			this.volume = volume;
		}
		
		public function getPriority():int
		{
			return priority;
		}
		
		public function setPriority(priority:int):void
		{
			this.priority = priority;
		}
		
		public function getLoops():int
		{
			return loops;
		}
		
		public function setLoops(loops:int):void
		{
			this.loops = loops;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[PlaySoundPropertiesVO channelID: " + channelID + " priority:" + priority +
						" volume:" + volume + " loops:" + loops + "]";
		}
	}
}