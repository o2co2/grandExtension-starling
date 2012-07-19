package com.grandroot.tmx
{
	import flash.geom.Point;

	public class TMXPolygon
	{
		private var _parent:TMXObject;
		private var _points:Array = [];

		public function TMXPolygon(source:XML, parent:TMXObject)
		{
			_parent = parent;

			if (source.@points)
			{
				var dataString:String = source.@points;
				var dataArray:Array = dataString.split(" ");
				var pointString:String;
				var commaIndex:int;

				for (var i:int = 0; i < dataArray.length; ++i)
				{
					pointString = dataArray[i];
					commaIndex = pointString.search(",");
					_points.push(new Point(Number(pointString.slice(0, commaIndex)), Number(pointString.slice(commaIndex + 1, pointString.length))));
				}
			}
		}

		public function get points():Array
		{
			return _points;
		}

	}
}
