package com.pixelBender.controller.fileReference
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.controller.fileReference.vo.FileReferenceNotificationVO;
	import com.pixelBender.controller.fileReference.vo.RetrieveFileReferenceContentNotificationVO;
	import com.pixelBender.model.FileReferenceProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RetrieveFileReferenceContentCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Retrieves the content for the file reference identified through the notification VO parameters
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			// Internals
			var fileReferenceProxy:FileReferenceProxy = facade.retrieveProxy(GameConstants.FILE_REFERENCE_PROXY_NAME) as FileReferenceProxy,
				note:RetrieveFileReferenceContentNotificationVO = notification.getBody() as RetrieveFileReferenceContentNotificationVO,
				content:Object;
			// Execute
			content = fileReferenceProxy.getFileReferenceContent(note.getGroupName(), note.getFileName());
			note.setFileContents(content);
		}
	}
}
