#import "LYMusicKit.h"

@implementation LYMusicPlayer

@synthesize data;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		//	init player
#if TARGET_IPHONE_SIMULATOR
		player = nil;
#else
		player = [MPMusicPlayerController iPodMusicPlayer];
		//player = [MPMusicPlayerController applicationMusicPlayer];
		player.shuffleMode = MPMusicShuffleModeOff;
		player.repeatMode = MPMusicRepeatModeNone;
		NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter addObserver:self
							   selector:@selector(player_item_changed:)
								   name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
								 object:player];
		[notificationCenter addObserver:self
							   selector:@selector(player_state_changed:)
								   name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
								 object:player];
		[notificationCenter addObserver:self
							   selector:@selector(player_volume_changed:)
								   name:MPMusicPlayerControllerVolumeDidChangeNotification
								 object:player];
		[player beginGeneratingPlaybackNotifications];
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
#endif

		//	init data
		data = [[NSMutableDictionary alloc] init];
		[data key:@"delegate" v:nil];
		[data key:@"player" v:player];
		[data key:@"playlist-items" v:[NSMutableArray array]];
		[data key:@"playlist-changed" v:[NSNumber numberWithBool:NO]];
		[data key:@"controller-navigation" v:nil];
		[data key:@"controller-playlist" v:nil];
		[data key:@"controller-picker" v:nil];
		[data key:@"media-music" v:nil];
		[data key:@"provider-accessory" v:@"checkmark"];
		//	buttons
		[data key:@"player-play" v:nil];
		[data key:@"player-prev" v:nil];
		[data key:@"player-next" v:nil];
		[data key:@"player-shuffle" v:nil];
		[data key:@"player-repeat" v:nil];
		[data key:@"player-progress" v:nil];
		[data key:@"player-volume" v:nil];
		//	info
		[data key:@"player-title" v:nil];
		[data key:@"player-artist" v:nil];
		[data key:@"player-album" v:nil];
		[data key:@"player-played" v:nil];
		[data key:@"player-remaining" v:nil];
		//	sliders
		[data key:@"player-progress" v:nil];
		[data key:@"player-volume" v:nil];
		//	text
		[data key:@"default-title" v:@""];
		[data key:@"default-artist" v:@""];
		[data key:@"default-album" v:@""];

		LYTableViewProvider* provider = [[LYTableViewProvider alloc] initWithStyle:UITableViewStylePlain];
		provider.delegate = self;
		provider.cell_height = 48;
		provider.can_edit = YES;
		//[provider.data key:@"move-enabled" v:[NSNumber numberWithBool:YES]];
		[provider.data key:@"source-data" v:[data v:@"playlist-items"]];
		[provider.texts addObject:[NSMutableArray array]];
		[provider.details addObject:[NSMutableArray array]];
		[provider.accessories addObject:[NSMutableArray array]];
		[data key:@"playlist-provider" v:provider];
		[provider release];

		//	NSLog(@"data: %@", data);
		NSTimer* timer_progress = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self 
																 selector:@selector(player_progress_timer) 
																 userInfo:nil repeats:YES];
		[timer_progress fire];
		[self sync];
		[self load_backup];
	}
	return self;
}

- (void)dealloc
{
	[data release];
	[super dealloc];
}

- (void)sync
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	for (MPMediaItem* item in [MPMediaQuery songsQuery].items)
	{
		NSString* s = [NSString stringWithFormat:@"%@\n%@",
						  [item valueForProperty:MPMediaItemPropertyTitle],
						  [item valueForProperty:MPMediaItemPropertyArtist]];
		[dict setObject:item forKey:s];
	}
	[data key:@"media-music" v:dict];
	//	[data key:@"media-music" v:[MPMediaQuery songsQuery].items];
	//	NSLog(@"music: %@", [data v:@"media-music"]);
}

- (void)play_all
{
	player.shuffleMode = MPMusicShuffleModeSongs;
	player.repeatMode = MPMusicRepeatModeAll;
	[self mediaPicker:nil didPickMediaItems:[MPMediaItemCollection collectionWithItems:[MPMediaQuery songsQuery].items]];
	[self player_play];
}

