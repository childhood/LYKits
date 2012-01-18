#include "supersound.h"

void se_init(void)
{
	se_Initialize(44100);
	se_SetListenerPosition(0.0, 0.0, 1.0);
}

void se_play_sound(SystemSoundID sound_id)
{
	se_StartEffect(sound_id);
}

void se_play_sound_random(SystemSoundID* sounds, int max)
{
	int index = rand() % max;

	se_StartEffect(sounds[index]);
}

void se_play_caf(NSString* name)
{
	NSBundle*		bundle = [NSBundle mainBundle];
	SystemSoundID	sound_id;

	//	NSLog(@"playing %@", [bundle pathForResource:name ofType:@"caf"]);
	se_LoadEffect([[bundle pathForResource:name ofType:@"caf"] UTF8String], &sound_id);
	se_StartEffect(sound_id);
	se_UnloadEffect(sound_id);
}

void se_play_caf_random(NSArray* names)
{
	int index = rand() % names.count;

	se_play_caf([names objectAtIndex:index]);
}

void supersound_bgm_play(NSString* name)
{
	NSBundle*		bundle = [NSBundle mainBundle];

	//	NSLog(@"playing %@", [bundle pathForResource:name ofType:@"caf"]);
	se_LoadBackgroundMusicTrack([[bundle pathForResource:name ofType:@"caf"] UTF8String], false, false);
	se_StartBackgroundMusic();
}
