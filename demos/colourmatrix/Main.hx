package demos.colourmatrix;

import pixi.text.Text;
import pixi.InteractionData;
import pixi.display.DisplayObjectContainer;
import pixi.filters.ColorMatrixFilter;
import js.Browser;
import pixi.renderers.webgl.WebGLRenderer;
import pixi.display.Sprite;
import pixi.display.Stage;
import pixi.utils.Detector;
import js.Browser;

class Main {

	var _bg:Sprite;
	var _colorMatrix:Array<Float>;
	var _container:DisplayObjectContainer;
	var _filter:ColorMatrixFilter;

	var _bgFront:Sprite;
	var _light1:Sprite;
	var _light2:Sprite;
	var _panda:Sprite;

	var _count:Float;
	var _switchy:Bool;
	var _renderer:WebGLRenderer;
	var _stage:Stage;

	public function new() {
		_stage = new Stage(0x003366);
		_stage.interactive = true;

		_renderer = Detector.autoDetectRenderer(Browser.window.innerWidth, Browser.window.innerHeight);
		Browser.document.body.appendChild(_renderer.view);

		_bg = Sprite.fromImage("assets/filters/BGrotate.jpg");
		_bg.anchor.set(0.5, 0.5);
		_bg.x = Browser.window.innerWidth / 2;
		_bg.y = Browser.window.innerHeight / 2;

		_colorMatrix =  [1,0,0,0,
						0,1,0,0,
						0,0,1,0,
						0,0,0,1];


		_filter = new ColorMatrixFilter();

		_container = new DisplayObjectContainer();
		_container.x = Browser.window.innerWidth / 2;
		_container.y = Browser.window.innerHeight / 2;

		_bgFront = Sprite.fromImage("assets/filters/SceneRotate.jpg");
		_bgFront.anchor.set(0.5, 0.5);

		_container.addChild(_bgFront);

		_light2 = Sprite.fromImage("assets/filters/LightRotate2.png");
		_light2.anchor.set(0.5, 0.5);
		_container.addChild(_light2);

		_light1 = Sprite.fromImage("assets/filters/LightRotate1.png");
		_light1.anchor.set(0.5, 0.5);
		_container.addChild(_light1);

		_panda =  Sprite.fromImage("assets/filters/panda.png");
		_panda.anchor.set(0.5, 0.5);

		_container.addChild(_panda);
		_stage.addChild(_container);

		_count = 0;
		_switchy = false;
		_stage.filters = [_filter];

		_stage.click = _stage.tap = _onClick;

		var style:TextStyle = {font: "bold 12pt Arial", fill: "#FFFFFF"};
		var help = new Text("Click to turn filters on / off.", style);
		_stage.addChild(help);

		Browser.window.requestAnimationFrame(cast animate);
	}

	function _onClick(data:InteractionData) {
		_switchy = !_switchy;
		if (!_switchy) _stage.filters = [_filter];
		else _stage.filters = null;
	}

	function animate() {
		Browser.window.requestAnimationFrame(cast animate);
		_count += 0.01;

		_bg.rotation += 0.01;
		_bgFront.rotation -= 0.01;

		_light1.rotation += 0.02;
		_light2.rotation += 0.01;

		_panda.scale.x = 1 + Math.sin(_count) * 0.04;
		_panda.scale.y = 1 + Math.cos(_count) * 0.04;

		_count += 0.1;

		_colorMatrix[1] = Math.sin(_count) * 3;
		_colorMatrix[2] = Math.cos(_count);
		_colorMatrix[3] = Math.cos(_count) * 1.5;
		_colorMatrix[4] = Math.sin(_count / 3) * 2;
		_colorMatrix[5] = Math.sin(_count / 2);
		_colorMatrix[6] = Math.sin(_count / 4);
		_filter.matrix = _colorMatrix;
		_renderer.render(_stage);
	}

	static function main() {
		new Main();
	}
}