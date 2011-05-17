#define PLAYER_TYPE_PREF_KEY @"player_type_preference"
#define AUDIO_TYPE_PREF_KEY @"audio_technology_preference"

#import "LYPublic.h"
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LYMusicJukeboxTableViewController.h"
//#import "AddMusicAppDelegate.h"

@interface LYMusicJukeboxController : UIViewController <MPMediaPickerControllerDelegate, LYMusicJukeboxTableViewControllerDelegate, AVAudioPlayerDelegate> {

	//AddMusicAppDelegate			*applicationDelegate;
	IBOutlet UIBarButtonItem	*artworkItem;
	IBOutlet UINavigationBar	*navigationBar;
	IBOutlet UILabel			*nowPlayingLabel;
	BOOL						playedMusicOnce;

	AVAudioPlayer				*appSoundPlayer;
	NSURL						*soundFileURL;
	IBOutlet UIButton			*appSoundButton;
	IBOutlet UIButton			*addOrShowMusicButton;
	BOOL						interruptedOnPlayback;
	BOOL						playing ;

	UIBarButtonItem				*playBarButton;
	UIBarButtonItem				*pauseBarButton;
	MPMusicPlayerController		*musicPlayer;	
	MPMediaItemCollection		*userMediaItemCollection;
	UIImage						*noArtworkImage;
	NSTimer						*backgroundColorTimer;

	IBOutlet UIImageView*		image_artwork;
	IBOutlet UINavigationItem*	item_title;
	BOOL						use_ipod;

	UINavigationController*		delegate_nav;
	UIWindow*					delegate_window;
}

@property (nonatomic, retain)	UINavigationController*	delegate_nav;
@property (nonatomic, retain)	UIWindow*				delegate_window;

@property (nonatomic, retain)	UIBarButtonItem			*artworkItem;
@property (nonatomic, retain)	UINavigationBar			*navigationBar;
@property (nonatomic, retain)	UILabel					*nowPlayingLabel;
@property (readwrite)			BOOL					playedMusicOnce;

@property (nonatomic, retain)	UIBarButtonItem			*playBarButton;
@property (nonatomic, retain)	UIBarButtonItem			*pauseBarButton;
@property (nonatomic, retain)	MPMediaItemCollection	*userMediaItemCollection; 
@property (nonatomic, retain)	MPMusicPlayerController	*musicPlayer;
@property (nonatomic, retain)	UIImage					*noArtworkImage;
@property (nonatomic, retain)	NSTimer					*backgroundColorTimer;

@property (nonatomic, retain)	AVAudioPlayer			*appSoundPlayer;
@property (nonatomic, retain)	NSURL					*soundFileURL;
@property (nonatomic, retain)	IBOutlet UIButton		*appSoundButton;
@property (nonatomic, retain)	IBOutlet UIButton		*addOrShowMusicButton;
@property (readwrite)			BOOL					interruptedOnPlayback;
@property (readwrite)			BOOL					playing;

- (id)initWithTitle:(NSString*)title iPod:(BOOL)pod;

- (IBAction)	playOrPauseMusic:		(id) sender;
- (IBAction)	AddMusicOrShowMusic:	(id) sender;
- (IBAction)	playAppSound:			(id) sender;

- (BOOL) useiPodPlayer;
- (void)dismiss_modal;

- (IBAction)action_dismiss;

@end
