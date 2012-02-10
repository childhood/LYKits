#import <MediaPlayer/MediaPlayer.h>
#import "LYMusicJukeboxController.h"
#import "LYImage.h"
#import "LYKits.h"

/*
 * Usage of Music Jukebox
 *
	The following frameworks are needed:
		AVFoundation
		AudioToolbox
		MediaPlayer
		...

	music_player = [[LYMusicPlayer alloc] init];
	LYTableViewProvider* the_provider = [music_player.data v:@"playlist-provider"];
	the_provider.cell_bg = @"table-cell-bg-clean.png";
	the_provider.cell_bg_selected = @"table-cell-bg-clean-on.png";
	the_provider.cell_height = 48;
	[the_provider.data key:@"accessory-size" v:NSStringFromCGSize(CGSizeMake(22, 22))];
	[the_provider.footers addObject:@"Swipe to delete."];
	[music_player.data key:@"delegate" v:self];
	[music_player.data key:@"controller-navigation" v:nav_playlist];
	[music_player.data key:@"controller-playlist" v:controller_player_playlist];
	[music_player.data key:@"player-title" v:label_player_title];
	[music_player.data key:@"player-artist" v:label_player_artist];
	[music_player.data key:@"player-album" v:label_player_album];
	[music_player.data key:@"player-played" v:label_player_progress];
	[music_player.data key:@"player-remaining" v:label_player_remaining];
	[music_player.data key:@"player-reflection" v:image_player_reflection];
	[music_player.data key:@"default-title" v:@"No Track Playing"];
	[music_player.data key:@"default-artist" v:@"Swipe up to show tabs"];
	[music_player.data key:@"default-album" v:@"and select a playlist"];
	[music_player.data key:@"default-artwork" v:@"Default.png"];
	[music_player.data key:@"provider-accessory" v:@"music_play_player.png"];
	[music_player set_artwork:image_player_artwork];
	[music_player set_playlist_table:table_player_playlist];
	[music_player set_buttons_play:button_player_play
							  prev:button_player_prev
							  next:button_player_next
						   shuffle:nil		//button_player_shuffle
							repeat:nil];	//button_player_repeat];
	[music_player set_sliders_progress:slider_player_progress
								volume:slider_player_volume];

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

- (void)sync;
- (void)play_all;
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
- (void)save_backup;
- (void)load_backup;

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