- (void)set_artwork:(UIImageView*)image
{
	{
		UITapGestureRecognizer* gesture;

		gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(player_play)];
		gesture.numberOfTapsRequired = 1;
		gesture.numberOfTouchesRequired = 2;
		[image addGestureRecognizer:gesture];
		[gesture release];
	}
	{
		UISwipeGestureRecognizer* gesture;

		gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(player_prev)];
		gesture.direction = UISwipeGestureRecognizerDirectionRight;
		[image addGestureRecognizer:gesture];
		[gesture release];

		gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(player_next)];
		gesture.direction = UISwipeGestureRecognizerDirectionLeft;
		[image addGestureRecognizer:gesture];
		[gesture release];

		gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(player_volume_up)];
		gesture.direction = UISwipeGestureRecognizerDirectionUp;
		[image addGestureRecognizer:gesture];
		[gesture release];

		gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(player_volume_down)];
		gesture.direction = UISwipeGestureRecognizerDirectionDown;
		[image addGestureRecognizer:gesture];
		[gesture release];

#if 0
		gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(push_playlist)];
		gesture.direction = UISwipeGestureRecognizerDirectionLeft;
		gesture.numberOfTouchesRequired = 2;
		[image addGestureRecognizer:gesture];
		[gesture release];
#endif

#if 0
		gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(playlist_add)];
		gesture.direction = UISwipeGestureRecognizerDirectionUp;
		gesture.numberOfTouchesRequired = 2;
		[image addGestureRecognizer:gesture];
		[gesture release];
#endif
	}

	[data key:@"player-artwork" v:image];
}

- (void)debug_playlist_items
{
#if 0
	for (MPMediaItem* item in [data v:@"playlist-items"])
	{
		NSLog(@"title:\t%@", [item valueForProperty:MPMediaItemPropertyTitle]);
		NSLog(@"artist:\t%@", [item valueForProperty:MPMediaItemPropertyArtist]);
	}
#endif
}

- (void)reload
{
	//	remove duplicate
	BOOL duplicate;
	NSMutableArray* array = [NSMutableArray array];
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	//for (MPMediaItem* item_old in [data v:@"playlist-items"])
	NSLog(@"PLAYER reload begin");
	for (NSDictionary* item_old in [data v:@"playlist-items"])
	{
#if 1
		//duplicate = [array containsObject:item_old];
		duplicate = ([dict v:[NSString stringWithFormat:@"%@\n%@", [item_old v:@"title"], [item_old v:@"artist"]]] == [NSNull null]);
#else
		duplicate = NO;
		//for (MPMediaItem* item_new in array)
		for (NSDictionary* item_new in array)
		{
			//	if ([[item_old valueForProperty:MPMediaItemPropertyPersistentID] longValue] ==
			//		[[item_new valueForProperty:MPMediaItemPropertyPersistentID] longValue])
			if ([[item_old v:@"title"] is:[item_new v:@"title"]] &&
				[[item_old v:@"artist"] is:[item_new v:@"artist"]])
			{
				duplicate = YES;
				break;
			}
		}
#endif
		if (duplicate == NO)
		{
			[dict key:[NSString stringWithFormat:@"%@\n%@", [item_old v:@"title"], [item_old v:@"artist"]] v:[NSNull null]];
			[array addObject:item_old];
		}
	}
	NSLog(@"PLAYER reload end");
	[[data v:@"playlist-items"] removeAllObjects];
	[[data v:@"playlist-items"] addObjectsFromArray:array];
	NSLog(@"xx1");
	
	//	add items
	BOOL changed = NO;
	LYTableViewProvider* provider = [data v:@"playlist-provider"];
	[[provider.texts objectAtIndex:0] removeAllObjects];
	[[provider.details objectAtIndex:0] removeAllObjects];
	[provider.data key:@"source-data" v:[data v:@"playlist-items"]];
	//for (MPMediaItem* item in [data v:@"playlist-items"])
	int index = 1;
	for (NSDictionary* item in [data v:@"playlist-items"])
	{
#if 0
		if ([[provider.texts objectAtIndex:0] containsObject:[item valueForProperty:MPMediaItemPropertyTitle]])
			if ([[provider.details objectAtIndex:0] containsObject:[item valueForProperty:MPMediaItemPropertyArtist]])
				continue;
#endif
		//[[provider.texts objectAtIndex:0] addObject:[item valueForProperty:MPMediaItemPropertyTitle]];
		//[[provider.details objectAtIndex:0] addObject:[item valueForProperty:MPMediaItemPropertyArtist]];
		if ([item v:@"title"] != nil)
			[[provider.texts objectAtIndex:0] addObject:[NSString stringWithFormat:@"%i. %@", index, [item v:@"title"]]];
		else
			[[provider.texts objectAtIndex:0] addObject:[NSString stringWithFormat:@"%i. %@", index, @"Unknown Title"]];
		if ([item v:@"artist"] != nil)
			[[provider.details objectAtIndex:0] addObject:[item v:@"artist"]];
		else
			[[provider.details objectAtIndex:0] addObject:@"Unknown Artist"];
		[[provider.accessories objectAtIndex:0] addObject:@"none"];
		changed = YES;
		index++;
	}
	[[data v:@"playlist-table"] reloadData];
	if (changed == YES)
	{
		[data key:@"playlist-changed" v:[NSNumber numberWithBool:YES]];
		[player stop];
	}
	[self save_backup];
}

