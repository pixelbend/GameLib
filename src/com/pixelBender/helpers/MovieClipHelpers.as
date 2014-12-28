package com.pixelBender.helpers
{	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;

	public class MovieClipHelpers
	{
		/**
		 * Will remove childToRemove from the display list if it actually added there. 
		 * @param childToRemove DisplayObject
		 */		
		public static function removeFromParent(childToRemove:DisplayObject):void
		{
			if (childToRemove != null && childToRemove.parent != null)
			{
				childToRemove.parent.removeChild(childToRemove);
			}
		}
		
		/**
		 * 
		 * Recursively stops all movieClips
		 * @param container The container to start from
		 * @param stopContainer Whether to .stop() the <code>container</code> parameter
		 */
		static public function stopRecursive(container:DisplayObjectContainer, stopContainer:Boolean=true):void
		{
			// Data integrity check
			AssertHelpers.assertCondition(container != null, "DisplayObjectContainer is null!");
			// Internals
			var i:int = 0,
				length:int = container.numChildren,
				child:DisplayObjectContainer;
			// Stop container
			if (container is MovieClip && stopContainer)
			{
				MovieClip(container).stop();
			}
			// Parse through children
			for(; i<length; i++)
			{
				child = container.getChildAt(i) as DisplayObjectContainer;
				if (child == null)
				{
					continue;
				}
				stopRecursive(child, true);
			}
		}
		
		/**
		 * Recursively plays all movieClips
		 * @param container The container to start from
		 * @param playContainer Whether to .play() the <code>container</code> parameter
		 * 
		 */
		static public function playRecursive(container:DisplayObjectContainer, playContainer:Boolean=true):void
		{
			// Data integrity check
			AssertHelpers.assertCondition(container != null, "DisplayObjectContainer is null!");
			// Internals
			var i:int = 0,
				length:int = container.numChildren,
				child:DisplayObjectContainer;
			// Play container
			if (container is MovieClip && playContainer)
			{
				MovieClip(container).play();
			}
			// Parse and play children
			for(; i<length; i++)
			{
				child = container.getChildAt(i) as DisplayObjectContainer;
				if (child == null)
				{
					continue;
				}
				playRecursive(child, true);
			}
		}
		
		/**
		 * Parses the container for movie clips and sets them all to specified frame -- gotoAndStop(frame) 
		 * @param container DisplayObjectContainer
		 * @param frame Object
		 */
		static public function gotoAndStopRecursive(container:DisplayObjectContainer, frame:Object = 1):void
		{
			// Data integrity check
			AssertHelpers.assertCondition(container != null, "DisplayObjectContainer is null!");
			// Internals
			var i:int = 0,
				length:int = container.numChildren,
				child:DisplayObjectContainer;
			// Stop the actual container
			if (container is MovieClip)
			{
				MovieClip(container).gotoAndStop(frame);
			}
			// Parse and stop
			for(; i<length; i++)
			{
				child = container.getChildAt(i) as DisplayObjectContainer;
				if (child == null)
				{
					continue;
				}
				gotoAndStopRecursive(child, frame);
			}
		}

		/**
		 * Disables mouseEvents for all children of a movieClip
		 * @param interactiveObject InteractiveObject
		 */
		static public function removeMouseInteraction(interactiveObject:InteractiveObject) :void
		{
			// Data integrity check
			AssertHelpers.assertCondition(interactiveObject != null, "InteractiveObject is null!");
			// Internals
			var container:DisplayObjectContainer = interactiveObject as DisplayObjectContainer;
			// Remove mouse enabled
			interactiveObject.mouseEnabled = false;
			// Remove mouse children if this is a container
			if (container != null)
			{
				// Remove mouse children
				container.mouseChildren = false;
				// Remove interaction from all children
				var i:int = 0,
					length:int = container.numChildren,
					child:DisplayObjectContainer;
				for(; i<length; i++)
				{
					child = container.getChildAt(i) as DisplayObjectContainer;
					if (child == null)
					{
						continue;
					}
					removeMouseInteraction(child);
				}
			}
		}
		
		/**
		 * Enable mouse interaction
		 * @param interactiveObject InteractiveObject
		 * @param stopAtFirstMouseEnabledParent Boolean
		 */
		static public function enableMouseInteraction(interactiveObject:InteractiveObject, stopAtFirstMouseEnabledParent:Boolean = true) :void
		{
			// Data integrity check
			AssertHelpers.assertCondition(interactiveObject != null, "InteractiveObject is null!");
			// Enable mouse for target
			interactiveObject.mouseEnabled = true;
			// Set mouse children true to all parents
			var parent:DisplayObjectContainer = interactiveObject.parent;
			while (parent != null)
			{
				if (stopAtFirstMouseEnabledParent && parent.mouseChildren)
				{
					break;
				}
				parent.mouseChildren = true;
				parent = parent.parent;
			}
		}
		
		/**
		 * Extracts a movieClip using a path like: "parent.child1.child3.child12"
		 * @param mcParent
		 * @param path
		 * @param pathSeparator
		 * @return the movieClip if created, otherwise it will throw an error
		 */
		static public function extract(mcParent:MovieClip, path:String, pathSeparator:String = "."):DisplayObject 
		{
			// Data integrity check
			AssertHelpers.assertCondition(mcParent != null, "mcParent is null!");
			AssertHelpers.assertCondition((path && path.length>0), "Path is 'null' or undefined");
			// Internals
			var parts:Array = path.split(pathSeparator),
				extractedChild:DisplayObject = mcParent,
				part:String;
			// Search recursively
			for each(part in parts)
			{
				if( extractedChild.hasOwnProperty(part))
				{
					extractedChild = extractedChild[part];
				}
				else
				{
					throw new Error(String("'" + part + "' specified in '" + path + "' was not found within MovieClip!"));
				}
			}
			// Done
			return extractedChild;
		}
	}
}