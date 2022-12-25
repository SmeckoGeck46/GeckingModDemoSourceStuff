package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.system.System;
import lime.utils.Assets;
#if sys
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import openfl.utils.ByteArray;
import lime.media.AudioBuffer;
import flash.media.Sound;
#end
import haxe.Json;
import tjson.TJSON;
using StringTools;
class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Character;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var p1 = PlayState.SONG.player1;
		// hscript means everything is custom
		// and they don't  fucking lose their shit if 
		// they don't have the proper animation
		var daBf:String = p1 + '-dead';
		trace(p1);
		
		super();
		Conductor.songPosition = 0;

		bf = new Character(x, y, daBf, true);
		// : )
		bf.beingControlled = true;
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);
		switch (p1) {
			case "bf", "bf-lego", "bf-pixel":
				if (bf.isPixel)
					stageSuffix = "-pixel";
				FlxG.sound.play('assets/sounds/fnf_loss_sfx' + stageSuffix + TitleState.soundExt);
			default:
				FlxG.sound.play('assets/sounds/fnf_loss_sfx_modified' + TitleState.soundExt);
		}
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				LoadingState.loadAndSwitchState(new StoryMenuState());
			else
				LoadingState.loadAndSwitchState(new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)	{
			switch (PlayState.SONG.song) { //different game over themes for each demo
				case "Vanity" | "Ingoobelyblench" | "Bacon-Cola" | "Edd's-Crappy-Song": //Just Another Eddsworld Mod Demo
					FlxG.sound.playMusic('assets/music/gameOverEdWorm.ogg');
				case 'Star-Walker' | 'Pipis-Song': //The Original Starwalker and Friends Demo
					FlxG.sound.playMusic('assets/music/gameOverStarwalker.ogg');
				case 'Disembodied-Voice' | 'Dismantle' | 'Huni': //VS N Demo
					FlxG.sound.playMusic('assets/music/gameOverDrone.ogg');
				case 'Sugar-and-Spice' | 'Boba' | "There's-Tord": //Friday Night Brickin with General Mayhem Demo + the bonus Tord song
					FlxG.sound.playMusic('assets/music/gameOverMayhem.ogg');
				default: //Anything that isn't previously mentioned
					FlxG.sound.playMusic('assets/music/gameOver' + stageSuffix + '.ogg');
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			switch (PlayState.SONG.song) { //ending jingles for each demo
				case "Vanity" | "Ingoobelyblench" | "Bacon-Cola" | "Edd's-Crappy-Song": //Just Another Eddsworld Mod Demo
					FlxG.sound.play('assets/music/gameOverEdWormEnd' + TitleState.soundExt);
				case 'Star-Walker' | 'Pipis-Song': //The Original Starwalker and Friends Demo
					FlxG.sound.play('assets/music/gameOverStarwalkerEnd' + TitleState.soundExt);
				case 'Disembodied-Voice' | 'Dismantle' | 'Huni': //VS N Demo
					FlxG.sound.play('assets/music/gameOverDroneEnd' + TitleState.soundExt);
				case 'Sugar-and-Spice' | 'Boba' | "There's-Tord": //Friday Night Brickin with General Mayhem Demo + the bonus Tord song
					FlxG.sound.play('assets/music/gameOverMayhemEnd' + TitleState.soundExt);
				default: //Anything that isn't previously mentioned
					FlxG.sound.play('assets/music/gameOverEnd' + stageSuffix + TitleState.soundExt);
			}
			
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
