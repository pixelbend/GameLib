package com.pixelBender.model.vo.sound
{
	import com.pixelBender.model.component.sound.SoundPlayer;

	public class RetrieveCurrentPlayingSoundVO
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const NAME										:String = "RetrieveCurrentPlayingSoundVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		/**
		 * Sound channel identifier
		 */
		private var channelID												:int;

		/**
		 * Sound player
		 */
		private var player													:SoundPlayer;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(channelID:int):void
		{
			this.channelID = channelID;
			this.player = null;
		}

		public function clear():void
		{
			player = null;
		}

		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================

		public function getChannelID():int
		{
			return channelID;
		}

		public function getPlayer():SoundPlayer
		{
			return player;
		}

		public function setPlayer(value:SoundPlayer):void
		{
			player = value;
		}
	}
}
