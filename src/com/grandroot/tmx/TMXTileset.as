package com.grandroot.tmx
{
	import flash.geom.Rectangle;
	import starling.textures.Texture;

	public class TMXTileset
	{
		private var _firstGID:uint = 0;
		private var _margin:uint;
		private var _name:String;
		private var _numTiles:int = 0xFFFFFF;
		private var _parent:TMXMap;
		private var _source:String;
		private var _spacing:uint;
		private var _texture:Texture;
		private var _tileHeight:uint;
		private var _tileProperties:Array = [];
		private var _tileWidth:uint;

		public function TMXTileset(source:XML, parent:TMXMap)
		{
			_parent = parent;
			_firstGID = source.@firstgid ? source.@firstgid : 0;
			_source = source.image.@source ? source.image.@source : "";
			_name = source.@name ? source.@name : "";
			_tileWidth = source.@tilewidth ? source.@tilewidth : 0;
			_tileHeight = source.@tileheight ? source.@tileheight : 0;
			_spacing = source.@spacing ? source.@spacing : 0;
			_margin = source.@margin ? source.@margin : 0;

			for each (var node:XML in source.tile)
			{
				if (node.properties[0])
				{
					_tileProperties[int(node.@id)] = new TMXPropertySet(node.properties[0]);
					_numTiles++;
				}
			}
		}

		public function get firstGID():uint
		{
			return _firstGID;
		}

		public function fromGid(gid:int):int
		{
			return gid - _firstGID;
		}

		public function getProperties(id:int):TMXPropertySet
		{
			return _tileProperties[id];
		}

		public function getPropertiesByGid(gid:int):TMXPropertySet
		{
			return _tileProperties[gid - _firstGID];
		}

		public function hasGid(gid:int):Boolean
		{
			return (gid >= firstGID) && (gid < firstGID + _numTiles);
		}

		public function get margin():uint
		{
			return _margin;
		}

		public function get name():String
		{
			return _name;
		}

		public function get spacing():uint
		{
			return _spacing;
		}

		public function get tileHeight():uint
		{
			return _tileHeight;
		}

		public function get tileProperties():Array
		{
			return _tileProperties;
		}

		public function get tileWidth():uint
		{
			return _tileWidth;
		}

		public function toGid(id:int):int
		{
			return _firstGID + id;
		}
	}
}
