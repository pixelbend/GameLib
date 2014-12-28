package com.pixelBender.facade
{
	import org.puremvc.as3.interfaces.INotification;

	public class GameNotification implements INotification
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================

		public static const NAME						:String = "GameNotification";

		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================

		protected var notificationName					:String;
		protected var notificationBody					:Object;
		protected var notificationType					:String;

		//==============================================================================================================
		// API
		//==============================================================================================================

		public function initialize(notificationName:String, notificationBody:Object = null,
								   	notificationType:String = null):void
		{
			this.notificationName = notificationName;
			this.notificationBody = notificationBody;
			this.notificationType = notificationType;
		}

		//==============================================================================================================
		// INotification IMPLEMENTATION
		//==============================================================================================================

		public function getName():String
		{
			return notificationName;
		}

		public function setBody(body:Object):void
		{
			notificationBody = body;
		}

		public function getBody():Object
		{
			return notificationBody;
		}

		public function setType(noteType:String):void
		{
			notificationType = noteType;
		}

		public function getType():String
		{
			return notificationType;
		}

		public function toString():String
		{
			return "[GameNotification name:" + getName() +
					" body:" + (( notificationBody == null ) ? "null" : notificationBody) +
					" type:" + (( notificationType == null ) ? "null" : notificationType);
		}
	}
}
