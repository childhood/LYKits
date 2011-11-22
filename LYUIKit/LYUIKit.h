#import <objc/message.h>
#import <UIKit/UIKit.h>
#import "LYScrollTabController.h"
#import "LYTableViewProvider.h"
#import "LYButtonMatrixController.h"
#import "LYKeyboardMatrixController.h"
#import "LYAsyncImageView.h"
#import "LYBrowserController.h"
#import "LYImagePickerController.h"
#import "LYShareController.h"
#import "LYTextAlertView.h"
#import "LYLoadingViewController.h"
#import "LYPDFViewController.h"
#import "LYMiniAppsController.h"
#import "LY3DImageView.h"
#import "LYListController.h"
//#import "LYTableController.h"

BOOL CGPointInRect(CGPoint point, CGRect rect);
UIInterfaceOrientation get_interface_orientation();
BOOL is_interface_portrait();
BOOL is_interface_landscape();
CGFloat get_width(CGFloat width);
CGFloat get_height(CGFloat height);
CGFloat screen_width(void);
CGFloat screen_height(void);
CGFloat screen_max(void);
UIView* ly_alloc_view_loading(void);

/*
 *
 * LYScrollTabController
 * 		scrollable tab controller
 *
 * LYTableViewProvider
 * 		advanced data source of UITableView
 * 		best practise: static tables (see project iphone/pacard)
 *
 * LYButtonMatrixController
 * 		movable button matrix
 * 		can be added to a scroll view
 *
 * LYKeyboardMatrixController
 * 		customized keyboard that supports dovrak layout, etc.
 *
 * LYAsyncImageView
 * 		multiple-thread downloading
 *
 * LYBrowserController
 * 		in-app internet browser
 *
 * LYImagePickerController
 * 		image picker warp
 *
 * LYShareController
 * 		text sharing via mail, sms, facebook, etc.
 *
 * LYTextAlertView
 * 		alert view that contains UITextFields
 *
 * LYLoadingViewController
 * 		customizable loading view
 *
 */

@interface LYPickerViewProvider: NSObject <UIPickerViewDelegate, UIPickerViewDataSource>
{
	NSMutableArray*		titles;
	NSObject*			delegate;
}
@property (nonatomic, retain) NSMutableArray*	titles;
@property (nonatomic, retain) NSObject*			delegate;

- (id)initWithPicker:(UIPickerView*)picker;
//	- (id)initWithTitles:(NSArray*)titles;

@end

@interface LYMiniApps: LYSingletonClass
{
	UINavigationController*	nav;
	BOOL					status_bar_hidden;
}
@property (nonatomic, retain) UINavigationController*		nav;
+ (id)shared;
- (id)initWithNavigationController:(UINavigationController*)a_nav;
- (void)show_flashlight:(UIColor*)color;
- (void)show_image:(NSString*)filename;
@end

#import <unistd.h>

@interface LYSpinImageView: UIImageView
{
	NSMutableArray*	image_names;
	CGPoint		location_begin;
	NSInteger	index;
	NSInteger	setting_pixel_per_frame;		//	move how many pixels to change frame
	NSDate*		date_last;
	NSThread*	thread_animation;
	CGFloat		speed_last;

	CGFloat		factor_sensitivity;
	NSInteger	factor_sleep;
	CGFloat		factor_duration;
	CGFloat		factor_time;
}
@property (nonatomic, retain) NSMutableArray*	image_names;
@property (nonatomic) CGFloat	factor_sensitivity;
@property (nonatomic) NSInteger	factor_sleep;
@property (nonatomic) CGFloat	factor_duration;
@property (nonatomic) CGFloat	factor_time;

- (void)set_name_format:(NSString*)format from:(NSInteger)head to:(NSInteger)tail;
- (void)refresh;
- (void)spin:(CGFloat)factor;
- (void)apply_default_factors;

@end


#ifdef LY_ENABLE_SDK_AWS
@class 	LYServiceAWSSimpleDB;

@interface LYSuarViewController: UIViewController <UITabBarControllerDelegate>
{
	LYServiceAWSSimpleDB*	sdb;

	IBOutlet UIViewController*		controller_profile;
	IBOutlet UISegmentedControl*	segment_profile_type;
	IBOutlet UITextField*			field_profile_name;
	IBOutlet UITextField*			field_profile_mail;
	IBOutlet UITextField*			field_profile_pin1;
	IBOutlet UITextField*			field_profile_pin2;

	IBOutlet UIViewController*		controller_wall;
	IBOutlet UITableView*			table_wall;
	LYTableViewProvider*			provider_wall;

	IBOutlet UIViewController*		controller_public;
	IBOutlet UITableView*			table_public;
	LYTableViewProvider*			provider_public;
}
@property (nonatomic, retain) IBOutlet id	delegate;
@property (nonatomic, retain) IBOutlet UITabBarController*		tab;
@property (nonatomic, retain) IBOutlet UINavigationController*	nav_profile;
@property (nonatomic, retain) IBOutlet UINavigationController*	nav_wall;
@property (nonatomic, retain) IBOutlet UINavigationController*	nav_public;

- (IBAction)action_profile_type;
- (void)load;
- (void)reload_provider:(LYTableViewProvider**)provider table:(UITableView*)table query:(NSString*)query;

@end
#endif


@interface LYFlipImageView: UIImageView
@property (nonatomic, retain) NSMutableDictionary*	data;

- (void)set_sequence_numbers;
- (void)flip_to:(NSString*)s;
- (void)reload;
- (void)reload:(NSNumber*)number;

@end
