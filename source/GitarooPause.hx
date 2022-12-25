package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class GitarooPause extends MusicBeatState
{
	var replayButton:FlxSprite;
	var cancelButton:FlxSprite;

	var replaySelect:Bool = false;
	

	public function new():Void
	{
		super();
	}

	override function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		var obamna_SODA = FNFAssets.getSound('assets/music/bishoujoSupamuton' + TitleState.soundExt);
		FlxG.sound.playMusic(obamna_SODA);

		var bg:FlxSprite = new FlxSprite().loadGraphic('assets/images/pauseAlt/pauseBG.png');
		add(bg);

		var bf:FlxSprite = new FlxSprite(0, -50);
		bf.frames = FlxAtlasFrames.fromSparrow('assets/images/pauseAlt/bfLol.png', 'assets/images/pauseAlt/bfLol.xml');
		bf.animation.addByPrefix('lol', "funnyThing", 8);
		bf.setGraphicSize(Std.int(0.75 * bf.width));
		bf.animation.play('lol');
		bf.antialiasing = false; //spampose
		add(bf);
		bf.screenCenter(X);
		trace("SPAMPOSE");

		replayButton = new FlxSprite(FlxG.width * 0.28, FlxG.height * 0.7);
		replayButton.frames = FlxAtlasFrames.fromSparrow('assets/images/pauseAlt/pauseUI.png', 'assets/images/pauseAlt/pauseUI.xml');
		replayButton.animation.addByPrefix('selected', 'bluereplay', 0, false);
		replayButton.animation.appendByPrefix('selected', 'yellowreplay');
		replayButton.animation.play('selected');
		add(replayButton);

		cancelButton = new FlxSprite(FlxG.width * 0.58, replayButton.y);
		cancelButton.frames = FlxAtlasFrames.fromSparrow('assets/images/pauseAlt/pauseUI.png', 'assets/images/pauseAlt/pauseUI.xml');
		cancelButton.animation.addByPrefix('selected', 'bluecancel', 0, false);
		cancelButton.animation.appendByPrefix('selected', 'cancelyellow');
		cancelButton.animation.play('selected');
		add(cancelButton);

		changeThing();

		super.create();
	}

	override function update(elapsed:Float)
	{

		if (controls.LEFT_MENU || controls.RIGHT_MENU)
			changeThing();

		if (controls.ACCEPT)
		{
			if (replaySelect)
			{
				FlxG.sound.music.stop(); //only stops if you restart the level mwa ha ha ha ha
				LoadingState.loadAndSwitchState(new PlayState());
				
			}
			else
			{
				if (PlayState.isStoryMode) { //took this from GameOverState for easier navigation, but the music still plays mwa ha ha ha ha
					LoadingState.loadAndSwitchState(new StoryMenuState());
				} else {
					LoadingState.loadAndSwitchState(new FreeplayState());
				}
			}
		}

		super.update(elapsed);
	}

	function changeThing():Void
	{
		replaySelect = !replaySelect;

		if (replaySelect)
		{
			cancelButton.animation.curAnim.curFrame = 0;
			replayButton.animation.curAnim.curFrame = 1;
		}
		else
		{
			cancelButton.animation.curAnim.curFrame = 1;
			replayButton.animation.curAnim.curFrame = 0;
		}
	}
}
