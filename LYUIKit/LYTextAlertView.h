#import <UIKit/UIKit.h>
#import "LYCategory.h"

/*
 * example
 *
	text_alert = [[LYTextAlertView alloc] initWithTitle:@"Reset Password" message:@"Please enter..." count:2];
	text_alert.delegate = self;
	text_alert.action_done = @"action_login";
	[text_alert set_text:0 with:field_profile_username.text];
	[text_alert set_placeholder:0 with:@"Username"];
	[text_alert set_placeholder:1 with:@"Password"];
	[text_alert show];
 *
 */
@interface LYTextAlertView: NSObject <UITextFieldDelegate>
{
	UIAlertView*					alert;
	NSMutableArray*					text_fields;
	NSObject <UIAlertViewDelegate>*	delegate;
	NSString*						action_done;
}
@property (nonatomic, retain) id				delegate;
@property (nonatomic, retain) UIAlertView*		alert;
@property (nonatomic, retain) NSString*			action_done;
@property (nonatomic, retain) NSMutableArray*	text_fields;

- (id)initWithTitle:(NSString*)title message:(NSString*)message count:(NSInteger)count;
- (id)initWithTitle:(NSString*)title message:(NSString*)message confirm:(NSString*)confirm cancel:(NSString*)cancel count:(NSInteger)count;
- (void)set_placeholder:(NSInteger)index with:(NSString*)s;
- (void)set_text:(NSInteger)index with:(NSString*)s;
- (NSString*)get_text:(NSInteger)index;
- (void)show;

@end
