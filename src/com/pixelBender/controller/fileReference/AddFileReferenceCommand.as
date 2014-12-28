package com.pixelBender.controller.fileReference
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.controller.fileReference.vo.AddFileReferenceNotificationVO;
	import com.pixelBender.model.FileReferenceProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class AddFileReferenceCommand extends SimpleCommand
	{
		//==============================================================================================================
		// EXECUTE
		//==============================================================================================================

		/**
		 * Adds a new file reference
		 * @param notification INotification
		 */
		override public function execute(notification:INotification):void
		{
			// Internals
			var assetFileReferenceProxy:FileReferenceProxy = facade.retrieveProxy(GameConstants.FILE_REFERENCE_PROXY_NAME) as FileReferenceProxy,
				note:AddFileReferenceNotificationVO = notification.getBody() as AddFileReferenceNotificationVO,
				success:Boolean;
			// Execute
			success = assetFileReferenceProxy.addFileReference(note.getGroupName(), note.getFileName(), note.getContentToSave(),
																		note.getFileType(), note.getOriginalContent());
			note.setSuccess(success);
		}
	}
}
