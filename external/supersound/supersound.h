#include "sound.h"

void se_init(void);
void se_play_sound(SystemSoundID sound_id);
void se_play_sound_random(SystemSoundID* sounds, int max);
void se_play_caf(NSString* name);
void se_play_caf_random(NSArray* names);
