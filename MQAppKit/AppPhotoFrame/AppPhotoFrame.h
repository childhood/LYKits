#import <UIKit/UIKit.h>
#import "MQPublic.h"

@interface AppPhotoFrame: MQAppController
{
	IBOutlet UINavigationBar*		navigationBar;
	IBOutlet UINavigationItem*		navigationItem;
	IBOutlet UIImageView*			image_bg;
	IBOutlet UISegmentedControl*	segment_mode;
	IBOutlet UIToolbar*				toolbar_control;
	IBOutlet UIButton*				button_fullscreen;
	MQ3DImageView*		image_3d;
	BOOL				is_fullscreen;
	BOOL				is_started;
}
@property (nonatomic, retain) UIImageView*		image_bg;
@property (nonatomic, retain) MQ3DImageView*	image_3d;
@property (nonatomic, retain) UIButton*			button_fullscreen;
@property (nonatomic) BOOL	is_started;

- (void)load;
- (IBAction)action_add_foreground;
- (IBAction)action_add_background;
- (IBAction)action_change_mode;
- (IBAction)action_toggle_fullscreen;
- (IBAction)action_show_help;

@end
