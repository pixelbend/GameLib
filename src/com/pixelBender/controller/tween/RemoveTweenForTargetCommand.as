package com.pixelBender.controller.tween
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.TweenProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RemoveTweenForTargetCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Removes all tweens for the given target
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			// Internals
			var tweenProxy:TweenProxy = facade.retrieveProxy(GameConstants.TWEEN_PROXY) as TweenProxy,
				tweenTarget:Object = notification.getBody();
			// Execute
			tweenProxy.removeTweenForTarget(tweenTarget);
		}
	}
}
