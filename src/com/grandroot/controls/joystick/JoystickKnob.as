package com.grandroot.controls.joystick
{
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

	/**
	 * 
	 * @author Ossi Rönnberg
	 * 
	 */
    public class JoystickKnob extends Sprite
    {
		/**
		 * JoystickKnob. You shouldn't have to use this class directly.
		 * @param knobTexture
		 * 
		 */
        public function JoystickKnob(knobTexture:Texture)
        {
            super();
            this.touchable = false;
            this._knobImage = new Image(knobTexture);
           	this._knobImage.pivotX = this._knobImage.width >> 1;
            this._knobImage.pivotY = this._knobImage.height >> 1;
            this.addChild(_knobImage);
        }

        private var _knobImage:Image;
        private var _originX:Number;
        private var _originY:Number;

		/**
		 * 
		 * @return 
		 * 
		 */
        public function get originX():Number
        {
            return _originX;
        }

		/**
		 * 
		 * @param value
		 * 
		 */
        public function set originX(value:Number):void
        {
            _originX = value;
        }

		/**
		 * 
		 * @return 
		 * 
		 */
        public function get originY():Number
        {
            return _originY;
        }

		/**
		 * 
		 * @param value
		 * 
		 */
        public function set originY(value:Number):void
        {
            _originY = value;
        }
    }
}
