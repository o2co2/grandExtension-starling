package com.grandroot.display
{
	import com.grandroot.tmx.TMXLayer;
	import com.grandroot.tmx.TMXMap;
	import com.grandroot.tmx.TMXPropertySet;
	import com.grandroot.tmx.TMXTileset;
	import starling.display.Image;
	import starling.display.QuadBatch;

	/**
	 * Tilemap
	 * @author Ossi Rönnberg
	 *
	 */
	public class Tilemap extends QuadBatch
	{
		/**
		 * Creates a quadbatch from the <code>TMXLayer</code> object that can be added to the Starling's stage.
		 * @param layer
		 *
		 */
		public function Tilemap(layer:TMXLayer)
		{
			touchable = false;

			if (layer.parent)
			{
				var map:TMXMap = layer.parent;
			}
			else
			{
				throw new Error("Layer does not have parent.");
			}

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
