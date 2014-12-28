package com.pixelBender.controller.game.vo
{
	import flash.display.DisplayObjectContainer;

	import starling.display.DisplayObjectContainer;

	public class InitGameCommandVO
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Embedded library logic XML.
		 */		
		private var defaultLogicXML												:XML;
		
		/**
		 * Custom logic XML which can keep custom classes for game components 
		 */		
		private var gameLogicXML												:XML;
		
		/**
		 * The initial global game assets XML 
		 */		
		private var gameAssetsXML												:XML;
		
		/**
		 * The game canvas 
		 */		
		private var gameRoot													:flash.display.DisplayObjectContainer;

		/**
		 * The starling game canvas
		 */
		private var starlingGameRoot											:starling.display.DisplayObjectContainer;

		/**
		 * The unique identifier of the first screen to show
		 */		
		private var firstScreenName												:String;
		
		/**
		 * The transition sequence that will be used to show the first screen. Optional. 
		 */		
		private var transitionSequenceName										:String;
		
		/**
		 * Game locale 
		 */		
		private var locale														:String;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor 
		 * @param defaultLogic XML
		 * @param gameLogic XML 
		 * @param gameAssets XML
		 * @param root DisplayObjectContainer
		 * @param starlingRoot DisplayObjectContainer
		 * @param firstScreenName String
		 * @param transitionName String
		 * @param locale String
		 */		
		public function InitGameCommandVO(defaultLogic:XML, gameLogic:XML, gameAssets:XML,
										  	root:flash.display.DisplayObjectContainer,
												starlingRoot:starling.display.DisplayObjectContainer,
													firstScreenName:String, transitionName:String, locale:String)
		{
			this.defaultLogicXML = defaultLogic;
			this.gameLogicXML = gameLogic;
			this.gameAssetsXML = gameAssets;
			this.gameRoot = root;
			this.starlingGameRoot = starlingRoot;
			this.firstScreenName = firstScreenName;
			this.transitionSequenceName = transitionName;
			this.locale = locale;
		}
		
		//==============================================================================================================
		// GETTERS
		//==============================================================================================================
		
		public function getDefaultLogicXML():XML
		{
			return defaultLogicXML;
		}
		
		public function getGameLogicXML():XML
		{
			return gameLogicXML;
		}
		
		public function getGameAssetsXML():XML
		{
			return gameAssetsXML;
		}
		
		public function getGameRoot():flash.display.DisplayObjectContainer
		{
			return gameRoot;
		}

		public function getStarlingGameRoot():starling.display.DisplayObjectContainer
		{
			return starlingGameRoot;
		}
		
		public function getFirstScreenName():String
		{
			return firstScreenName;
		}
		
		public function getTransitionSequenceName():String
		{
			return transitionSequenceName;
		}
		
		public function getLocale():String
		{
			return locale;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[InitGameCommandVO]";
		}
	}
}