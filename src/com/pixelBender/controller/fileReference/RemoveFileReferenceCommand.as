package com.pixelBender.controller.fileReference
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.controller.fileReference.vo.FileReferenceNotificationVO;
	import com.pixelBender.model.FileReferenceProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RemoveFileReferenceCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Removes the file reference identified by the notification VO parameters
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			// Internals
			var fileReferenceProxy:FileReferenceProxy = facade.retrieveProxy(GameConstants.FILE_REFERENCE_PROXY_NAME) as FileReferenceProxy,
				note:FileReferenceNotificationVO = notification.getBody() as FileReferenceNotificationVO;
			// Execute
			fileReferenceProxy.removeFileReference(note.getGroupName(), note.getFileName());
		}
	}
}
