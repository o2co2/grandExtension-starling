package com.grandroot.display
{
	import com.grandroot.tmx.TMXLayer;
	import com.grandroot.tmx.TMXMap;
	import com.grandroot.tmx.TMXPropertySet;
	import com.grandroot.tmx.TMXTileset;
	import mx.containers.Tile;
	import starling.display.Image;
	import starling.display.QuadBatch;

	public class Tilemap extends QuadBatch
	{
		public function Tilemap(layer:TMXLayer, map:TMXMap)
		{
			var row:int;
			var column:int;
			var columnGID:int;
			var tileImage:Image;
			var tileset:TMXTileset;
			var propertySet:TMXPropertySet;

			for (row = 0; row < layer.tileGIDs.length; ++row)
			{
				for (column = 0; column < (layer.tileGIDs[row] as Array).length; ++column)
				{
					columnGID = layer.tileGIDs[row][column];
					tileset = null;
					tileset = map.getGidOwner(columnGID);

					if (tileset)
					{
						propertySet = tileset.getPropertiesByGid(columnGID);
						if (propertySet && propertySet.texture)
						{
							tileImage = new Image(propertySet.texture);
							tileImage.x = (column * map.tileWidth);
							tileImage.y = (row * map.tileHeight);
							addImage(tileImage);
						}
						else
						{
							trace("WARNING! Can not find texture");
						}
					}
				}
			}
		}
	}
}
