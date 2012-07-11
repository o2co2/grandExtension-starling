package com.grandroot.tmx
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	public class TMXLayer
	{

		private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

		private var _height:uint;
		private var _name:String;
		private var _opacity:Number;
		private var _parent:TMXMap;
		private var _properties:TMXPropertySet = null;
		private var _tileGIDs:Array;
		private var _visible:Boolean;
		private var _width:uint;
		private var _x:int;
		private var _y:int;

		public function TMXLayer(source:XML, parent:TMXMap)
		{
			_parent = parent;
			_name = source.@name ? source.@name : "";
			_x = source.@x ? source.@x : 0;
			_y = source.@y ? source.@y : 0;
			_width = source.@width ? source.@width : 0;
			_height = source.@height ? source.@height : 0;
			_opacity = source.@opacity ? source.@opacity : 1;
			_visible = !source.@visible || (source.@visible != 0);

			var node:XML;
			for each (node in source.properties)
			{
				_properties = _properties ? _properties.extend(node) : new TMXPropertySet(node);
			}

			_tileGIDs = [];
			var data:XML = source.data[0];
			if (data)
			{
				var chunk:String = "";
				if (data.@encoding.length() == 0)
				{
					//create a 2dimensional array
					var lineWidth:int = _width;
					var rowIdx:int = -1;
					for each (node in data.tile)
					{
						//new line?
						if (++lineWidth >= _width)
						{
							_tileGIDs[++rowIdx] = [];
							lineWidth = 0;
						}
						var gid:int = node.@gid;
						_tileGIDs[rowIdx].push(gid);
					}
				}
				else if (data.@encoding == "csv")
				{
					chunk = data;
					trace(chunk);
					_tileGIDs = csvToArray(chunk, _width);
				}
				else if (data.@encoding == "base64")
				{
					chunk = data;
					var compressed:Boolean = false;
					trace(chunk);
					var time:Number = getTimer();
					if (data.@compression == "zlib")
					{
						compressed = true;
					}
					else if (data.@compression.length() != 0)
					{
						throw Error("TMXLayer - data compression type not supported!");
					}

					for (var i:int = 0; i < 100; i++)
					{
						_tileGIDs = base64ToArray(chunk, _width, compressed);
					}


					trace("tooked", getTimer() - time);
				}
			}
		}

		public static function base64ToArray(chunk:String, lineWidth:int, compressed:Boolean):Array
		{
			var result:Array = [];
			var data:ByteArray = base64ToByteArray(chunk);
			if (compressed)
			{
				data.uncompress();
			}
			data.endian = Endian.LITTLE_ENDIAN;
			while (data.position < data.length)
			{
				var resultRow:Array = [];
				for (var i:int = 0; i < lineWidth; ++i)
					resultRow.push(data.readInt())
				result.push(resultRow);
			}
			return result;
		}

		public static function base64ToByteArray(data:String):ByteArray
		{
			var output:ByteArray = new ByteArray();
			//initialize lookup table
			var lookup:Array = [];
			for (var c:int = 0; c < BASE64_CHARS.length; ++c)
			{
				lookup[BASE64_CHARS.charCodeAt(c)] = c;
			}

			var outputBuffer:Array = new Array(3);

			for (var i:uint = 0; i < data.length - 3; i += 4)
			{
				//read 4 bytes and look them up in the table
				var a0:int = lookup[data.charCodeAt(i)];
				var a1:int = lookup[data.charCodeAt(i + 1)];
				var a2:int = lookup[data.charCodeAt(i + 2)];
				var a3:int = lookup[data.charCodeAt(i + 3)];

				// convert to and write 3 bytes
				if (a1 < 64)
					output.writeByte((a0 << 2) + ((a1 & 0x30) >> 4));
				if (a2 < 64)
					output.writeByte(((a1 & 0x0f) << 4) + ((a2 & 0x3c) >> 2));
				if (a3 < 64)
					output.writeByte(((a2 & 0x03) << 6) + a3);
			}

			// Rewind & return decoded data
			output.position = 0;
			return output;
		}

		public static function csvToArray(input:String, lineWidth:int):Array
		{
			var result:Array = [];
			var rows:Array = input.split("\n");
			for each (var row:String in rows)
			{
				var resultRow:Array = [];
				var entries:Array = row.split(",", lineWidth);
				for each (var entry:String in entries)
				{
					resultRow.push(uint(entry)); //convert to uint
				}
				result.push(resultRow);
			}
			return result;
		}
	}
}
