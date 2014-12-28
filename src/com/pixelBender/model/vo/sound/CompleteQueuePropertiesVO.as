package com.pixelBender.model.vo.sound
{
	import com.pixelBender.pool.ObjectPool;
	import com.pixelBender.pool.ObjectPoolManager;

	public class CompleteQueuePropertiesVO extends PlayQueuePropertiesVO
	{

		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const NAME												:String = "CompleteQueuePropertiesVO";

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
		
		public function initializeVO(forced:Boolean, startAborted:Boolean, queueName:String, sounds:Vector.<String>,
									 	channelID:int, completeCallback:Function, priority:int=0, volume:int=100,
											loops:int=1):CompleteQueuePropertiesVO
		{
			this.forced = forced;
			this.startAborted = startAborted;
			super.initialize(queueName, sounds, channelID, completeCallback, priority, volume, loops);
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
			return "[CompleteQueuePropertiesVO queueName:" + queueName + " sounds:" + sounds + " channelID: " + channelID
						+ " forced:" + forced + " startAborted:" + startAborted + "]";
		}
	}
}