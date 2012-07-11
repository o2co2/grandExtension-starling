package com.grandroot.tmx
{
	public dynamic class TMXPropertySet
	{
		public function TMXPropertySet(source:XML)
		{
			extend(source);
		}
		
		public function extend(source:XML):TMXPropertySet
		{
			for each (var prop:XML in source.property)
			{
				var key:String = prop.@name;
				var value:String = prop.@value;
				this[key] = value;
			}
			return this;
		}
	}
}