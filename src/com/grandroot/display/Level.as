package com.grandroot.display
{
	import com.grandroot.tmx.TMXLayer;
	import com.grandroot.tmx.TMXMap;
	import com.grandroot.tmx.TMXPropertySet;
	import com.grandroot.tmx.TMXTileset;
	
	import mx.charts.CategoryAxis;
	import mx.containers.Tile;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Level extends Sprite
	{
		public function Level(atlas:TextureAtlas, map:TMXMap)
		{
			// assign tiles textures
			var tileset:TMXTileset;
			var propertySet:TMXPropertySet;
			var texture:Texture;

			for each (tileset in map.tilesets)
			{
				trace(tileset.name);
				for each (propertySet in tileset.tileProperties)
				{
					try
					{
						texture = atlas.getTexture(propertySet.name);
						propertySet.texture = texture;
					}
					catch (e:Error)
					{
						trace(e.message);
					}

				}
			}

			// layers
			var tileImage:Image;
			var row:int;
			var layer:TMXLayer;
			var column:int;
			var columnGID:int;

			for each (layer in map.layers)
			{
				trace(layer.name);
				var layerQB:QuadBatch = new QuadBatch();

				for (row = 0; row < layer.tileGIDs.length; ++row)
				{
					for (column = 0; column < (layer.tileGIDs[row] as Array).length; ++column)
					{
						columnGID = layer.tileGIDs[row][column];
						trace(columnGID);
						tileset = null;
						tileset = map.getGidOwner(columnGID);

						if (tileset)
						{
							propertySet = tileset.getPropertiesByGid(columnGID);
							if (propertySet.texture)
							{
								tileImage = new Image(propertySet.texture);
								tileImage.x = (column * map.tileWidth) >> 1;
								tileImage.y = (row * map.tileHeight) >> 1;
								layerQB.addImage(tileImage);
							}
							else
							{
								trace("cannot find texture");
							}

						}
					}
				}
				
				addChild(layerQB);
			}
		}
	}
}
