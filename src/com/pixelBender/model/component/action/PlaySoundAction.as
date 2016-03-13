package com.pixelBender.model.component.action
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.BitMaskHelpers;
	import com.pixelBender.helpers.SoundHelpers;
	import com.pixelBender.model.vo.action.PlaySoundActionVO;
	import com.pixelBender.model.vo.sound.CompleteSoundPropertiesVO;

	public class PlaySoundAction extends BaseAction
	{
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================

		public static const NAME												:String = "PlaySoundAction";

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

		public function initialize(playSoundActionVO:PlaySoundActionVO):void
		{
			ID = playSoundActionVO.getID();
			soundName = playSoundActionVO.getSoundName();
			channelID = playSoundActionVO.getChannelID();
			volume = playSoundActionVO.getVolume();
			priority = playSoundActionVO.getPriority();
			loops = playSoundActionVO.getLoops();
			state = GameConstants.STATE_IDLE;
		}

		//==============================================================================================================
		// IAction IMPLEMENTATION
		//==============================================================================================================

		public override function getType():int
		{
			return GameConstants.ACTION_TYPE_PLAY_SOUND;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[PlaySoundAction ID:" + ID + "state:" + state + " soundName:" + soundName + "channelID:" +
					channelID + "volume:" + volume + "priority:" + priority + "loops:" + loops + "]";
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		/**
		 * Starts the play sound action
		 */
		protected override function startAction():void
		{
			SoundHelpers.playSound(soundName, channelID, handleSoundComplete, priority, volume, loops);
		}

		/**
		 * Pauses the current playing sound
		 */
		protected override function pauseAction():void
		{
			SoundHelpers.pauseSoundOnChannel(channelID);
		}

		/**
		 * Resumes the current playing sound
		 */
		protected override function resumeAction():void
		{
			SoundHelpers.resumeSoundOnChannel(channelID);
		}

		/**
		 * Stops the current action
		 */
		protected override function stopAction():void
		{
			SoundHelpers.stopSoundOnChannel(channelID);
		}

		/**
		 * Memory management
		 */
		protected override function disposeAction():void
		{
			soundName = null;
		}

		/**
		 * Sound complete handler
		 * @param vo CompleteSoundPropertiesVO
		 */
		protected function handleSoundComplete(vo:CompleteSoundPropertiesVO):void
		{
			if (!BitMaskHelpers.isBitActive(state, GameConstants.STATE_STARTED))
				return;

			state = GameConstants.STATE_IDLE;
			var forced:Boolean = vo.getForced() || vo.getStartAborted();
			invokeCompleteCallback(forced);
		}
	}
}
