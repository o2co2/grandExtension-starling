package com.grandroot.tmx
{
	import flash.geom.Rectangle;

	public class TMXTileset
	{
		private var _firstGID:uint = 0;
		private var _margin:uint;
		private var _name:String;
		private var _parent:TMXMap;
		private var _source:String;
		private var _spacing:uint;
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
				}
			}
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

		/*
		public function getRect(id:int):Rectangle
		{
			return new Rectangle((id % numCols) * _tileWidth, (id / numCols) * _tileHeight);
		}

		public function hasGid(gid:int):Boolean
		{
			return (gid >= _firstGID) && (gid < _firstGID + numTiles);
		}
		*/

		public function toGid(id:int):int
		{
			return _firstGID + id;
		}
	}
}
