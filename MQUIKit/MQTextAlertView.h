#import <UIKit/UIKit.h>
#import "MQCategory.h"

/*
 * example
 *
 * text_alert = [[MQTextAlertView alloc] initWithTitle:@"Reset Password" message:@"Please enter 
 * text_alert.delegate = self;
 * text_alert.action_done = @"action_login";
 * [text_alert set_text:0 with:field_profile_username.text];
 * [text_alert set_placeholder:0 with:@"Username"];
 * [text_alert set_placeholder:1 with:@"Password"];
 * [text_alert show];
 *
 */
@interface MQTextAlertView: NSObject <UITextFieldDelegate>
{
	UIAlertView*					alert;
	NSMutableArray*					text_fields;
	NSObject <UIAlertViewDelegate>*	delegate;
	NSString*						action_done;
}
@property (nonatomic, retain) id			delegate;
@property (nonatomic, retain) NSString*		action_done;

- (id)initWithTitle:(NSString*)title message:(NSString*)message count:(NSInteger)count;
- (void)set_placeholder:(NSInteger)index with:(NSString*)s;
- (void)set_text:(NSInteger)index with:(NSString*)s;
- (NSString*)get_text:(NSInteger)index;
- (void)show;

@end
