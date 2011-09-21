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
	IBOutlet UILabel*				label_login_note;
	IBOutlet UIToolbar*				toolbar_login_main;
	IBOutlet UIBarButtonItem*		item_login_cancel;
	IBOutlet UISegmentedControl*	segment_login_type;
}
@property (nonatomic, retain) NSMutableDictionary*	data;
@property (nonatomic, retain) UILabel*				label_login_note;
@property (nonatomic, retain) UIBarButtonItem*		item_login_cancel;

- (UIViewController*)controller_login;
- (void)login_disable_cancel;

- (IBAction)action_login_type;
- (IBAction)action_login_done;
- (IBAction)action_login_cancel;

- (NSString*)insert_post_image:(NSString*)key;
- (NSString*)insert_post_title:(NSString*)title content:(NSString*)content pid:(NSString*)pid url:(NSString*)parent_url;

@end

/*
Welcome to Suar™ Network! Your email address will be used for identification purpose only, and will not be shared with other users. The name you choose will be seen by other people so please do not choose any offensive terms.
*/
