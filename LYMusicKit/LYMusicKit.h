#import "LYMusicJukeboxController.h"

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

@interface MPMediaQuery (LYMediaQuery)
- (void)initWithArtist:(NSString*)album album:(NSString*)album title:(NSString*)title;
@end

@implementation MPMediaQuery (LYMediaQuery)
- (void)initWithArtist:(NSString*)album album:(NSString*)album title:(NSString*)title
{
	NSMutableSet* set = [NSMutableSet setWithCapacity:3];

	if (album != nil)
		[set addObject:[MPMediaPropertyPredicate predicateWithValue:album forProperty:MPMediaItemPropertyAlbumTitle]];
	if (artist != nil)
		[set addObject:[MPMediaPropertyPredicate predicateWithValue:artist forProperty:MPMediaItemPropertyArtist]];
	if (title != nil)
		[set addObject:[MPMediaPropertyPredicate predicateWithValue:title forProperty:MPMediaItemPropertyTitle]];

	self = [super initWithFilterPredicates:set];
	return self;
}
@end
