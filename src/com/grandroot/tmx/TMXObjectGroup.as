package com.grandroot.tmx
{

	public class TMXObjectGroup
	{
		private var _height:uint;
		private var _map:TMXMap;
		private var _name:String;
		private var _objects:Array = [];
		private var _opacity:Number;
		private var _properties:TMXPropertySet = null;
		private var _visible:Boolean;
		private var _width:uint;
		private var _x:int;
		private var _y:int;

		public function TMXObjectGroup(source:XML, parent:TMXMap)
		{
			_map = parent;
			_name = source.@name ? source.@name : "";
			_x = source.@x ? source.@x : 0;
			_y = source.@y ? source.@y : 0;
			_width = source.@width ? source.@width : 0;
			_height = source.@height ? source.@height : 0;
			_visible = !source.@visible || (source.@visible != 0);
			_opacity = source.@opacity ? source.@opacity : 1;

			var node:XML;
			for each (node in source.properties)
			{
				_properties = _properties ? _properties.extend(node) : new TMXPropertySet(node);
			}

			for each (node in source.object)
			{
				_objects.push(new TMXObject(node, this));
			}
		}

		public function get map():TMXMap
		{
			return _map;
		}

	}
}
