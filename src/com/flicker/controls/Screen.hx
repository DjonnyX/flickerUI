package com.flicker.controls;

import com.flicker.core.Router;
import haxe.io.Error;
import com.flicker.display.DisplayObject;

import com.flicker.controls.super.FlickerControl;
import com.flicker.controls.super.InteractiveControl;
import com.flicker.core.Router.Route;
import com.flicker.data.ElementData;
import com.flicker.events.Event;

/**
 * ...
 * @author Evgenii Grebennikov
 */
class Screen extends FlickerControl
{
	public static inline var DEFAULT_STYLE:String = 'default-screen-style';
	
	private var _isAnimated:Bool = false;
	public var isAnimated(get, never):Bool;
	private function get_isAnimated() : Bool {
		return _isAnimated;
	}
	
	public var id(default, null):String;
	public var index(default, null):Int;
	
	public function new(?elementData:ElementData) 
	{
		if (elementData == null)
			elementData = new ElementData({'name':'screen'});
		super(elementData);
		addEventListener(Event.TRANSITION_IN_START, transitionInStart);
		addEventListener(Event.TRANSITION_IN_COMPLETE, transitionInComplete);
		addEventListener(Event.TRANSITION_OUT_START, transitionOutStart);
		addEventListener(Event.TRANSITION_OUT_COMPLETE, transitionOutComplete);
		styleName = DEFAULT_STYLE;
	}
	
	/*private function hideScrollBars(children:Array<DisplayObject>) : Void {
		for (child in children) {
			if (Std.is(child, ScrollPlane)) {
				var sPlane:ScrollPlane = cast child;
				if (sPlane != null)
					sPlane.hideScrollBars();
			}
			hideScrollBars(child.children);
		}
	}
	
	private function showScrollBars(children:Array<DisplayObject>) : Void {
		for (child in children) {
			if (Std.is(child, ScrollPlane)) {
				var sPlane:ScrollPlane = cast child;
				if (sPlane != null)
					sPlane.showScrollBars();
			}
			showScrollBars(child.children);
		}
	}*/
	
	private function transitionInStart(e:Event) : Void {
		_isAnimated = true;
		e.stopImmediatePropagation();
	}
	
	private function transitionInComplete(e:Event) : Void {
		_isAnimated = false;
		e.stopImmediatePropagation();
	}
	
	private function transitionOutStart(e:Event) : Void {
		_isAnimated = true;
		e.stopImmediatePropagation();
	}
	
	private function transitionOutComplete(e:Event) : Void {
		_isAnimated = false;
		e.stopImmediatePropagation();
	}
	
	public function setId(id:String) : Void
	{
		this.id = id;
	}
	
	public function setIndex(index:Int) : Void
	{
		this.index = index;
	}
	
	public function deactive() : Void {}
	
	public function transitionToScreen(address:String) : Void {}
	
	public override function dispose() : Void
	{
		removeEventListener(Event.TRANSITION_IN_START, transitionInStart);
		removeEventListener(Event.TRANSITION_IN_COMPLETE, transitionInComplete);
		removeEventListener(Event.TRANSITION_OUT_START, transitionOutStart);
		removeEventListener(Event.TRANSITION_OUT_COMPLETE, transitionOutComplete);
		super.dispose();
	}
}
