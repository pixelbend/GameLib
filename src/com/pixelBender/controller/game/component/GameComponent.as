package com.pixelBender.controller.game.component
{
	import com.pixelBender.constants.GameConstants;
	import com.pixelBender.helpers.AssertHelpers;
	
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;

	public class GameComponent
	{
		
		//==============================================================================================================
		// STATIC MEMBERS
		//==============================================================================================================
		
		/**
		 * Used for runtime class validation. 
		 */		
		private static var QUALIFIED_CLASS_NAME_DICTIONARY							:Dictionary;
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Component name: asset proxy/sound proxy etc. . From GameConstants.
		 */
		private var name															:String;
		
		/**
		 * Base component componentType. Proxy/Mediator
		 */
		private var componentType													:String;
		
		/**
		 * Component qualified class name. Used for reflection creation
		 */
		private var className														:String;
		
		/**
		 * Game root container
		 */
		private var rootContainer													:DisplayObjectContainer;
		
		/**
		 * Component reflected class
		 */
		private var componentClass													:Class;

		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor 
		 * @param name String
		 * @param componentType String
		 * @param className String
		 * @param rootContainer DisplayObjectContainer
		 */		
		public function GameComponent(name:String, componentType:String, className:String, rootContainer:DisplayObjectContainer)
		{
			this.name = name;
			this.componentType = componentType;
			this.className = className;
			this.rootContainer = rootContainer;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Will create the game component instance validating the class passed for the proper inheritance.
		 * @param facade IFacade
		 * @return - the created component, be it proxy or mediator
		 */		
		public function validateAndCreate(facade:IFacade):*
		{
			return create(facade, true);
		}
		
		/**
		 * Will create the game component.
		 * @param facade IFacade
		 * @param validate Boolean - flag if the class should be validated for inheritance.
		 * @return - the created component, be it proxy or mediator
		 */		
		public function create(facade:IFacade, validate:Boolean=false):Object
		{
			// Internals
			var createdComponent:Object;
			// Create component class
			componentClass = ApplicationDomain.currentDomain.getDefinition(className) as Class;
			// Validation step
			if (validate)
			{
				AssertHelpers.assertCondition(validateClass(componentClass), "Could not validate " + toString() + "! Inheritance is broken!");
			}
			// Creation step
			switch(componentType)
			{
				case GameConstants.TYPE_PROXY:
					createdComponent = createProxy(facade);
					break;
				case GameConstants.TYPE_MEDIATOR:
					createdComponent = createMediator(facade);
					break;
			}
			return createdComponent;
		}
		
		public function getName():String
		{
			return name;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[GameComponent name:"+name+" className:"+className+"]";
		}
		
		//==============================================================================================================
		// STATIC API
		//==============================================================================================================
		
		public static function setQualifiedClassNameDictionary(dictionary:Dictionary):void
		{
			QUALIFIED_CLASS_NAME_DICTIONARY = dictionary;
		}
				
		//==============================================================================================================
		// LOCALS
		//==============================================================================================================
		
		/**
		 * Class instance validator.
		 * 	Uses the qualified class name dictionary and the descriptor given using reflection for the class.
		 * @param cls Class
		 * @return Boolean
		 * 
		 */		
		private function validateClass(cls:Class):Boolean
		{
			var descriptor:XML = describeType(cls);
			var classNameToCheck:String = QUALIFIED_CLASS_NAME_DICTIONARY[name];
			var extendList:XMLList = descriptor.factory.extendsClass;
			var node:XML;
			for each (node in extendList)
			{
				if ( String(node.@type) == classNameToCheck )
				{
					return true;
				}
			}
			// No proper inheritance found.
			return false;
		}

		/**
		 * Will create a IMediator component while also registering it to the test.facade.
		 * @param facade IFacade
		 * @return IMediator
		 */		
		private function createMediator(facade:IFacade):IMediator
		{
			var mediator:IMediator = new componentClass(name);
			facade.registerMediator(mediator);	
			return mediator;
		}
		
		/**
		 * Will create a IProxy component while also registering it to the test.facade.
		 * @param facade IFacade
		 * @return IProxy
		 */
		private function createProxy(facade:IFacade):IProxy
		{
			var proxy:IProxy = new componentClass(name);
			facade.registerProxy(proxy);
			return proxy;
		}
	}
}