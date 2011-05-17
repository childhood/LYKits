#import "MQMusicJukeboxController.h"

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
	controller_jukebox = [[MQMusicJukeboxController alloc] initWithTitle:@"Music Player" iPod:YES];
	controller_jukebox.navigationBar.topItem.leftBarButtonItem.enabled = NO;
	controller_jukebox.delegate_nav = mainNavigationController;
	controller_jukebox.delegate_window = window;
	[nav_main.view addSubview:controller_jukebox.view];
 *
 */
