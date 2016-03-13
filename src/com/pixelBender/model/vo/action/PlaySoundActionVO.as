package com.pixelBender.model.vo.action
{
	import com.pixelBender.constants.GameConstants;

	public class PlaySoundActionVO extends ActionVO
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static const	NAME												:String = "PlaySoundActionVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Sound identifier. Used to reference from the library.
		 */
		protected var soundName													:String;

		/**
		 * The channel where to play the sound
		 */
		protected var channelID													:int;

		/**
		 * The sound volume. Can take values from 0 to 100
		 */
		protected var volume													:int;

		/**
		 * The sound priority. Used to override other playing sounds on the same channel
		 */
		protected var priority													:int;

		/**
		 * The number of loops the sound should play before it is considered complete
		 */
		protected var loops														:int;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(ID:String, soundName:String, channelID:int, volume:int, priority:int, loops:int):void
		{
			initializeBaseAction(GameConstants.ACTION_TYPE_PLAY_SOUND, ID);

			this.soundName = soundName;
			this.channelID = channelID;
			this.volume = volume;
			this.priority = priority;
			this.loops = loops;
		}

		public override function dispose():void
		{
			soundName = null;

			super.dispose();
		}

		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================

		public function getSoundName():String
		{
			return soundName;
		}

		public function getChannelID():int
		{
			return channelID;
		}

		public function getVolume():int
		{
			return volume;
		}

		public function getPriority():int
		{
			return priority;
		}

		public function getLoops():int
		{
			return loops;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[PlaySoundActionVO soundName: " + soundName + " channelID: " + channelID + " priority:" + priority +
						" volume:" + volume + " loops:" + loops + "]";
		}
	}
}
