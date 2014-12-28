package com.pixelBender.model.vo.sound
{
	public class CompleteSoundPropertiesVO extends PlaySoundPropertiesVO
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		public static const NAME												:String = "CompleteSoundPropertiesVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Complete forced flag 
		 */				
		protected var forced													:Boolean;
		
		/**
		 * Flag. Set when the sound couldn't even be started due to lack of permission by the SoundPlayer.
		 */
		protected var startAborted												:Boolean;

		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function initializeVO(forced:Boolean, startAborted:Boolean, soundName:String, channelID:int,
									 	completeCallback:Function, priority:int=0, volume:int=100,
											loops:int=1):CompleteSoundPropertiesVO
		{
			this.forced = forced;
			this.startAborted = startAborted;
			initialize(soundName, channelID, completeCallback, priority, volume, loops);
			return this;
		}

		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================
		
		public function getForced():Boolean
		{
			return forced;
		}
		
		public function getStartAborted():Boolean
		{
			return startAborted;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public override function toString():String
		{
			return "[CompleteSoundPropertiesVO soundName:" + soundName + " channelID: " + channelID +
						" priority:" + priority + " volume:" + volume + " loops:" + loops + " forced:" + forced +
						" startAborted:" + startAborted + "]";
		}
	}
}