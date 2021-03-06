package com.flicker.controls.super;

import haxe.Constraints.Function;

import com.flicker.layout.params.ILayoutParams;
import com.flicker.controls.super.FlickerControl;
import com.flicker.display.IDisplayObject;
import com.flicker.display.DisplayObject;
import com.flicker.layout.ILayout;
import com.flicker.math.Rectangle;
import com.flicker.display.Stage;
import com.flicker.core.Flicker;

/**
 * @author Evgenii Grebennikov
 */
interface IFlickerControl extends IDisplayObject
{
	public var includeInLayout(get, set) : Bool;
	public var onReposition(get, set):Function;
	public var snapWidth(get, never) : Dynamic;
	public var snapHeight(get, never) : Dynamic;
	private var _snapWidthObject:DisplayObject;
	private var _snapHeightObject:DisplayObject;
	public function snapTo(?width:Dynamic, ?height:Dynamic) : Void;
	public var emitResizeEvents(get, set):Bool;
	public var onResize:ResizeData->Void;
	private var _lastStyleName:String;
	private var _styleName:String;
	public var styleName(get, set) : String;
	private var _lastStyleFactory:Function;
	public var styleFactory(get, set) : Function;
	private function applyStylesIfNeeded() : Void;
	private function updateStyleFactory() : Void;
	public var layout(get,set):ILayout;
	public var layoutParams(get,set):ILayoutParams;
	public var isComplexControl(get, set):Bool;
	//private var _propertiesProxy:PropertiesProxy;
	private function getInvalidData() : Dynamic;
	//private var _layoutRegion:Rectangle;
	public function resize(?data:ResizeData) : Void;
	private function createDelayedBuilder(owner:FlickerControl, content:FlickerControl) : Void;
	public function addDelayedItemFactory(factory:Function, ?owner:FlickerControl, ?content:FlickerControl) : Void;
	private function updateLayout() : Void;
}