#import "LYPublic.h"
#import <MessageUI/MessageUI.h>

/*
 * example
 *
	LYShareController* controller_share;
	controller_share = [[LYShareController alloc] init];
	controller_share.navigation_controller = nav_current;
	controller_share.title = @"iOS Sharing Service";
	controller_share.message = s;
	[controller_share show];
 */

@class LYFacebook;

@interface LYShareController: NSObject <MFMailComposeViewControllerDelegate>
{
	UINavigationController*			navigation_controller;
	MFMailComposeViewController*	controller_email;
	MFMessageComposeViewController*	controller_sms;
	//id							controller_sms;
#ifdef LY_ENABLE_SDK_FACEBOOK
	LYFacebook*						controller_facebook;
#endif

	NSString*	title;
	NSString*	message;
}
@property (nonatomic, retain) UINavigationController*	navigation_controller;
@property (nonatomic, retain) NSString*					title;
@property (nonatomic, retain) NSString*					message;

- (void)show;
- (void)facebook_login;
- (void)facebook_logout;

@end

