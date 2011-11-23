#import "LYServiceKit.h"

#ifdef LY_ENABLE_SDK_AWS
@class LYServiceAWSSimpleDB;
@class LYTableViewProvider;

@interface LYSuarViewController: UIViewController <UITabBarControllerDelegate>
{
	LYServiceAWSSimpleDB*	sdb_wall;
	LYServiceAWSSimpleDB*	sdb_public;

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
- (void)reload_provider:(LYTableViewProvider**)a_provider table:(UITableView*)table query:(NSString*)query sdb:(LYServiceAWSSimpleDB*)sdb;

@end
#endif


#if 0
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
#endif

/*
Welcome to Suar™ Network! Your email address will be used for identification purpose only, and will not be shared with other users. The name you choose will be seen by other people so please do not choose any offensive terms.
*/
