package com.pixelBender.model.vo.sound
{
	public class PlaySoundPropertiesVO extends BaseSoundPlayCompletePropertiesVO
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const NAME												:String = "PlaySoundPropertiesVO";
	
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Sound identifier. Used to reference from the library. 
		 */				
		protected var soundName													:String;
		
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function initialize(soundName:String, channelID:int, completeCallback:Function, priority:int = 0,
								   	volume:int = 100, loops:int = 1):PlaySoundPropertiesVO
		{
			this.soundName = soundName;
			super.initializeBase(channelID, completeCallback, priority, volume, loops);
			return this;
		}

		public function initializeFromVO(vo:PlaySoundPropertiesVO):void
		{
			this.soundName = vo.soundName;
			this.channelID = vo.channelID;
			this.completeCallback = vo.completeCallback;
			this.priority = vo.priority;
			this.volume = vo.volume;
			this.loops = vo.loops;
		}

		public function clear():void
		{
			this.soundName = null;
			this.channelID = -1;
			this.completeCallback = null;
			this.priority = -1;
			this.volume = -1;
			this.loops = -1;
		}
		
		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		override public function dispose():void
		{
			super.dispose();
			soundName = null;
		}

		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================
		
		public function getSoundName():String
		{
			return soundName;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public override function toString():String
		{
			return "[PlaySoundPropertiesVO soundName:" + soundName + " channelID: " + channelID +
							" priority:" + priority + " volume:" + volume + " loops:" + loops + "]";
		}
	}
}