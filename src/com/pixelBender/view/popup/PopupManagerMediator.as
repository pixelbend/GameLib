package com.pixelBender.view.popup
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.facade.GameFacade;
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.helpers.MathHelpers;
	import com.pixelBender.helpers.MovieClipHelpers;
	import com.pixelBender.helpers.StarlingHelpers;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.model.vo.game.GameSizeVO;
	import com.pixelBender.model.vo.popup.PopupTranslucentLayerVO;
	import com.pixelBender.model.vo.note.popup.ShowPopupNotificationVO;
	import com.pixelBender.view.popup.vo.PopupHelpersResponseVO;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Sprite;

	public class PopupManagerMediator extends Mediator implements IPauseResume
	{
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The current popups on screen 
		 */		
		protected var currentPopups											:Vector.<PopupMediator>;
		
		/**
		 * The popup container 
		 */		
		protected var popupContainer										:flash.display.DisplayObjectContainer;

		/**
		 * The starling popup container
		 */
		protected var starlingPopupContainer								:starling.display.DisplayObjectContainer;
	
		/**
		 * Internal flag. If true, multiple popups can be stacked and only the last one will be visible. 
		 */		
		protected var stackPopups											:Boolean;

		/**
		 * Translucent layer properties VO
		 */		
		protected var translucentLayerVO									:PopupTranslucentLayerVO;
		
		/**
		 * The translucent layer view component sprite
		 */		
		protected var translucentLayerView									:Bitmap;

		/**
		 * The starling translucent layer view component sprite
		 */
		protected var starlingTranslucentLayerView							:Image;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function PopupManagerMediator(mediatorName:String)
		{
			super(mediatorName);
			currentPopups = new Vector.<PopupMediator>();
			translucentLayerVO = new PopupTranslucentLayerVO();
			createInitialTranslucentLayer();
		}
		
		//==============================================================================================================
		// IPauseResume IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Pauses the last popup in the stack 
		 */
		public function pause():void
		{
			if (currentPopups.length > 0)
			{
				currentPopups[currentPopups.length-1].pausePopup();
			}
		}
		
		/**
		 * Resumes the last popup in the stack 
		 */		
		public function resume():void
		{
			if (currentPopups.length > 0)
			{
				currentPopups[currentPopups.length-1].resumePopup();
			}
		}
		
		/**
		 * Memory management 
		 */		
		public function dispose():void
		{
			StarlingHelpers.removeFromParent(starlingTranslucentLayerView);
			starlingTranslucentLayerView = null;
			MovieClipHelpers.removeFromParent(translucentLayerView);
			translucentLayerView = null;

			currentPopups = null;
			popupContainer = null;
			starlingPopupContainer = null;
			translucentLayerVO = null;
		}
		
		//==============================================================================================================
		// IMediator IMPLEMENTATION
		//==============================================================================================================
		
		override public function listNotificationInterests():Array
		{
			return [
						GameConstants.OPEN_POPUP,
						GameConstants.CLOSE_POPUP,
						GameConstants.GET_STACK_POPUPS,
						GameConstants.SET_STACK_POPUPS,
						GameConstants.GET_POPUP_TRANSLUCENT_LAYER_PROPERTIES,
						GameConstants.SET_POPUP_TRANSLUCENT_LAYER_ENABLED,
						GameConstants.SET_POPUP_TRANSLUCENT_LAYER_ALPHA,
						GameConstants.SET_POPUP_TRANSLUCENT_LAYER_COLOR
					];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case GameConstants.OPEN_POPUP:
					handleShowPopup(notification.getBody() as ShowPopupNotificationVO);
					break;
				case GameConstants.CLOSE_POPUP:
					handleClosePopup(notification.getBody() as String);
					break;
				case GameConstants.GET_STACK_POPUPS:
					(notification.getBody() as PopupHelpersResponseVO).initialize(stackPopups);
					break;
				case GameConstants.SET_STACK_POPUPS:
					handleSetStackPopups(notification.getBody() as Boolean);
					break;
				case GameConstants.GET_POPUP_TRANSLUCENT_LAYER_PROPERTIES:
					(notification.getBody() as PopupHelpersResponseVO).initialize(translucentLayerVO.clone());
					break;
				case GameConstants.SET_POPUP_TRANSLUCENT_LAYER_ENABLED:
					handleSetTranslucentLayerEnabled(notification.getBody() as Boolean);
					break;
				case GameConstants.SET_POPUP_TRANSLUCENT_LAYER_ALPHA:
					handleSetTranslucentLayerAlpha(notification.getBody() as Number);
					break;
				case GameConstants.SET_POPUP_TRANSLUCENT_LAYER_COLOR:
					handleSetTranslucentLayerColor(notification.getBody() as int);
					break;
			}
		}

		//==============================================================================================================
		// GETTERS/SETTERS
		//==============================================================================================================

		public function setTranslucentLayerAlphaFromString(alphaString:String):void
		{
			var alpha:Number = parseFloat(alphaString);
			if (!isNaN(alpha))
			{
				handleSetTranslucentLayerAlpha(alpha);
			}
		}

		public function setTranslucentLayerColorFromString(colorString:String):void
		{
			var color:int = parseInt(colorString);
			handleSetTranslucentLayerColor(color);
		}

		public function setStackPopupsFromString(booleanString:String):void
		{
			handleSetStackPopups(booleanString == GameConstants.BOOLEAN_TRUE_STRING);
		}

		public function setTranslucentLayerEnabled(booleanString:String):void
		{
			handleSetTranslucentLayerEnabled(booleanString == GameConstants.BOOLEAN_TRUE_STRING);
		}
		
		public function setPopupContainers(container:flash.display.DisplayObjectContainer,
										   	starlingContainer:starling.display.DisplayObjectContainer):void
		{
			this.popupContainer = container;
			this.starlingPopupContainer = starlingContainer;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[PopupManagerMediator]";
		}
		
		//==============================================================================================================
		// HANDLERS
		//==============================================================================================================
		
		/**
		 * Show popup handler. Shows the popup, and according the other configurations (stack-able, translucentLayerVO properties), handles
		 * 	the other popups and translucent layer.
		 * @param vo ShowPopupNotificationVO
		 */		
		protected function handleShowPopup(vo:ShowPopupNotificationVO):void
		{
			// Internals
			var currentPopup:PopupMediator,
				popupToShow:PopupMediator = vo.getPopup(),
				index:int = currentPopups.indexOf(popupToShow);
			// Check if the popup to show is already in the list. If so, close it first.
			if (index >= 0)
			{
				popupToShow.closePopup();
				currentPopups.splice(index,1);
			}
			// Now check the way we will display the popup
			if (stackPopups)
			{
				for each (currentPopup in currentPopups)
				{
					currentPopup.setPopupVisible(false);
				}
			}
			else 
			{
				while (currentPopups.length > 0)
				{
					currentPopups.pop().closePopup();
				}
			}
			// Finally show the popup
			if (popupToShow is NormalDisplayPopup)
			{
				var normalDisplayPopup:NormalDisplayPopup = popupToShow as NormalDisplayPopup;
				normalDisplayPopup.preparePopupForOpen(popupContainer, vo.getAssetProxy());
				if (translucentLayerVO.getLayerEnabled())
				{
					popupContainer.addChildAt(translucentLayerView, 0);
				}
				normalDisplayPopup.openPopup();
			}
			else if (popupToShow is StarlingPopup)
			{
				var starlingPopup:StarlingPopup = popupToShow as StarlingPopup;
				starlingPopup.preparePopupForOpen(starlingPopupContainer, vo.getAssetProxy());
				if (translucentLayerVO.getLayerEnabled())
				{
					starlingPopupContainer.addChildAt(starlingTranslucentLayerView, 0);
				}
				starlingPopup.openPopup();
			}
			else
			{
				AssertHelpers.assertCondition(false, "Given popup MUST override NormalDisplayPopup or StarlingPopup");
			}
			currentPopups.push(popupToShow);
		}		
		
		/**
		 * Popup close handler
		 * @param popupName String
		 */		
		protected function handleClosePopup(popupName:String):void
		{
			// Internals
			var i:int,
				len:int = currentPopups.length,
				removeTranslucentLayer:Boolean = false,
				translucentLayerEnabled:Boolean = translucentLayerVO.getLayerEnabled();
			// Parse
			for (i=len-1; i>-1; i++)
			{
				if (currentPopups[i].getMediatorName() == popupName)
				{
					// Found.
					currentPopups[i].closePopup();
					// No more popups, no more translucent layer
					removeTranslucentLayer = (len <= 1);
					// If the popup that is just closing is the last in the list and there 
					// 	are others stacked behind him, activate the previous popup in list
					if (stackPopups && !removeTranslucentLayer && (i == len-1))
					{
						currentPopups[len-2].setPopupVisible(true);
					}
					else if (translucentLayerEnabled && removeTranslucentLayer) // Remove translucent layer if need be
					{
						MovieClipHelpers.removeFromParent(translucentLayerView);
						starlingTranslucentLayerView.removeFromParent();
					}
					// Remove popup from list
					currentPopups.splice(i,1);
					break;
				}
			}
		}

		/**
		 * Changes the stack behavior
		 * @param stackPopups Boolean
		 */
		protected function handleSetStackPopups(stackPopups:Boolean):void
		{
			this.stackPopups = stackPopups;
		}

		/**
		 * Changes the translucent layer enabled
		 * @param enabled Boolean
		 */
		protected function handleSetTranslucentLayerEnabled(enabled:Boolean):void
		{
			translucentLayerVO.setLayerEnabled(enabled);
		}

		/**
		 * Updates the translucent layer alpha property
		 * @param alpha Number
		 */
		protected function handleSetTranslucentLayerAlpha(alpha:Number):void
		{
			alpha = MathHelpers.clamp(alpha, 0, 1);
			if (translucentLayerVO.getLayerAlpha() != alpha)
			{
				translucentLayerVO.setLayerAlpha(alpha);
				updateTranslucentLayerAlpha();
			}
		}

		/**
		 * Updates the translucent layer color property
		 * @param color int
		 */
		protected function handleSetTranslucentLayerColor(color:int):void
		{
			color = MathHelpers.clamp(color, 0x000000, 0xFFFFFF);
			if (translucentLayerVO.getLayerColor() != color)
			{
				translucentLayerVO.setLayerColor(color);
				updateTranslucentLayerColor();
			}
		}

		//==============================================================================================================
		// LOCALS
		//==============================================================================================================

		/**
		 * Creates the initial translucent layers
		 */
		protected function createInitialTranslucentLayer():void
		{
			var gameSize:GameSizeVO = GameFacade(facade).getApplicationSize(),
				bitmapData:BitmapData = new BitmapData(100, 100, false, 0xFFFFFF),
				width:int = gameSize.getWidth(),
				height:int = gameSize.getHeight(),
				scaleX:Number = width/bitmapData.width,
				scaleY:Number = height/bitmapData.height;
			// Draw normal graphics
			translucentLayerView = new Bitmap(bitmapData);
			translucentLayerView.scaleX = scaleX;
			translucentLayerView.scaleY = scaleY;
			// Draw starling graphics
			starlingTranslucentLayerView = Image.fromBitmap(new Bitmap(bitmapData), false);
			starlingTranslucentLayerView.scaleX = scaleX;
			starlingTranslucentLayerView.scaleY = scaleY;
			// Update
			updateTranslucentLayerColor();
			updateTranslucentLayerAlpha();
		}

		/**
		 * Will redraw the translucent layer according to the new color.
		 */		
		protected function updateTranslucentLayerColor():void
		{
			translucentLayerView.bitmapData.fillRect(new Rectangle(0, 0, translucentLayerView.bitmapData.width,
														translucentLayerView.bitmapData.height), translucentLayerVO.getLayerColor());
			starlingTranslucentLayerView.color = translucentLayerVO.getLayerColor();
		}

		/**
		 * Updates the alpha of the translucent layer views
		 */
		protected function updateTranslucentLayerAlpha():void
		{
			translucentLayerView.alpha = translucentLayerVO.getLayerAlpha();
			starlingTranslucentLayerView.alpha = translucentLayerVO.getLayerAlpha();
		}
	}
}