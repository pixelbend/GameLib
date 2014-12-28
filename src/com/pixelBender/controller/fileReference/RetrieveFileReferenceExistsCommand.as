package com.pixelBender.controller.fileReference
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.controller.fileReference.vo.FileReferenceExistsNotificationVO;
	import com.pixelBender.controller.fileReference.vo.FileReferenceNotificationVO;
	import com.pixelBender.model.FileReferenceProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RetrieveFileReferenceExistsCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Verifies if the file reference identified through the notification VO parameters exists
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			// Internals
			var fileReferenceProxy:FileReferenceProxy = facade.retrieveProxy(GameConstants.FILE_REFERENCE_PROXY_NAME) as FileReferenceProxy,
				note:FileReferenceExistsNotificationVO = notification.getBody() as FileReferenceExistsNotificationVO,
				fileExists:Boolean;
			// Execute
			fileExists = fileReferenceProxy.getFileReferenceExists(note.getGroupName(), note.getFileName());
			note.setFileExists(fileExists);
		}
	}
}
