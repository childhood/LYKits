#import <MusicKit/MusicKit.h>

- (void)import_ipod_playlists
{
	MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
	for (MPMediaPlaylist *playlist in [myPlaylistsQuery collections])
	{
		NSMutableArray* array = [NSMutableArray array];
		NSString* name = [playlist valueForProperty:MPMediaPlaylistPropertyName];
		//	NSLog(@"%@", name);
		for (MPMediaItem *song in playlist.items)
		{
			NSString *title = [song valueForProperty: MPMediaItemPropertyTitle];
			NSString *artist = [song valueForProperty: MPMediaItemPropertyArtist];
			[array addObject:[NSDictionary dictionaryWithObjectsAndKeys:
				title,
				@"title",
				artist,
				@"artist",
				nil]];
			//	NSLog (@"\t\t%@", name, title, artist);
		}
		[array_playlist_player addObject:[NSDictionary dictionaryWithObjectsAndKeys:
			array,
			@"data",
			name,
			@"name",
			nil]];
	}
	[array_playlist_player sortUsingDescriptors:[NSArray arrayWithObjects:
		[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil]];
}
