package com.pixelBender.model.vo.asset
{
	import com.pixelBender.helpers.AssertHelpers;
	import com.pixelBender.interfaces.ITreeLeaf;
	import com.pixelBender.interfaces.ITreeNode;
	
	public class AssetVO implements ITreeLeaf
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * Asset parent. The assetPan 
		 */		
		protected var parentPackage											:AssetPackageVO;
		
		/**
		 * Asset identifier 
		 */
		protected var name													:String;
		
		/**
		 * Asset path without the generic/locale header
		 */
		protected var url													:String;
		
		/**
		 * The URL prefix, used in the loading procedure
		 */
		protected var urlPrefix												:String;
		
		/**
		 * Asset content. Can be anything.
		 */
		protected var content												:Object;
				
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor 
		 * @param name String
		 * @param url String
		 */		
		public function AssetVO(name:String, url:String)
		{
			this.name = name;
			this.url = url;
			urlPrefix = "";
		}
		
		//==============================================================================================================
		// ITreeLeaf IMPLEMENTATION
		//==============================================================================================================
		
		public function setParent(parent:ITreeNode):void
		{
			this.parentPackage = parent as AssetPackageVO;
		}
		
		public function getParent():ITreeNode
		{
			return parentPackage;
		}
		
		public function hasParent():Boolean
		{
			return (parentPackage != null);
		}
				
		public function getName():String
		{
			return name;
		}
		
		public function dispose():void
		{
			name = null;
			content = null;
			parentPackage = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Sets the asset content. Since the container can be everything, this should be overridden by specific
		 * 	class extensions.
		 * @param content Object
		 */		
		public function setContent(content:*):void
		{
			this.content = content;
		}
		
		public function getContent():*
		{
			return content;
		}
		
		public function setURLPrefix(prefix:String):void
		{
			urlPrefix = prefix;
		}
		
		public function getFullURL():String
		{
			return urlPrefix + url;
		}
			
		public function getType():String
		{
			AssertHelpers.assertCondition(false, "Override this!");
			return null;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[AssetVO type:" + getType() + " name:" + name + " url:" + getFullURL() + "]"; 
		}
	}
}