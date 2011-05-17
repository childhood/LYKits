#import "LYPublic.h"

@interface LYImagePickerController: UIViewController
{
	IBOutlet UIImagePickerController*	picker;
	IBOutlet UISegmentedControl*		segment_flash;
	IBOutlet UISegmentedControl*		segment_camera;

	NSMutableArray*				background_titles;
	NSMutableArray*				background_filenames;
}
@property (nonatomic, retain) NSMutableArray*	background_titles;
@property (nonatomic, retain) NSMutableArray*	background_filenames;

- (IBAction)action_flash_changed;
- (IBAction)action_camera_changed;
- (IBAction)action_select_source;;
- (void)add_background:(NSString*)title filename:(NSString*)filename;

@end
