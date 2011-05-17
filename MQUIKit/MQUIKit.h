#import <UIKit/UIKit.h>
#import "MQScrollTabController.h"
#import "MQTableViewProvider.h"
#import "MQButtonMatrixController.h"
#import "MQKeyboardMatrixController.h"
#import "MQAsyncImageView.h"
#import "MQBrowserController.h"
#import "MQImagePickerController.h"
#import "MQShareController.h"
#import "MQTextAlertView.h"
#import "MQLoadingViewController.h"
#import "MQPDFViewController.h"
#import "MQMiniAppsController.h"
#import "MQ3DImageView.h"
//#import "MQTableController.h"

BOOL CGPointInRect(CGPoint point, CGRect rect);
UIInterfaceOrientation get_interface_orientation();
BOOL is_interface_portrait();
BOOL is_interface_landscape();
CGFloat get_width(CGFloat width);
CGFloat get_height(CGFloat height);
CGFloat screen_width(void);
CGFloat screen_height(void);
CGFloat screen_max(void);
UIView* mq_alloc_view_loading(void);

/*
 *
 * MQScrollTabController
 * 		scrollable tab controller
 *
 * MQTableViewProvider
 * 		advanced data source of UITableView
 * 		best practise: static tables (see project iphone/pacard)
 *
 * MQButtonMatrixController
 * 		movable button matrix
 * 		can be added to a scroll view
 *
 * MQKeyboardMatrixController
 * 		customized keyboard that supports dovrak layout, etc.
 *
 * MQAsyncImageView
 * 		multiple-thread downloading
 *
 * MQBrowserController
 * 		in-app internet browser
 *
 * MQImagePickerController
 * 		image picker warp
 *
 * MQShareController
 * 		text sharing via mail, sms, facebook, etc.
 *
 * MQTextAlertView
 * 		alert view that contains UITextFields
 *
 * MQLoadingViewController
 * 		customizable loading view
 *
 */

#import "MQFoundation.h"

@interface MQMiniApps: MQSingletonClass
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

@interface MQSpinImageView: UIImageView
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

