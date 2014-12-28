package com.pixelBender.model.vo.asset
{
	import com.pixelBender.interfaces.IDispose;
	import com.pixelBender.interfaces.ITreeLeaf;
	import com.pixelBender.interfaces.ITreeNode;
	import com.pixelBender.log.Logger;

	import flash.utils.Dictionary;
	
	public class AssetPackageVO implements ITreeNode
	{
		
		//==============================================================================================================
		// MEMBERS
		//==============================================================================================================
		
		/**
		 * The parent asset package. Optional. 
		 */		
		private var parentPackage															:AssetPackageVO;
		
		/**
		 * Asset package identifier 
		 */		
		private var name																	:String;
		
		/**
		 * The package packageType : generic/locale
		 */		
		private var packageType																:String;
		
		/**
		 * The children assets/asset packages in vector form 
		 */		
		private var childrenVector															:Vector.<ITreeLeaf>;
		
		/**
		 * The children assets/asset packages in dictionary form 
		 */		
		private var childrenDictionary														:Dictionary;
		
		/**
		 * The list of children that are assets 
		 */		
		private var assetChildren															:Vector.<AssetVO>;
		
		/**
		 * The list of children that are packages 
		 */		
		private var packageChildren															:Vector.<AssetPackageVO>;
		
		//==============================================================================================================
		// CONSTRUCTOR
		//==============================================================================================================
		
		/**
		 * Constructor 
		 * @param name String
		 * @param packageType String
		 */		
		public function AssetPackageVO(name:String, packageType:String)
		{
			this.name = name;
			this.packageType = packageType;
			childrenVector = new Vector.<ITreeLeaf>();
			childrenDictionary = new Dictionary();
			assetChildren = new Vector.<AssetVO>();
			packageChildren = new Vector.<AssetPackageVO>();
		}
		
		//==============================================================================================================
		// ITreeNode IMPLEMENTATION
		//==============================================================================================================
		
		/**
		 * Will add a child to the lists. 
		 * @param child ITreeLeaf
		 */		
		public function addChild(child:ITreeLeaf):void
		{
			// Constrain to only one parent
			if (child.hasParent())
			{
				child.getParent().removeChild(child);
			}
			// Add to this package and all associated children structures
			childrenVector.push(child);
			childrenDictionary[child.getName()] = child;
			child.setParent(this);
			if (child is AssetVO)
			{
				assetChildren.push(child);
			}
			else if (child is AssetPackageVO)
			{
				packageChildren.push(child);
			}
		}
		
		/**
		 * Will remove the child from the children lists.
		 * @param child
		 * 
		 */		
		public function removeChild(child:ITreeLeaf):void
		{
			var index:int = childrenVector.indexOf(child);
			if (index >= 0 && index < childrenVector.length)
			{
				childrenVector.splice(index,1);
				delete childrenDictionary[child.getName()];
				if (child is AssetVO) 
				{
					index = assetChildren.indexOf(AssetVO(child));
					if ( index >= 0 && index < assetChildren.length )
					{
						assetChildren.splice(index,1);
					}
				} 
				else if (child is AssetPackageVO) 
				{
					index = packageChildren.indexOf(AssetPackageVO(child));
					if ( index >= 0 && index < packageChildren.length )
					{
						packageChildren.splice(index,1);
					}	
				}
					
			}
		}

		/**
		 * Retrieves the asset children in Vector form
		 * @return Vector.<ITreeLeaf>
		 */
		public function getChildrenVector():Vector.<ITreeLeaf>
		{
			return childrenVector;
		}

		/**
		 * Retrieves the child at the specified index
		 * @param index int
		 * @return ITreeLeaf
		 */
		public function getChildAtIndex(index:int):ITreeLeaf
		{
			if (index>=0 && index<childrenVector.length)
			{
				return childrenVector[index];
			}
			else
			{
				Logger.error(this + " Specified index:" + index + " is out of bounds!");
			}
			return null;
		}
		
		/**
		 * Retrieves all assetVO children, including the ones found in the sub packages
		 * @return Vector.<AssetVO>
		 */		
		public function getAllAssetChildren():Vector.<AssetVO>
		{
			// Internals
			var allChildren:Vector.<AssetVO> = new Vector.<AssetVO>(),
				tmp:Vector.<AssetVO>,
				i:int = 0,
				len:int = childrenVector.length,
				j:int;
			// Parse
			for (;i < len; i++)
			{
				if (childrenVector[i] is AssetVO)
				{
					allChildren.push(childrenVector[i])
				}
				else if (childrenVector[i] is AssetPackageVO) 
				{
					tmp = (childrenVector[i] as AssetPackageVO).getAllAssetChildren();
					for (j = 0; j < tmp.length; j++)
					{
						allChildren.push(tmp[j]);
					}
				}
			}
			return allChildren;
		}

		/**
		 * Retrieves the child by name
		 * @param name String
		 * @return ITreeLeaf
		 */
		public function getChild(name:String):ITreeLeaf
		{
			return childrenDictionary[name];
		}
		
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
		
		/**
		 * Proper memory management 
		 */		
		public function dispose():void
		{
			if (childrenVector != null)
			{
				for each (var child:IDispose in childrenVector)
				{
					child.dispose();
				}
				childrenVector = null;
			}
			childrenDictionary = null;
			name = null;
			parentPackage = null;
		}
		
		//==============================================================================================================
		// API
		//==============================================================================================================
		
		/**
		 * Will retrieve the searched asset, also searching through the sub packages. 
		 * @param name String
		 * @param searchSubPackages Boolean
		 * @return AssetVO
		 */		
		public function getAsset(name:String, searchSubPackages:Boolean=true):AssetVO
		{
			// Internals
			var subPackage:AssetPackageVO,
				searchedAsset:AssetVO;
			// Quick search first
			if (childrenDictionary[name] && childrenDictionary[name] is AssetVO)
			{
				return childrenDictionary[name];
			}
			if (searchSubPackages) 
			{
				// Search through the sub packages now
				for each (subPackage in packageChildren)
				{
					searchedAsset = subPackage.getAsset(name, true);
					if (searchedAsset != null)
					{
						// Found the bugger
						return searchedAsset;
					}
				}
			}
			// Not found
			return null;
		}
		
		/**
		 * Type cast wrapper over get asset. Will only retrieve the asset if it is a SWFAssetVO
		 * @param name String
		 * @param searchSubPackages Boolean
		 * @return SWFAssetVO
		 */		
		public function getSWFAsset(name:String, searchSubPackages:Boolean=true):SWFAssetVO
		{
			var searchedAsset:AssetVO = getAsset(name, searchSubPackages);
			if (searchedAsset != null && searchedAsset is SWFAssetVO)
			{
				return searchedAsset as SWFAssetVO;
			}
			return null;
		}
		
		/**
		 * Type cast wrapper over get asset. Will only retrieve the asset if it is a XMLAssetVO
		 * @param name String
		 * @param searchSubPackages Boolean
		 * @return XMLAssetVO
		 */		
		public function getXMLAsset(name:String, searchSubPackages:Boolean=true):XMLAssetVO
		{
			var searchedAsset:AssetVO = getAsset(name, searchSubPackages);
			if (searchedAsset != null && searchedAsset is XMLAssetVO)
			{
				return searchedAsset as XMLAssetVO;
			}
			return null;
		}
		
		/**
		 * Type cast wrapper over get asset. Will only retrieve the asset if it is a SoundAssetVO
		 * @param name String
		 * @param searchSubPackages Boolean
		 * @return SoundAssetVO
		 */		
		public function getSoundAsset(name:String, searchSubPackages:Boolean=true):SoundAssetVO
		{
			var searchedAsset:AssetVO = getAsset(name, searchSubPackages);
			if (searchedAsset != null && searchedAsset is SoundAssetVO)
			{
				return searchedAsset as SoundAssetVO;
			}
			return null;
		}
		
		/**
		 * Will search if all assets and sub assets are complete (aka have content).
		 * @return Boolean 
		 */		
		public function getIsComplete():Boolean
		{
			// Internals
			var assetChild:AssetVO,
				subPackage:AssetPackageVO,
				subPackageComplete:Boolean;
			// Parse all children
			for each (assetChild in assetChildren)
			{
				if (assetChild.getContent() == null)
				{
					return false;
				}
			}
			// Now parse sub packages
			for each (subPackage in packageChildren) 
			{
				subPackageComplete = subPackage.getIsComplete();
				if (!subPackageComplete)
				{
					return false;
				}
			}
			// Everything is done
			return true;
		}
		
		/**
		 * The full name constructed according to the name of the parent. If the name is "a" and it's parent package name is "b",
		 * 	the full name will be "b.a"  
		 * @return String 
		 */		
		public function getFullName():String
		{
			if (parentPackage != null)
			{
				return parentPackage.getFullName() + "." + name;
			}
			return name;
		}
		
		/**
		 * Getter for the packageType member.
		 * @return String 
		 */		
		public function getType():String
		{
			return packageType;
		}
		
		/**
		 * Will retrieve a list of all asset children
		 * @return Vector.<AssetVO>
		 */		
		public function getAssetChildren():Vector.<AssetVO>
		{
			return assetChildren;
		}
		
		/**
		 * Will retrieve a list of all asset package children
		 * @return Vector.<AssetPackageVO>
		 */		
		public function getPackageChildren():Vector.<AssetPackageVO>
		{
			return packageChildren;
		}

		//==============================================================================================================
		// DEBUG
		//==============================================================================================================

		public function toString():String
		{
			return "[AssetPackageVO fullName:" + getFullName() + " type: " + packageType + "]";
		}
	}
}