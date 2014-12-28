package com.pixelBender.controller.tween
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.model.TweenProxy;
	import com.pixelBender.model.vo.note.tween.AddTweenNotificationVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class AddTweenCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================
		
		/**
		 * Starts a tween
		 * @param notification INotification
		 */		
		override public function execute(notification:INotification):void
		{
			// Internals
			var tweenProxy:TweenProxy = facade.retrieveProxy(GameConstants.TWEEN_PROXY) as TweenProxy,
				noteVO:AddTweenNotificationVO = notification.getBody() as AddTweenNotificationVO,
				createdTweenID:int;
			// Execute
			createdTweenID = tweenProxy.createAndAddTween(noteVO.getTarget(), noteVO.getDuration(),
															noteVO.getProperties(), noteVO.getCompleteCallback(),
															noteVO.getEaseFunction(), noteVO.getStartDelay()); 
			noteVO.setTweenID(createdTweenID); 
		}
	}
}