#import "LYKits.h"

@class LYTableViewProvider;
@class LYPickerViewProvider;

@interface LYListController: UIViewController
{
	//IBOutlet UINavigationBar*	navigationBar;
	IBOutlet UITableView*		table;
	IBOutlet UIPickerView*		picker;
	IBOutlet UINavigationBar*	bar_picker;
	IBOutlet UIView*			view_table;
	IBOutlet UIView*			view_picker;

	UINavigationController*	nav;
	LYTableViewProvider*	provider_table;
	LYPickerViewProvider*	provider_picker;
	NSObject*				delegate;
	NSDictionary*			dict;
	NSString*				name;
	NSString*				mode;
}
@property (nonatomic, retain) LYTableViewProvider*	provider_table;
@property (nonatomic, retain) UITableView*			table;
@property (nonatomic, retain) NSObject*				delegate;
@property (nonatomic, retain) NSString*				name;

- (id)initWithNav:(UINavigationController*)a_nav;

- (void)show_table;
- (void)show_picker;

- (void)refresh_named:(NSString*)a_name dict:(NSDictionary*)a_dict;
- (BOOL)is_named:(NSString*)a_name;
- (IBAction)action_dismiss;

@end
