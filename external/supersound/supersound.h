#include "sound.h"

#define	supersound_bgm_start()		se_StartBackgroundMusic()
#define supersound_bgm_stop()		se_StopBackgroundMusic(false)
#define supersound_bgm_volume(f)	se_SetBackgroundMusicVolume(f)
#define supersound_se_volume(f)		se_SetEffectsVolume(f);

void se_init(void);
void se_play_sound(SystemSoundID sound_id);
void se_play_sound_random(SystemSoundID* sounds, int max);
void se_play_caf(NSString* name);
void se_play_caf_random(NSArray* names);
void supersound_bgm_play(NSString* name);
