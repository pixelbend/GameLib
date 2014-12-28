package com.pixelBender.model.vo.sound
{
	public class PlayQueuePropertiesVO extends BaseSoundPlayCompletePropertiesVO
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const NAME												:String = "PlayQueuePropertiesVO";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Queue name identifier. 
		 */				
		protected var queueName													:String;
		
		/**
		 * The sounds that will be played through the queue in vector form.
		 */
		protected var sounds													:Vector.<String>;
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		public function initialize(queueName:String, sounds:Vector.<String>, channelID:int, completeCallback:Function,
											  	priority:int=0, volume:int=100, loops:int=1):PlayQueuePropertiesVO
		{
			super.initializeBase(channelID, completeCallback, priority, volume, loops);
			this.queueName = queueName;
			this.sounds = sounds;
			return this;
		}
		
		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		override public function dispose():void
		{
			super.dispose();
			queueName = null;
			sounds = null;
		}

		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================
		
		public function getQueueName():String
		{
			return queueName;
		}
		
		
		public function getSounds():Vector.<String>
		{
			return sounds;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public override function toString():String
		{
			return "[PlayQueuePropertiesVO queueName:" + queueName + " sounds:" + sounds + " channelID: " + channelID
							+ " priority:" + priority + " volume:" + volume + " loops:" + loops + "]";
		}
	}
}