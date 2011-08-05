#import <MediaPlayer/MediaPlayer.h>
#import "LYMusicJukeboxController.h"
#import "LYKits.h"

/*
 * Usage of Music Jukebox
 *
	The following frameworks are needed:
		AVFoundation
		AudioToolbox
		MediaPlayer
		...
 * 
 * exmaple
 *
	controller_jukebox = [[LYMusicJukeboxController alloc] initWithTitle:@"Music Player" iPod:YES];
	controller_jukebox.navigationBar.topItem.leftBarButtonItem.enabled = NO;
	controller_jukebox.delegate_nav = mainNavigationController;
	controller_jukebox.delegate_window = window;
	[nav_main.view addSubview:controller_jukebox.view];
 *
 */

//	TODO: move tested codes elsewhere

@interface LYMusicPlayer: NSObject <MPMediaPickerControllerDelegate>
{
	MPMediaPickerController*	controller_player_picker;
	MPMusicPlayerController*	player;
	NSMutableDictionary*		data;
}
@property (nonatomic, retain) NSMutableDictionary*	data;

- (void)set_playlist_table:(UITableView*)table;
- (void)set_artwork:(UIImageView*)image;
- (void)set_buttons_play:(UIButton*)play prev:(UIButton*)prev next:(UIButton*)next shuffle:(UIButton*)shuffle repeat:(UIButton*)repeat;
- (void)set_sliders_progress:(UISlider*)progress volume:(UISlider*)volume;
- (void)playlist_add;
- (void)player_play;
- (void)player_prev;
- (void)player_next;
- (void)player_shuffle;
- (void)player_repeat;
- (void)reload;
- (void)player_progress_timer;
- (void)player_progress_change;
- (void)player_item_changed:(NSNotification*)notification;
- (void)player_volume_changed:(NSNotification*)notification;
- (void)player_volume_change;

@end

#if 0
@interface MPMediaQuery (LYMediaQuery)
- (id)initWithArtist:(NSString*)album album:(NSString*)album title:(NSString*)title;
@end

@implementation MPMediaQuery (LYMediaQuery)
- (id)initWithArtist:(NSString*)artist album:(NSString*)album title:(NSString*)title
{
	NSMutableSet* set = [NSMutableSet setWithCapacity:3];

	if (album != nil)
		[set addObject:[MPMediaPropertyPredicate predicateWithValue:album forProperty:MPMediaItemPropertyAlbumTitle]];
	if (artist != nil)
		[set addObject:[MPMediaPropertyPredicate predicateWithValue:artist forProperty:MPMediaItemPropertyArtist]];
	if (title != nil)
		[set addObject:[MPMediaPropertyPredicate predicateWithValue:title forProperty:MPMediaItemPropertyTitle]];

	return self;
}
@end
#endif
