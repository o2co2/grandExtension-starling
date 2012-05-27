package com.grandroot.controls.joystick
{
    import com.greensock.TweenLite;
    import com.greensock.data.TweenLiteVars;
    import com.greensock.easing.Bounce;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import mx.effects.Tween;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;

    public class Joystick extends Sprite
    {
        public function Joystick(baseTexture:Texture, knobTexture:Texture)
        {
            super();
            _baseImage = new Image(baseTexture);
            _knob = new JoystickKnob(knobTexture);
            addChild(_baseImage);
            addChild(_knob);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            _baseImage.addEventListener(TouchEvent.TOUCH, onTouch);
        }

        private var _align:String = JoystickAlign.BOTTOM_LEFT;

        private var _baseImage:Image;

        private var _centerX:int;

        private var _centerY:int;

        private var _down:Rectangle;

        private var _downLeft:Rectangle;

        private var _downRight:Rectangle;

        private var _fadeTween:TweenLite = new TweenLite(this, 0.2, { alpha: 1, paused: true });

        private var _hideWhenInactive:Boolean = false;

        private var _isPressed:Boolean = false;

        private var _knob:JoystickKnob;

        private var _knobTween:TweenLite;

        private var _left:Rectangle;

        private var _marginX:int;

        private var _marginY:int;

        private var _movementArea:Rectangle;

        private var _right:Rectangle;

        private var _up:Rectangle;

        private var _upLeft:Rectangle;

        private var _upRight:Rectangle;

        public function get align():String
        {
            return _align;
        }

        public function set align(value:String):void
        {
            _align = value;
        }

        public function get hideWhenInactive():Boolean
        {
            return _hideWhenInactive;
        }

        public function set hideWhenInactive(value:Boolean):void
        {
            _hideWhenInactive = value;
            alpha = 0;
        }

        public function get marginX():int
        {
            return _marginX;
        }

        public function set marginX(value:int):void
        {
            _marginX = value;
        }

        public function get marginY():int
        {
            return _marginY;
        }

        public function set marginY(value:int):void
        {
            _marginY = value;
        }

        public function get offset():Point
        {
            return new Point(((_knob.originX - _knob.x) / (_movementArea.width >> 1)) * -1, ((_knob.originY - _knob.y) / (_movementArea.height >> 1)) * -1);
        }

        public function get state():String
        {
            if (_isPressed)
            {
                if (_right.contains(_knob.x, _knob.y))
                {
                    return JoystickState.RIGHT;
                }
                else if (_left.contains(_knob.x, _knob.y))
                {
                    return JoystickState.LEFT;
                }
                else if (_up.contains(_knob.x, _knob.y))
                {
                    return JoystickState.UP;
                }
                else if (_down.contains(_knob.x, _knob.y))
                {
                    return JoystickState.DOWN;
                }
                else if (_upRight.contains(_knob.x, _knob.y))
                {
                    return JoystickState.UP_RIGHT;
                }
                else if (_downRight.contains(_knob.x, _knob.y))
                {
                    return JoystickState.DOWN_RIGHT;
                }
                else if (_downLeft.contains(_knob.x, _knob.y))
                {
                    return JoystickState.DOWN_LEFT
                }
                else if (_upLeft.contains(_knob.x, _knob.y))
                {
                    return JoystickState.UP_LEFT
                }
            }

            return JoystickState.CENTER;
        }

        private function alignJoystick():void
        {
            switch (_align)
            {

                case JoystickAlign.TOP_LEFT:
                {
                    _baseImage.x = 0 + marginX;
                    _baseImage.y = 0 + marginY;
                    break;
                }

                case JoystickAlign.TOP_RIGHT:
                {
                    _baseImage.x = Starling.current.stage.stageWidth - _baseImage.width - marginX;
                    _baseImage.y = 0 + marginY;
                    break;
                }

                case JoystickAlign.BOTTOM_RIGHT:
                {
                    _baseImage.x = Starling.current.stage.stageWidth - _baseImage.width - marginX;
                    _baseImage.y = Starling.current.stage.stageHeight - _baseImage.height - marginY;
                    break;
                }

                default:
                case JoystickAlign.BOTTOM_LEFT:
                {
                    _baseImage.x = 0 + marginX;
                    _baseImage.y = Starling.current.stage.stageHeight - _baseImage.height - marginY;
                    break;
                }
            }

            _centerX = _baseImage.x + (_baseImage.width >> 1);
            _centerY = _baseImage.y + (_baseImage.height >> 1);
            _knob.originX = _centerX;
            _knob.originY = _centerY;
            _knob.x = _knob.originX;
            _knob.y = _knob.originY;
            var knobHalfWidth:Number = _knob.width >> 1;
            var knobHalfHeight:Number = _knob.height >> 1;
            var touchAreaHeight:Number = _baseImage.height / 3;
            var touchAreaWidth:Number = _baseImage.width / 3;
            _movementArea = new Rectangle(_baseImage.x + knobHalfWidth, _baseImage.y + knobHalfHeight, _baseImage.width - _knob.width, _baseImage.height - _knob.height);
            _upLeft = new Rectangle(_baseImage.x, _baseImage.y, touchAreaWidth, touchAreaHeight);
            _up = new Rectangle(_upLeft.right, _baseImage.y, touchAreaWidth, touchAreaHeight);
            _upRight = new Rectangle(_up.right, _baseImage.y, touchAreaWidth, touchAreaHeight);
            _left = new Rectangle(_baseImage.x, _upRight.bottom, touchAreaWidth, touchAreaHeight);
            _right = new Rectangle(_up.right, _left.y, touchAreaWidth, touchAreaHeight);
            _downLeft = new Rectangle(_left.x, _left.bottom, touchAreaWidth, touchAreaHeight);
            _down = new Rectangle(_downLeft.right, _downLeft.y, touchAreaWidth, touchAreaHeight);
            _downRight = new Rectangle(_down.right, _down.y, touchAreaWidth, touchAreaHeight);
        }

        private function onAddedToStage(event:Event):void
        {
            alignJoystick();
        }

        private function onTouch(event:TouchEvent):void
        {
            for (var i:int = 0; i < event.getTouches(this).length; ++i)
            {
                var touch:Touch = event.getTouches(this)[i];
                if (touch.phase == TouchPhase.BEGAN)
                {
                    _isPressed = true;
                }
                else if (touch.phase == TouchPhase.ENDED)
                {
                    _isPressed = false;
                    _knobTween = new TweenLite(_knob, 0.5, { x: _knob.originX, y: _knob.originY, ease: Bounce.easeOut });
                }
            }

            if (_isPressed)
            {
                if (hideWhenInactive && alpha < 1)
                {
                    _fadeTween.play();
                }

                touch = event.getTouches(this)[0];
                _knob.x = touch.globalX;

                if (touch.globalX < _movementArea.left)
                {
                    _knob.x = _movementArea.left;
                }
                else if (touch.globalX > _movementArea.right)
                {
                    _knob.x = _movementArea.right;
                }

                _knob.y = touch.globalY;

                if (touch.globalY < _movementArea.top)
                {
                    _knob.y = _movementArea.top;
                }
                else if (touch.globalY > _movementArea.bottom)
                {
                    _knob.y = _movementArea.bottom;
                }
            }
            else if (hideWhenInactive && alpha > 0)
            {
                _fadeTween.reverse();
            }
        }
    }
}
