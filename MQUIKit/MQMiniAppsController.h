#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MQCategory.h"
#import "MQBrowserController.h"

@class MQBrowserController;

@interface MQMiniAppsController: UIViewController <MFMailComposeViewControllerDelegate>
{
	UINavigationController*	nav;
	BOOL					status_bar_hidden;
	IBOutlet UIView*		view_fullscreen;
	IBOutlet UIButton*		button_fullscreen;
	IBOutlet UIImageView*	image_fullscreen;
	MQBrowserController*	browser;
}
@property (nonatomic, retain) UINavigationController*		nav;
@property (nonatomic, retain) UIImageView*					image_fullscreen;
@property (nonatomic, retain) UIButton*						button_fullscreen;

//- (id)initWithNavigationController:(UINavigationController*)a_nav;
- (void)show_flashlight:(UIColor*)color;
- (void)show_image:(NSString*)filename;
- (void)present_image:(UIImage*)image;
- (void)show_mail_to:(NSArray*)recipients title:(NSString*)title body:(NSString*)body;
- (void)show_browser:(NSString*)url;

- (IBAction)action_dismiss_fullscreen;

@end
