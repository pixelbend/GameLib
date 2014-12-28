package com.pixelBender.controller.tween
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.TweenProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class RemoveTweenCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Removes a playing tween
		 * @param notification INotification
		 */		
		override public function execute(notification:INotification):void
		{
			// Internals
			var tweenProxy:TweenProxy = facade.retrieveProxy(GameConstants.TWEEN_PROXY) as TweenProxy,
				tweenID:int = notification.getBody() as int;
			// Execute
			tweenProxy.removeTweenByID(tweenID); 
		}
	}
}