#import "LYServiceKit.h"

@interface LYServiceUI: UIViewController
{
	NSMutableDictionary* data;
	IBOutlet UIViewController*	controller;

	IBOutlet UIViewController*		controller_login;
	IBOutlet UITextField*			field_login_name;
	IBOutlet UITextField*			field_login_mail;
	IBOutlet UITextField*			field_login_pin1;
	IBOutlet UITextField*			field_login_pin2;
	IBOutlet UISegmentedControl*	segment_login_type;
}
@property (nonatomic, retain) NSMutableDictionary*	data;

- (UIViewController*)controller_login;

- (IBAction)action_login_type;
- (IBAction)action_login_done;

@end

/*
Welcome to Suar™ Network! Your email address will be used for identification purpose only, and will not be shared with other users. The name you choose will be seen by other people so please do not choose any offensive terms.
*/
