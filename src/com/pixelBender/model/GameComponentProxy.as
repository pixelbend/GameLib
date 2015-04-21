package com.pixelBender.model
{
	import com.pixelBender.helpers.DictionaryHelpers;
	import com.pixelBender.helpers.IDisposeHelpers;
	import com.pixelBender.helpers.IPauseResumeHelpers;
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.interfaces.IPauseResume;
	import com.pixelBender.model.vo.ScreenTransitionSequenceVO;
	import com.pixelBender.view.gameScreen.GameScreenMediator;
	import com.pixelBender.view.popup.PopupMediator;
	import com.pixelBender.view.transition.TransitionView;
	import flash.utils.Dictionary;
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class GameComponentProxy extends Proxy implements IDispose
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * All the game components 
		 */		
		protected var allComponents																:Dictionary;
		
		/**
		 * Just the components that boast the IPauseResume implementation 
		 */		
		protected var pauseResumeComponents														:Vector.<IPauseResume>;
		
		/**
		 * The list of game screens 
		 */		
		protected var gameScreens																:Dictionary;
		
		/**
		 * The list of all transition sequences 
		 */		
		protected var transitionSequences														:Dictionary;
		
		/**
		 * The list of all transitions 
		 */		
		protected var transitions																:Dictionary;
		
		/**
		 * For the transitions that need lazy initialization, these are their init VOs in dictionary form. 
		 */		
		protected var transitionInitVOs															:Dictionary;
		
		/**
		 * The list of all known popups 
		 */		
		protected var popups																	:Dictionary;

		/**
		 * List with all asset VO qualified class names
		 */
		protected var knownAssetClasses															:Dictionary;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		public function GameComponentProxy(proxyName:String):void
		{
			super(proxyName);
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * All the game components created 
		 * @param componentDictionary Dictionary
		 */		
		public function setGameComponents(componentDictionary:Dictionary):void
		{
			var componentVO:Object;
			allComponents = componentDictionary;
			pauseResumeComponents = new Vector.<IPauseResume>();
			for each (componentVO in allComponents) 
			{
				if (componentVO is IPauseResume)
				{
					pauseResumeComponents.push(componentVO);
				}
			}
		}
		
		/**
		 * All the game screens in dictionary form
		 * @param gameScreens Dictionary
		 */		
		public function setGameScreens(gameScreens:Dictionary):void
		{
			this.gameScreens = gameScreens;
		}
		
		/**
		 * Retrieve all game screens
		 * @return Dictionary 
		 */		
		public function getGameScreens():Dictionary
		{
			return gameScreens;
		}

		/**
		 * Retrieve a certain asset qualified class name
		 * @param assetType String
		 * @return String
		 */
		public function getAssetQualifiedClassName(assetType:String):String
		{
			return knownAssetClasses[assetType];
		}

		/**
		 * Setter for the knownAssetClasses member
		 * @param knownAssetClasses Dictionary
		 */
		public function setKnownAssetVOClasses(knownAssetClasses:Dictionary):void
		{
			this.knownAssetClasses = knownAssetClasses;
		}
		
		/**
		 * Retrieves game screen by name
		 * @param gameScreenName String
		 * @return GameScreenMediator
		 */		
		public function getGameScreen(gameScreenName:String):GameScreenMediator
		{
			return gameScreens[gameScreenName];
		}
		
		/**
		 * All the transition sequences in dictionary form
		 * @param transitionSequences Dictionary
		 */		
		public function setTransitionSequences(transitionSequences:Dictionary):void
		{
			this.transitionSequences = transitionSequences;
		}
		
		/**
		 * Retrieves a screen transition sequence by name
		 * @param transitionSequenceName String
		 * @return ScreenTransitionSequenceVO
		 */		
		public function getScreenTransitionSequence(transitionSequenceName:String):ScreenTransitionSequenceVO
		{
			return transitionSequences[transitionSequenceName];
		}
		
		/**
		 * All the transitions in dictionary form
		 * @param transitions Dictionary
		 */	
		public function setTransitions(transitions:Dictionary):void
		{
			this.transitions = transitions;
		}
		
		/**
		 * Retrieves a transition view by name
		 * @param transitionName String
		 * @return TransitionView
		 */		
		public function getTransition(transitionName:String):TransitionView
		{
			return transitions[transitionName];
		}
		
		/**
		 * All the transition view init VOs in dictionary form 
		 * @param initVOs Dictionary
		 */		
		public function setTransitionInitVOs(initVOs:Dictionary):void
		{
			this.transitionInitVOs = initVOs;
		}
		
		/**
		 * Retrieves all transition init VOs
		 * @return Dictionary 
		 */		
		public function getTransitionInitVOs():Dictionary
		{
			return transitionInitVOs;
		}
		
		/**
		 * All the popups in dictionary form
		 * @param popups Dictionary
		 */	
		public function setPopups(popups:Dictionary):void
		{
			this.popups = popups;
		}
		
		/**
		 * Retrieves a popup mediator by name
		 * @param popupName String
		 * @return PopupMediator
		 */		
		public function getPopup(popupName:String):PopupMediator
		{
			return popups[popupName];
		}
		
		/**
		 * Pauses all IPauseResume game components 
		 */		
		public function pauseComponents():void
		{
			IPauseResumeHelpers.pause(pauseResumeComponents);
		}
		
		/**
		 * Resumes all IPauseResume game components 
		 */
		public function resumeComponents():void
		{
			IPauseResumeHelpers.resume(pauseResumeComponents);
		}
		
		/**
		 * Disposes all game components 
		 */
		public function disposeComponents():void
		{
			// Remove 
			var component:Object,
				gameScreen:GameScreenMediator,
				popup:PopupMediator,
				facadeReference:IFacade = facade;
			// Popups
			if(popups != null)
			{
				for each (popup in popups)
				{
					facade.removeMediator(popup.getMediatorName());
					popup.disposePopup();
				}
			}
			// Game screens
			if (gameScreens != null)
			{
				for each (gameScreen in gameScreens)
				{
					facade.removeMediator(gameScreen.getMediatorName());
					gameScreen.disposeScreen();
				}
			}
			// Core game components
			if (allComponents != null)
			{
				for each (component in allComponents)
				{
					if (component == this)
					{
						// Since THIS is also a game component, dispose it last.
						continue;
					}
					if (component is IProxy)
					{
						facadeReference.removeProxy(IProxy(component).getProxyName());
					}
					if (component is IMediator)
					{
						facadeReference.removeMediator(IMediator(component).getMediatorName());
					}
					IDisposeHelpers.dispose(component);
				}
			}
			// Transition sequences
			IDisposeHelpers.dispose(transitionSequences);
			// Transitions
			IDisposeHelpers.dispose(transitions);
			// Good bye cruel world!
			this.dispose();
		}
		
		//==============================================================================================================
		// IDispose IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Memory management 
		 */		
		public function dispose():void
		{
			DictionaryHelpers.deleteValues(allComponents);
			DictionaryHelpers.deleteValues(gameScreens);
			DictionaryHelpers.deleteValues(popups);
			DictionaryHelpers.deleteValues(transitionSequences);
			DictionaryHelpers.deleteValues(transitions);
			DictionaryHelpers.deleteValues(transitionInitVOs);
			DictionaryHelpers.deleteValues(knownAssetClasses);

			allComponents = null;
			gameScreens = null;
			popups = null;
			transitionSequences = null;
			transitions = null;
			transitionInitVOs = null;
			knownAssetClasses = null;
			pauseResumeComponents = null;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[GameComponentProxy]";
		}
	}
}