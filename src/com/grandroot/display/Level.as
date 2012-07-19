package com.grandroot.display
{
	import com.grandroot.tmx.TMXLayer;
	import com.grandroot.tmx.TMXMap;
	import com.grandroot.tmx.TMXObject;
	import com.grandroot.tmx.TMXObjectGroup;
	import com.grandroot.tmx.TMXPolygon;
	import com.grandroot.tmx.TMXPropertySet;
	import com.grandroot.tmx.TMXTileset;
	import flash.geom.Point;
	import nape.geom.GeomPoly;
	import nape.geom.GeomPolyList;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.shape.ValidationResult;
	import nape.space.Space;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Level extends Sprite
	{
		private var _map:TMXMap;
		private var _obstacles:Body;
		private var _space:Space;

		public function Level(atlas:TextureAtlas, map:TMXMap, space:Space = null)
		{
			_map = map;

			if (space)
			{
				_space = space;
			}

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

			var objectgroup:TMXObjectGroup;
			var object:TMXObject;

			// object groups
			for each (objectgroup in map.objectGroups)
			{
				trace(objectgroup.name);

				if (objectgroup.name == 'obstacles')
				{
					_obstacles = new Body(BodyType.STATIC);

					for each (object in objectgroup.objects)
					{
						if (object.polygon)
						{
							var tmxPolygon:TMXPolygon = object.polygon as TMXPolygon;
							var vertices:Vector.<Vec2> = new Vector.<Vec2>;

							for each (var point:Point in tmxPolygon.points)
							{
								vertices.push(new Vec2(point.x / 2, point.y / 2));
							}

							if (vertices.length > 0)
							{
								var polygon:Polygon = new Polygon(vertices);

								if (polygon.validity() == ValidationResult.VALID)
								{
									_obstacles.shapes.add(polygon);
								}
								else if (polygon.validity() == ValidationResult.CONCAVE)
								{
									var concave:GeomPoly = new GeomPoly(vertices);
									var convex:GeomPolyList = concave.convex_decomposition();
									convex.foreach(function(p:GeomPoly):void {_obstacles.shapes.add(new Polygon(p));});
								}
								else
								{
									trace("invalid polygon");
								}
							}
						}
					}

					_obstacles.space = space;
				}
			}
		}
	}
}
