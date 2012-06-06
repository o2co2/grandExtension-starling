package com.grandroot.managers
{
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.Sprite;

	public class StateManager
	{

		private static var sCurrent:StateManager;

		private var mContainer:Sprite;

		private var mCurrentState:String;
		private var mStates:Dictionary;

		public function StateManager()
		{
			super();
			initialize();
		}

		public static function get current():StateManager
		{
			return sCurrent;
		}

		public function addState(name:String, state:State):void
		{
			if (!mStates[name])
			{
				state.visible = false;
				mStates[name] = state;
				mContainer.addChild(state);
			}
			else
			{
				throw new Error("State '" + name + "' is already added.");
			}
		}

		public function get currentState():String
		{
			return mCurrentState;
		}

		public function initialize():void
		{
			if (!Starling.current || !Starling.current.isStarted)
			{
				throw new Error("You need to start Starling first.");
			}

			if (current)
			{
				throw new Error("StateManager is already initialized. You can only have one of these.");
			}

			sCurrent = this;
			mStates = new Dictionary();
			mContainer = new Sprite();

			Starling.current.stage.addChild(mContainer);

			trace("[grandExtension StateManager] Initialization complete.");
		}

		public function showState(name:String):void
		{
			if (mStates[name] && mCurrentState != name)
			{
				if (mCurrentState)
				{
					(mStates[mCurrentState] as State).visible = false;
				}
				(mStates[name] as State).visible = true;
				mCurrentState = name;
			}
			else
			{
				throw new Error("State '" + name + "' cannot be found.");
			}
		}
	}
}
