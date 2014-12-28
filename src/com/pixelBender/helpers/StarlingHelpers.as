package com.pixelBender.helpers
{
	import com.pixelBender.log.Logger;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	import starling.display.DisplayObject;

	import starling.display.DisplayObjectContainer;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class StarlingHelpers
	{
		//==============================================================================================================
		// CONSTANTS
		//==============================================================================================================
		
		public static const DEFAULT_PIECE_SIZE											:int = 256;
		
		//==============================================================================================================
		// API
		//==============================================================================================================

		public static function removeFromParent(childToRemove:DisplayObject, dispose:Boolean=true):void
		{
			if (childToRemove != null)
			{
				childToRemove.removeFromParent(dispose);
			}
		}

		public static function disposeContainer(container:DisplayObjectContainer, disposeChildren:Boolean = true):void
		{
			if (container != null)
			{
				if (disposeChildren)
				{
					container.removeChildren(0, -1, disposeChildren);
				}
				container.removeFromParent(disposeChildren);
			}
		}

		public static function createTextureSprite(bitmapData:BitmapData, spriteWidth:int, spriteHeight:int,
												   cutInPieces:Boolean=false, pieceSize:int=DEFAULT_PIECE_SIZE):Sprite
		{
			// Internals
			var time:int = getTimer(),
				newTime:int;
			// Create backgrounds
			var sprite:Sprite = new Sprite(),
				image:Image,
				texture:Texture;
			// Check algorithm
			if (cutInPieces) 
			{
				// Compute rectangles
				var rectangles:Vector.<Rectangle> = computeOptimalLayout(new Rectangle(0, 0, spriteWidth, spriteHeight), pieceSize);
				newTime = getTimer();
				time = newTime;
				Logger.debug("Computed texture rectangles in: " + (newTime-time));
				// Origin point
				const origin:Point = new Point();
				// Create texture images out of the clipped rectangles
				for (var i:int=0;i<rectangles.length;i++)
				{
					var textureData:BitmapData = new BitmapData(rectangles[i].width, rectangles[i].height, true, 0x00000000);
					textureData.copyPixels(bitmapData, rectangles[i], origin);
					texture = Texture.fromBitmapData(textureData);	
					image = new Image(texture);
					image.x = rectangles[i].x;
					image.y = rectangles[i].y;
					sprite.addChild(image);
				}
			}
			else 
			{
				// Create one single texture with the given data
				texture = Texture.fromBitmapData(bitmapData);
				image = new Image(texture);
				sprite.addChild(image);
			}
			newTime = getTimer();
			Logger.debug("Background textures creation took: " + (newTime - time));
			// Done
			return sprite;
		}
		
		public static function createTextureSpriteBackground(bitmapData:BitmapData, spriteWidth:int, spriteHeight:int,
															 cutInPieces:Boolean=false, pieceSize:int=DEFAULT_PIECE_SIZE):Sprite
		{			
			return createTextureSprite(bitmapData, spriteWidth, spriteHeight, cutInPieces, pieceSize);
		}

		private static function computeOptimalLayout(layout:Rectangle, maxSize:int):Vector.<Rectangle>
		{
			// Internal constants
			const 	max:int = maxSize,
					layoutWidth:int = layout.width,
					layoutHeight:int = layout.height,
					rows:int = Math.ceil(layoutHeight/max),
					columns:int = Math.ceil(layoutWidth/max);
			// Internals
			var rectangles:Vector.<Rectangle> = new <Rectangle>[],
				piece:Rectangle,
				pieceOffsetX:int,
				pieceOffsetY:int,
				pieceWidth:int,
				pieceHeight:int,
				i:int,
				j:int;
			// Parse and compute rectangles
			for (i=0;i<columns;i++) 
			{
				pieceOffsetX = i*max;
				pieceWidth = max;
				// Compute optimized height for last row
				if ( i == columns-1 ) 
				{
					pieceWidth = 1;		
					while ( pieceOffsetX + pieceWidth < layoutWidth ) {
						pieceWidth = pieceWidth << 1;
					}
				}
				for (j=0;j<rows;j++) 
				{
					pieceOffsetY = j*max;
					pieceHeight = max;
					// Compute optimized width for last column
					if ( j == rows-1 ) 
					{
						pieceHeight = 1;
						while ( pieceOffsetY + pieceHeight < layoutHeight ) {
							pieceHeight = pieceHeight << 1;
						}
					}
					// Add computed rectangle
					rectangles.push(new Rectangle(pieceOffsetX, pieceOffsetY, pieceWidth, pieceHeight));
				}
			}
			// Done
			return rectangles;
		}
	}
}