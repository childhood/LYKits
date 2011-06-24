#import "LYKits.h"

/*
 * usage:
 *
 * 	list_controller = [[LYListController alloc] initWithNav:nav_local];
 * 	list_controller.delegate = self;
 *
 *	[list_controller refresh_named:@"country" dict:[ly dict_itunes_country]];
 *	[list_controller.provider_table apply_alphabet];
 *	[list_controller.table reloadData];
 *	[list_controller show_table];
 *
 * 	- (void)list_selected:(NSString*)key
 * 	{
 *		[@"setting_country" setting_string:[list_controller.dict valueForKey:key]];
 * 	}
 */

@class LYTableViewProvider;
@class LYPickerViewProvider;

@interface LYListController: UIViewController
{
	//IBOutlet UINavigationBar*	navigationBar;
	IBOutlet UITableView*		table;
	IBOutlet UIPickerView*		picker;
	IBOutlet UINavigationBar*	bar_table;
	IBOutlet UINavigationBar*	bar_picker;
	IBOutlet UIView*			view_table;
	IBOutlet UIView*			view_picker;

	UIViewController*		controller_parent;
	LYTableViewProvider*	provider_table;
	LYPickerViewProvider*	provider_picker;
	NSObject*				delegate;
	NSDictionary*			dict;
	NSString*				name;
	NSString*				mode;
	NSString*				current_picker_title;
}
@property (nonatomic, retain) LYTableViewProvider*	provider_table;
@property (nonatomic, retain) NSDictionary*			dict;
@property (nonatomic, retain) UITableView*			table;
@property (nonatomic, retain) NSObject*				delegate;
@property (nonatomic, retain) NSString*				name;

- (id)initWithController:(UIViewController*)controller;
- (id)initWithNav:(UINavigationController*)a_nav;
//- (void)init_data;

- (void)show_table;
- (void)show_picker;

- (void)refresh_named:(NSString*)a_name dict:(NSDictionary*)a_dict;
- (void)refresh_named:(NSString*)a_name dict:(NSDictionary*)a_dict default:(NSString*)a_default;
- (BOOL)is_named:(NSString*)a_name;

- (IBAction)action_dismiss;
- (IBAction)action_done;

@end
