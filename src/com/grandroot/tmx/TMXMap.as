package com.grandroot.tmx
{
	import flash.utils.ByteArray;

	public class TMXMap
	{
		private var _height:uint;
		private var _layers:Object = {};
		private var _objectGroups:Object = {};
		private var _orientation:String;
		private var _properties:TMXPropertySet = null;
		private var _tileHeight:uint;
		private var _tileWidth:uint;
		private var _tilesets:Object = {};
		private var _version:String;
		private var _width:uint;
		private var _xml:XML;

		public function TMXMap(source:Class)
		{
			var rawData:ByteArray = new source;
			var dataString:String = rawData.readUTFBytes(rawData.length);
			_xml = new XML(dataString);

			_version = _xml.@version ? _xml.@version : "unknown";
			_orientation = _xml.@orientation ? _xml.@orientation : "orthogonal";
			_width = _xml.@width ? _xml.@width : 0;
			_height = _xml.@height ? _xml.@height : 0;
			_tileWidth = _xml.@tilewidth ? _xml.@tilewidth : 0;
			_tileHeight = _xml.@tileheight ? _xml.@tileheight : 0;

			var node:XML = null;

			// properties
			for each (node in _xml.properties)
			{
				_properties = _properties ? _properties.extend(node) : new TMXPropertySet(node);
			}

			// tilesets
			for each (node in _xml.tileset)
			{
				_tilesets[node.@name] = new TMXTileset(node, this);
			}

			// layers
			for each (node in _xml.layer)
			{
				_layers[node.@name] = new TMXLayer(node, this);
			}

			// object groups
			for each (node in _xml.objectgroup)
			{
				_objectGroups[node.@name] = new TMXObjectGroup(node, this);
			}
		}

		public function get tilesets():Object
		{
			return _tilesets;
		}

	}
}
