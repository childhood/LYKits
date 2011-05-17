#import <MediaPlayer/MediaPlayer.h>

@protocol MQMusicJukeboxTableViewControllerDelegate; // forward declaration


@interface MQMusicJukeboxTableViewController : UIViewController <MPMediaPickerControllerDelegate, UITableViewDelegate> {

	id <MQMusicJukeboxTableViewControllerDelegate>	delegate;
	IBOutlet UITableView					*mediaItemCollectionTable;
	IBOutlet UIBarButtonItem				*addMusicButton;
}

@property (nonatomic, assign) id <MQMusicJukeboxTableViewControllerDelegate>	delegate;
@property (nonatomic, retain) UITableView							*mediaItemCollectionTable;
@property (nonatomic, retain) UIBarButtonItem						*addMusicButton;

- (IBAction) showMediaPicker: (id) sender;
- (IBAction) doneShowingMusicList: (id) sender;

@end



@protocol MQMusicJukeboxTableViewControllerDelegate

// implemented in MQMusicJukeboxController.m
- (void) musicJukeboxTableViewControllerDidFinish: (MQMusicJukeboxTableViewController *) controller;
- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection;

@end

