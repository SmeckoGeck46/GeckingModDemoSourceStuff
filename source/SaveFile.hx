package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import lime.system.System;
#if sys
import sys.io.File;
import haxe.io.Path;
import openfl.utils.ByteArray;
import flash.display.BitmapData;
#end
import haxe.Json;
import haxe.format.JsonParser;
class SaveFile extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var save:FlxSprite;
	public var loadSprite:FlxSprite;
	public var leftArrow:FlxSprite;
	public var rightArrow:FlxSprite;
	public var deleteConfirm:FlxSprite;
	public var erasedSprite:FlxSprite;
	public var beingSelected:Bool = false;
	public var askingToConfirm:Bool = false;
	public var selectingLoad:Bool = true;
	public var playerIcon:HealthIcon;
	public var iconColors:Array<FlxColor> = [
		FlxColor.fromRGB(49, 176, 209),
		FlxColor.fromRGB(233, 255, 72),
		FlxColor.fromRGB(123, 214, 246),
		FlxColor.fromRGB(213, 126, 0),
		FlxColor.fromRGB(175, 102, 206),
		FlxColor.fromRGB(183, 216, 85),
		FlxColor.fromRGB(216, 85, 142),
		FlxColor.fromRGB(165, 0, 77),
		FlxColor.fromRGB(243, 255, 110),
		FlxColor.fromRGB(255, 170, 111)
	];
	public function new(x:Float, y:Float, saveNum:Int = 0)
	{
		super(x, y);
		var tex = FlxAtlasFrames.fromSparrow('assets/images/save-data.png', 'assets/images/save-data.xml');
		selectingLoad = true;
		targetY = saveNum;
		save = new FlxSprite();
		save.frames = tex;
		save.setGraphicSize(Std.int(save.width * 3));
		leftArrow = new FlxSprite(350, 280);
		leftArrow.frames = tex;
		leftArrow.setGraphicSize(Std.int(leftArrow.width * 2));
		rightArrow = new FlxSprite(60, leftArrow.y);
		rightArrow.frames = tex;
		rightArrow.setGraphicSize(Std.int(rightArrow.width * 2));
		deleteConfirm = new FlxSprite(350, 100);
		loadSprite = new FlxSprite(leftArrow.x + leftArrow.width, leftArrow.y);
		loadSprite.frames = tex;

		loadSprite.setGraphicSize(Std.int(loadSprite.width * 2));
		deleteConfirm.frames = tex;
		deleteConfirm.setGraphicSize(Std.int(deleteConfirm.width * 1.5));
		erasedSprite = new FlxSprite(200, 100);
		erasedSprite.frames = tex;
		save.animation.addByPrefix('default', 'save file', 24);
		loadSprite.animation.addByPrefix('load', 'load', 24);
		loadSprite.animation.addByPrefix('delete', 'deletea', 24);
		leftArrow.animation.addByPrefix('default', 'left arrow', 24);
		rightArrow.animation.addByPrefix('default', 'right arrow', 24);
		deleteConfirm.animation.addByPrefix('default', 'delete confirm', 24);
		erasedSprite.animation.addByPrefix('default', 'deleted', 24);
		var iconType = '';
		switch (saveNum) {
			case 0:
				iconType = 'bf-lego';
				save.color = iconColors[0];
			case 1:
				iconType = 'geckMatt';
				save.color = iconColors[1];
			case 2:
				iconType = 'geckTom';
				save.color = iconColors[2];
			case 3:
				iconType = 'geckEdd';
				save.color = iconColors[3];
			case 4:
				iconType = 'geckTord3';
				save.color = iconColors[4];
			case 5:
				iconType = 'starwalker';
				save.color = iconColors[5];
			case 6:
				iconType = 'pipis';
				save.color = iconColors[6];
			case 7:
				iconType = 'n-normal';
				save.color = iconColors[7];
			case 8:
				iconType = 'mayhemMasked';
				save.color = iconColors[8];
			case 9:
				iconType = 'dad';
				save.color = iconColors[9];
		}
		playerIcon = new HealthIcon(iconType, false);
		playerIcon.setGraphicSize(Std.int(playerIcon.width * 2));
		playerIcon.updateHitbox();
		playerIcon.y += 70;
		playerIcon.x += 20;
		add(save);
		save.antialiasing = true;
		loadSprite.antialiasing = true;
		leftArrow.antialiasing = true;
		rightArrow.antialiasing = true;
		deleteConfirm.antialiasing = true;
		erasedSprite.antialiasing = true;
		add(loadSprite);
		add(leftArrow);
		add(rightArrow);
		add(deleteConfirm);
		add(erasedSprite);
		add(playerIcon);
		save.animation.play('default');
		save.animation.pause();
		loadSprite.animation.play('load');
		loadSprite.animation.pause();
		save.updateHitbox();
		loadSprite.updateHitbox();
		leftArrow.animation.play('default');
		leftArrow.animation.pause();
		leftArrow.updateHitbox();
		rightArrow.animation.play('default');
		rightArrow.animation.pause();
		rightArrow.updateHitbox();
		deleteConfirm.animation.play('default');
		deleteConfirm.animation.pause();
		deleteConfirm.updateHitbox();
		erasedSprite.animation.play('default');
		erasedSprite.animation.pause();
		erasedSprite.updateHitbox();
		erasedSprite.visible = false;
		deleteConfirm.visible = false;
		loadSprite.x = leftArrow.x + leftArrow.width;
		rightArrow.x = loadSprite.x + loadSprite.width;
		loadSprite.alpha = 0.5;
		rightArrow.alpha = 0.5;
		leftArrow.alpha = 0.5;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		y = FlxMath.lerp(y, 150 + (targetY * 420), 0.17 / (CoolUtil.fps / 60));
	}
	public function askToConfirm(?turnOn:Bool = true) {
		deleteConfirm.visible = turnOn;
		askingToConfirm = turnOn;
		erasedSprite.visible = false;
		if (turnOn) {
			playerIcon.animation.curAnim.curFrame = 1;
		} else {
			playerIcon.animation.curAnim.curFrame = 0;
		}
	}
	public function beSelected(?selected:Bool = true) {
		if (selected) {
			beingSelected = true;
			loadSprite.alpha = 1;
			rightArrow.alpha = 1;
			leftArrow.alpha = 1;
		}	else {
			beingSelected = false;
			loadSprite.alpha = 0.5;
			rightArrow.alpha = 0.5;
			leftArrow.alpha = 0.5;
		}

	}
	public function changeSelection() {
		if (selectingLoad) {
			loadSprite.animation.play('delete');
			selectingLoad = false;
			loadSprite.updateHitbox();
			leftArrow.x = 350 + 400;
			loadSprite.x = leftArrow.x + leftArrow.width;
			rightArrow.x = loadSprite.x + loadSprite.width;
		}	else {
			loadSprite.animation.play('load');
			selectingLoad = true;
			loadSprite.updateHitbox();
			leftArrow.x = 300+ 450;
			loadSprite.x = leftArrow.x + leftArrow.width;
			rightArrow.x = loadSprite.x + loadSprite.width;
		}

	}
}
