package ru.ice.display;

import js.Browser;

import ru.ice.display.DOMObject;
import ru.ice.events.FingerEvent;
import ru.ice.events.EventDispatcher;
import ru.ice.display.Sprite;
import ru.ice.data.ElementData;
import ru.ice.math.Rectangle;
import ru.ice.animation.Animator;
import ru.ice.core.FpsStats;
import ru.ice.events.Event;
import ru.ice.math.Point;
import ru.ice.core.Ice;

/**
 * ...
 * @author Evgenii Grebennikov
 */
class Stage extends Sprite
{
	private var _debugLayer:Sprite;
	
	private var _contentLayer:Sprite;
	
	private var _fpsStats:FpsStats;
	/**
	 * Включает отображение статистики fps
	 */
	private var _useStats:Bool = false;
	public var useStats(get, set) : Bool;
	private function set_useStats(v:Bool):Bool
	{
		if (v != _useStats) {
			_useStats = v;
			if (v)
				addStats();
			else
				removeStats();
		}
		return get_useStats();
	}
	private function get_useStats():Bool {
		return _useStats;
	}
	/**
	 * Ссылка на экземпляр аниматора
	 */
	public static var animator:Animator;
	/**
	 * Ссылка на экземпляр стейджа
	 */
	public static var current:Stage;
	
	private var _tickLength:Float = 0;
	/**
	 * Время обновления кадра
	 */
	public var tickLength(get, never):Float;
	private function get_tickLength():Float {
		return _tickLength;
	}
	
	private var _realPassedTime:Float = 0;
	/**
	 * Реальное время обновления текущего кадра
	 * passedTime не может принимать значения меньшие чем у tickLength!
	 */
	public var realPassedTime(get, never):Float;
	private function get_realPassedTime():Float {
		return _realPassedTime;
	}
	
	private var _passedTime:Float = 0;
	/**
	 * Время обновления текущего кадра
	 */
	public var passedTime(get, never):Float;
	private function get_passedTime():Float {
		return _passedTime;
	}
	
	private var _fps:Float = 60;
	/**
	 * Число кадров в секунду
	 */
	public var fps(get, set):Float;
	private function get_fps() : Float {
		return _fps;
	}
	private function set_fps(v:Float) : Float {
		if (Math.isNaN(v) || v < 1)
			v = 1;
		_fps = v;
		_tickLength = 1 / _fps;
		return get_fps();
	}
	
	private var _lastFramePassedTime:Float = 0;
	
	public var viewport(get, never):Rectangle;
	private function get_viewport():Rectangle {
		return new Rectangle(0, 0, width, height);
	}
	
	private var _currentTarget:EventDispatcher;
	public var currentTarget(get, set):EventDispatcher;
	private function get_currentTarget():EventDispatcher {
		return _currentTarget;
	}
	private function set_currentTarget(v:EventDispatcher) : EventDispatcher {
		if (_currentTarget != v && v != null)
			_currentTarget = v;
		return get_currentTarget();
	}
	
	public function new(?elementData:ElementData, ?fps:Float) 
	{
		fps = fps != null ? fps : 60;
		animator = new Animator();
		super(elementData);
		Browser.document.body.appendChild(element);
		
		_contentLayer = new Sprite(new ElementData({'name':'native', 'touchable':false}));
		super.addChild(_contentLayer);
		
		current = this;
		updateFrame(Date.now().getTime());
		
		Browser.window.onresize = resizeWindow;
		resizeWindow();
	}
	
	public function add(child:DisplayObject) : DisplayObject {
		return _contentLayer.addChild(child);
	}
	
	public function remove(child:DisplayObject) : DisplayObject {
		return _contentLayer.removeChild(child);
	}
	
	private function resizeWindow() : Void
	{
		setSize(Browser.window.innerWidth, Browser.window.innerHeight);
	}
	
	private function addStats() : Void
	{
		if (_debugLayer == null) {
			_debugLayer = new Sprite(new ElementData({'name':'overlay', 'touchable':false}));
			super.addChild(_debugLayer);
		}
		if (_fpsStats == null) {
			_fpsStats = new FpsStats();
			_debugLayer.addChild(_fpsStats);
		}
	}
	
	private function removeStats() : Void
	{
		if (_fpsStats != null) {
			_fpsStats.removeFromParent(true);
			_fpsStats = null;
		}
	}
	
	private var _mouseEvent:FingerEvent;
	
	@:allow(ru.ice.display.DisplayObject)
	private function sMove(e:FingerEvent) : Void {
		_mouseEvent = e;
	}
	
	private function updateFrame(?t:Float) : Void
	{
		var now:Float = t / 1000;
		_passedTime = now - _lastFramePassedTime;
		_realPassedTime = _passedTime;
		_lastFramePassedTime = now;
		if (_passedTime < _tickLength)
			_passedTime = _tickLength;
		render();
		Browser.window.requestAnimationFrame(updateFrame);
	}
	
	public override function setSize(width:Float, height:Float) : Void
	{
		this.width = width;
		this.height = height;
		dispatchEventWith(Event.RESIZE, true);
	}
	
	public function render() : Void
	{
		animator.update(_passedTime);
		updateChildren(this);
	}
	
	private function updateChildren(obj:DisplayObject) : Void
	{
		var m:FingerEvent = null;
		if (_mouseEvent != null) {
			if (_mouseEvent.isStopedPropagation)
				_mouseEvent = null;
			m = _mouseEvent;
			if (!obj.touchable)
				m = null;
		}
		if (obj != null) {
			for (child in obj.children) {
				updateChildren(child);
			}
			if (m != null)
				obj.mouseMove(m);
			obj.update();
		}
		if (obj == this)
			_mouseEvent = null;
	}
	
	public override function dispose() : Void
	{
		removeStats();
		
		_currentTarget = null;
		
		if (_contentLayer != null) {
			_contentLayer.removeFromParent(true);
			_contentLayer = null;
		}
		if (_debugLayer != null) {
			_debugLayer.removeFromParent(true);
			_debugLayer = null;
		}
		super.dispose();
	}
}