- (void)save_backup
{
	[[data v:@"playlist-items"] writeToFile:[@"ly-musicplayer-playlist-autosave.xml" filename_private] atomically:YES];
}

- (void)load_backup
{
	if ([@"ly-musicplayer-playlist-autosave.xml" file_exists])
	{
		[[data v:@"playlist-items"] setArray:[NSMutableArray arrayWithContentsOfFile:
			[@"ly-musicplayer-playlist-autosave.xml" filename_private]]];
		[self reload];
	}
}

- (void)set_playlist_table:(UITableView*)table
{
	LYTableViewProvider* provider = [data v:@"playlist-provider"];
	provider.view = table;
	table.delegate = provider;
	table.dataSource = provider;
	[data key:@"playlist-table" v:table];

	UISwipeGestureRecognizer* gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pop_playlist)];
	gesture.direction = UISwipeGestureRecognizerDirectionRight;
	gesture.numberOfTouchesRequired = 2;
	[table addGestureRecognizer:gesture];
	[gesture release];
}

#pragma mark action

- (void)playlist_add
{
	controller_player_picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
	if (controller_player_picker != nil)
	{
		[data key:@"controller-picker" v:controller_player_picker];
		controller_player_picker.title = @"Music Library";
		controller_player_picker.allowsPickingMultipleItems = YES;
		controller_player_picker.delegate = self;
		//controller_player_picker.prompt = @"Music Picker";
		[[data v:@"controller-navigation"] presentModalViewController:controller_player_picker animated:YES];
		//[[data v:@"controller-navigation"] pushViewController:controller_player_picker animated:YES];
	}
	else
		[@"Media Not Available" show_alert_message:@"Sorry, Media Picker is not supported on this device."];
}

- (void)set_buttons_play:(UIButton*)play prev:(UIButton*)prev next:(UIButton*)next shuffle:(UIButton*)shuffle repeat:(UIButton*)repeat
{
	if (play != nil)
	{
		[play addTarget:self action:@selector(player_play) forControlEvents:UIControlEventTouchUpInside];
		[data key:@"player-play" v:play];
	}
	if (prev != nil)
	{
		[prev addTarget:self action:@selector(player_prev) forControlEvents:UIControlEventTouchUpInside];
		[data key:@"player-prev" v:prev];
	}
	if (next != nil)
	{
		[next addTarget:self action:@selector(player_next) forControlEvents:UIControlEventTouchUpInside];
		[data key:@"player-next" v:next];
	}
	if (shuffle != nil)
	{
		[shuffle addTarget:self action:@selector(player_shuffle) forControlEvents:UIControlEventTouchUpInside];
		[data key:@"player-shuffle" v:shuffle];
	}
	if (repeat != nil)
	{
		[repeat addTarget:self action:@selector(player_repeat) forControlEvents:UIControlEventTouchUpInside];
		[data key:@"player-repeat" v:repeat];
	}
}

- (void)set_sliders_progress:(UISlider*)progress volume:(UISlider*)volume
{
	if (progress != nil)
	{
		[progress addTarget:self action:@selector(player_progress_change) forControlEvents:UIControlEventValueChanged];
		[data key:@"player-progress" v:progress];
	}
	if (volume != nil)
	{
		[volume addTarget:self action:@selector(player_volume_change) forControlEvents:UIControlEventValueChanged];
		[data key:@"player-volume" v:volume];
	}
	[self player_volume_changed:nil];
}

