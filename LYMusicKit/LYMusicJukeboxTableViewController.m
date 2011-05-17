#import "LYMusicJukeboxTableViewController.h"
#import "LYMusicJukeboxController.h"

@implementation LYMusicJukeboxTableViewController

static NSString *kCellIdentifier = @"Cell";

@synthesize delegate;					// The main view controller is the delegate for this class.
@synthesize mediaItemCollectionTable;	// The table shown in this class's view.
@synthesize addMusicButton;				// The button for invoking the media item picker. Setting the title
										//		programmatically supports localization.


// Configures the table view.
- (void) viewDidLoad {

    [super viewDidLoad];
	//	self.view.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
	//	[self.view autoresizing_add_width:YES height:YES];
	
	//	[self.addMusicButton setTitle: NSLocalizedString (@"AddMusicFromTableView", @"Add button shown on table view for invoking the media item picker")];
	[self.addMusicButton setTitle: NSLocalizedString (@"Add", @"Add button shown on table view for invoking the media item picker")];
	
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];      
}


// When the user taps Done, invokes the delegate's method that dismisses the table view.
- (IBAction) doneShowingMusicList: (id) sender {
	//	NSLog(@"delegate: %@", self.delegate);
	//	[self.delegate musicTableViewControllerDidFinish: self];
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[self dismissModalViewControllerAnimated:YES];
}


// Configures and displays the media item picker.
- (IBAction) showMediaPicker: (id) sender {

	MPMediaPickerController *picker =
		[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
	
	picker.delegate						= self;
	picker.allowsPickingMultipleItems	= YES;
	picker.prompt						= NSLocalizedString (@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];

	[self presentModalViewController: picker animated: YES];
	[picker release];
}


// Responds to the user tapping Done after choosing music.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
  
	[self dismissModalViewControllerAnimated: YES];
	[self.delegate updatePlayerQueueWithMediaCollection: mediaItemCollection];
	[self.mediaItemCollectionTable reloadData];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}


// Responds to the user tapping done having chosen no music.
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {

	[self dismissModalViewControllerAnimated: YES];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}



#pragma mark Table view methods________________________

// To learn about using table views, see the TableViewSuite sample code  
//		and Table View Programming Guide for iPhone OS.

- (NSInteger) tableView: (UITableView *) table numberOfRowsInSection: (NSInteger)section {

	LYMusicJukeboxController *mainViewController = (LYMusicJukeboxController *) self.delegate;
	MPMediaItemCollection *currentQueue = [mainViewController userMediaItemCollection];
	return [currentQueue.items count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	NSInteger row = [indexPath row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellIdentifier];
	
	if (cell == nil) {
	
		cell = [[[UITableViewCell alloc] initWithFrame: CGRectZero 
									   reuseIdentifier: kCellIdentifier] autorelease];
	}
	
	LYMusicJukeboxController *mainViewController = (LYMusicJukeboxController *) self.delegate;
	MPMediaItemCollection *currentQueue = [mainViewController userMediaItemCollection];
	MPMediaItem *anItem = (MPMediaItem *)[currentQueue.items objectAtIndex: row];
	
	if (anItem) {
		cell.textLabel.text = [anItem valueForProperty:MPMediaItemPropertyTitle];
	}

	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	return cell;
}

//	 To conform to the Human Interface Guidelines, selections should not be persistent --
//	 deselect the row after it has been selected.
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark Application state management_____________
// Standard methods for managing application state.
- (void)didReceiveMemoryWarning {

	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {

    [super dealloc];
}


@end
