#import <MediaPlayer/MediaPlayer.h>

@protocol LYMusicJukeboxTableViewControllerDelegate; // forward declaration


@interface LYMusicJukeboxTableViewController : UIViewController <MPMediaPickerControllerDelegate, UITableViewDelegate> {

	id <LYMusicJukeboxTableViewControllerDelegate>	delegate;
	IBOutlet UITableView					*mediaItemCollectionTable;
	IBOutlet UIBarButtonItem				*addMusicButton;
}

@property (nonatomic, assign) id <LYMusicJukeboxTableViewControllerDelegate>	delegate;
@property (nonatomic, retain) UITableView							*mediaItemCollectionTable;
@property (nonatomic, retain) UIBarButtonItem						*addMusicButton;

- (IBAction) showMediaPicker: (id) sender;
- (IBAction) doneShowingMusicList: (id) sender;

@end



@protocol LYMusicJukeboxTableViewControllerDelegate

// implemented in LYMusicJukeboxController.m
- (void) musicJukeboxTableViewControllerDidFinish: (LYMusicJukeboxTableViewController *) controller;
- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection;

@end