- (void)player_refresh:(NSArray*)source
{
	NSMutableArray* array = [NSMutableArray array];
	//	NSLog(@"PLAYER refresh begin");
	for (NSDictionary* dict in source)
	{
#if 1
		NSString* s = [NSString stringWithFormat:@"%@\n%@", [dict v:@"title"], [dict v:@"artist"]];
		if ([[data v:@"media-music"] v:s] != nil)
			[array addObject:[[data v:@"media-music"] v:s]];
		/*
		for (MPMediaItem* item in [data v:@"media-music"])
		{
			if (([[dict v:@"title"] is:[item valueForProperty:MPMediaItemPropertyTitle]]) &&
				([[dict v:@"artist"] is:[item valueForProperty:MPMediaItemPropertyArtist]]))
			{
				[array addObject:item];
				break;
			}
		}
		*/
#else
		id obj = [ly alloc_media_item_artist:[dict v:@"artist"] album:nil title:[dict v:@"title"]];
		if (obj != nil)
			[array addObject:obj];
#endif
		//	TODO: remove invalid songs from current playlist
	}
	//	NSLog(@"PLAYER ended");
	if (array.count > 0)
	{
		MPMediaItemCollection* collection = [MPMediaItemCollection collectionWithItems:array];
		[player setQueueWithItemCollection:collection];
		[player play];
	}
	//	NSLog(@"PLAYER play started: %i", player.playbackState);
}

- (void)player_play
{
	UIButton* button = [data v:@"player-play"];
	if (player.playbackState != MPMusicPlaybackStatePlaying)
	{
		if ([[data v:@"playlist-changed"] boolValue] == YES)
		{
			NSLog(@"PLAYER playlist changed");
			if ([[data v:@"playlist-items"] count] > 0)
			{
				if (button != nil)
					button.selected = YES;
				[self player_refresh:[data v:@"playlist-items"]];
			}
			[data key:@"playlist-changed" v:[NSNumber numberWithBool:NO]];
		}
		else
		{
			NSLog(@"PLAYER not playing");
			[player play];
		}
	}
	else
	{
		NSLog(@"PLAYER playing");
		if (button != nil)
			button.selected = NO;
		[player pause];
	}
}

- (void)player_prev
{
	//	NSLog(@"PLAYER previous");
	[player skipToPreviousItem];
}

- (void)player_next
{
	//	NSLog(@"PLAYER next");
	[player skipToNextItem];
}

- (void)player_shuffle
{
	UIButton* button = [data v:@"player-shuffle"];

	if (player.shuffleMode == MPMusicShuffleModeOff)
	{
		player.shuffleMode = MPMusicShuffleModeSongs;
		if (button != nil)
			button.selected = YES;
	}
	else
	{
		player.shuffleMode = MPMusicShuffleModeOff;
		if (button != nil)
			button.selected = NO;
	}
}

- (void)player_repeat
{
	UIButton* button = [data v:@"player-repeat"];

	if (player.repeatMode == MPMusicRepeatModeNone)
	{
		player.repeatMode = MPMusicRepeatModeAll;
		if (button != nil)
			button.selected = YES;
	}
	else
	{
		player.repeatMode = MPMusicRepeatModeNone;
		if (button != nil)
			button.selected = NO;
	}
}

- (void)player_volume_up
{
	if (player.volume < 0.8)
		player.volume += 0.2;
	else
		player.volume = 1;
}

- (void)player_volume_down
{
	if (player.volume > 0.2)
		player.volume -= 0.2;
	else
		player.volume = 0;
}

- (void)push_playlist
{
	if ([data v:@"controller-navigation"] && [data v:@"controller-playlist"])
	   [[data v:@"controller-navigation"] pushViewController:[data v:@"controller-playlist"] animated:YES];
}

- (void)pop_playlist
{
	if ([data v:@"controller-navigation"] && [data v:@"controller-playlist"])
	   [[data v:@"controller-navigation"] popViewControllerAnimated:YES];
}

#pragma mark delegate

