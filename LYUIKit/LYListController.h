#import "LYCategory.h"

@class LYTableViewProvider;

@interface LYListController: UIViewController
{
	//IBOutlet UINavigationBar*	navigationBar;
	IBOutlet UITableView*		table;

	UINavigationController*	nav;
	LYTableViewProvider*	provider;
	NSObject*				delegate;
	NSDictionary*			dict;
	NSString*				name;
}
@property (nonatomic, retain) LYTableViewProvider*	provider;
@property (nonatomic, retain) UITableView*			table;
@property (nonatomic, retain) NSObject*				delegate;
@property (nonatomic, retain) NSString*				name;

- (id)initWithNav:(UINavigationController*)a_nav;
- (void)refresh_named:(NSString*)a_name dict:(NSDictionary*)a_dict;
- (BOOL)is_named:(NSString*)a_name;
- (IBAction)action_dismiss;

@end