- (void)tableView:(UITableView*)table didSelectRowAtIndexPath:(NSIndexPath*)path
{
	int i;
	MPMusicShuffleMode shuffle = player.shuffleMode;
	player.shuffleMode = MPMusicShuffleModeOff;
	NSMutableArray* array = [NSMutableArray arrayWithArray:[data v:@"playlist-items"]];
	NSMutableArray* dest = [NSMutableArray array];
	//[data key:@"playlist-changed" v:[NSNumber numberWithBool:YES]];
	[player stop];
	//	NSLog(@"play %i", path.row);
	//	[self debug_playlist_items];
	for (i = path.row; i < array.count; i++)
		[dest addObject:[array objectAtIndex:i]];
	for (i = 0; i < path.row; i++)
		[dest addObject:[array objectAtIndex:i]];
	[self player_refresh:dest];
	player.shuffleMode = shuffle;
	if ([data v:@"delegate"] != nil)
	   [[data v:@"delegate"] perform_string:@"tableView:didSelectRowAtIndexPath:" with:table with:path];
}

- (void)reload_play
{
	BOOL was_playing = (player.playbackState == MPMusicPlaybackStatePlaying);
	[self reload];
	if (was_playing)
		[self performSelector:@selector(player_play) withObject:nil afterDelay:0.3];
	NSLog(@"was playing: %i", was_playing);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath :(NSIndexPath *)indexPath
{
	if ((tableView == [data v:@"playlist-table"]) && (editingStyle == UITableViewCellEditingStyleDelete))
	{
		//	NSLog(@"deleted: %i, %@", indexPath.row, [data v:@"playlist-items"]);
		[self reload_play];
		[tableView reloadData];
		if ([data v:@"delegate"] != nil)
			if ([[data v:@"delegate"] respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
			   objc_msgSend([data v:@"delegate"], @selector(tableView:commitEditingStyle:forRowAtIndexPath:), tableView, editingStyle, indexPath);
	}
}

- (void)mediaPicker:(MPMediaPickerController*)picker didPickMediaItems:(MPMediaItemCollection*)collection
{
	//	NSLog(@"PICKER items: %@", collection.items);
	for (MPMediaItem* item in collection.items)
	{
		[[data v:@"playlist-items"] addObject:[NSDictionary dictionaryWithObjectsAndKeys:
			[item valueForProperty:MPMediaItemPropertyTitle],
			@"title",
			[item valueForProperty:MPMediaItemPropertyArtist],
			@"artist",
			nil]];
	}
	//	[[data v:@"playlist-items"] addObjectsFromArray:collection.items];
	[[data v:@"controller-navigation"] dismissModalViewControllerAnimated:YES];
	//[[data v:@"controller-navigation"] popViewControllerAnimated:YES];
	[self reload_play];
	[controller_player_picker release];
	if ([data v:@"delegate"] != nil)
	   [[data v:@"delegate"] perform_string:@"mediaPicker:didPickMediaItems:" with:picker with:collection];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController*)picker
{
	NSLog(@"PICKER cancelled");
	[[data v:@"controller-navigation"] dismissModalViewControllerAnimated:YES];
	//[[data v:@"controller-navigation"] popViewControllerAnimated:YES];
	[controller_player_picker release];
	if ([data v:@"delegate"] != nil)
	   [[data v:@"delegate"] perform_string:@"mediaPickerDidCancel:" with:picker];
}

- (void)player_item_changed:(NSNotification*)notification
{
#if 1
	UILabel* label_title	= [data v:@"player-title"];
	UILabel* label_artist	= [data v:@"player-artist"];
	UILabel* label_album	= [data v:@"player-album"];
	UIImageView* artwork	= [data v:@"player-artwork"];
	UIImageView* reflection	= [data v:@"player-reflection"];
	if (label_title != nil)
	{
		label_title.text = [player.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
		if (label_title.text == nil)
			label_title.text = [data v:@"default-title"];
	}
	if (label_artist != nil)
	{
		label_artist.text = [player.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
		if (label_artist.text == nil)
			label_artist.text = [data v:@"default-artist"];
	}
	if (label_album != nil)
	{
		label_album.text = [player.nowPlayingItem valueForProperty:MPMediaItemPropertyAlbumTitle];
		if (label_album.text == nil)
			label_album.text = [data v:@"default-album"];
	}
	if (artwork != nil)
	{
		//NSLog(@"media artwork: %@", [[player.nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:artwork.frame.size]);
		NSLog(@"player status : %i", player.playbackState);
		if ([[player.nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:artwork.frame.size] != nil)
			artwork.image = [[player.nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:artwork.frame.size];
		else if (([data v:@"default-artwork"] != nil) && (player.playbackState == MPMusicPlaybackStatePlaying))
			artwork.image = [UIImage imageNamed:[data v:@"default-artwork"]];
		else
		{
			artwork.image = nil;
			[self performSelector:@selector(check_artwork:) withObject:artwork afterDelay:0.3];
		}
	}
	if (reflection != nil)
		reflection.image = [UIImage image_flip_vertically:artwork.image];
	//	NSLog(@"PLAYER item changed: %@", player.nowPlayingItem);
	//	0.2 works for 3gs as well, but leave 0.3 for safety
	[ly perform_after:0.3 block:^(void)
	{
		int index = -1;
		//	NSLog(@"playlist: %@, %i", [data v:@"playlist-items"], player.playbackState);
		if (player.playbackState == MPMusicPlaybackStatePlaying)
		{
			//for (MPMediaItem* item in [data v:@"playlist-items"])
			for (NSDictionary* item in [data v:@"playlist-items"])
			{
				index++;
#if 0
				NSLog(@"%@/%@\n%@", [player.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle],
									[player.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist], item);
#endif
				//	if ([[item valueForProperty:MPMediaItemPropertyPersistentID] longValue] ==
				//		[[player.nowPlayingItem valueForProperty:MPMediaItemPropertyPersistentID] longValue])
				if ([[item v:@"title"] is:[player.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle]] &&
					[[item v:@"artist"] is:[player.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist]])
					break;
			}
		}
		else
			NSLog(@"player is not playing");
		if (index >= 0)
		{
			LYTableViewProvider* provider = [data v:@"playlist-provider"];
			[[provider.accessories objectAtIndex:0] removeAllObjects];
			for (int i = 0; i < [[data v:@"playlist-items"] count]; i++)
				if (index == i)
					[[provider.accessories objectAtIndex:0] addObject:[data v:@"provider-accessory"]];
				else
					[[provider.accessories objectAtIndex:0] addObject:@"none"];
			[provider.view reloadData];
		}
		NSLog(@"PLAYER now playing index: %i", index);
	}];
#endif
}

- (void)check_artwork:(UIImageView*)artwork
{
	if (([data v:@"default-artwork"] != nil) && (player.playbackState == MPMusicPlaybackStatePlaying))
		artwork.image = [UIImage imageNamed:[data v:@"default-artwork"]];
}

- (void)player_state_changed:(NSNotification*)notification
{
	UIButton* button = [data v:@"player-play"];
	if (player.playbackState != MPMusicPlaybackStatePlaying)
	{
		if (button != nil)
			button.selected = NO;
	}
	else
	{
		if (button != nil)
			button.selected = YES;
	}
}

- (void)player_progress_timer
{
	UISlider*	progress = [data v:@"player-progress"];
	UILabel*	label_played = [data v:@"player-played"];
	UILabel*	label_remaining = [data v:@"player-remaining"];
	if (player.nowPlayingItem == nil)
	{
		if (progress != nil)
		{
			progress.enabled = NO;
			progress.value = 0;
		}
		if (label_played != nil)
			[label_played setText:@"0:00"];
		if (label_remaining != nil)
			[label_remaining setText:@"-0:00"];
	}
	else
	{
		NSTimeInterval duration = [[player.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
		if (progress != nil)
		{
			progress.enabled = YES;
			[progress setValue:player.currentPlaybackTime / duration animated:YES];
		}
		if (label_played != nil)
			label_played.text = [NSString stringWithFormat:@"%i:%02i", 
			   (int)player.currentPlaybackTime / 60,
			   (int)player.currentPlaybackTime % 60];
		if (label_remaining != nil)
			label_remaining.text = [NSString stringWithFormat:@"-%i:%02i", 
			   (int)(duration - player.currentPlaybackTime) / 60,
			   (int)(duration - player.currentPlaybackTime) % 60];
	}
}

- (void)player_progress_change
{
	player.currentPlaybackTime = [[[player nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue] * [(UISlider*)[data v:@"player-progress"] value];
}

- (void)player_volume_changed:(NSNotification*)notification
{
	if ([data v:@"player-volume"] != nil)
		[[data v:@"player-volume"] setValue:player.volume animated:YES];
}

- (void)player_volume_change
{
	player.volume = [(UISlider*)[data v:@"player-volume"] value];
}

@end
