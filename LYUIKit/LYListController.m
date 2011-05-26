#import "LYListController.h"

@implementation LYListController

@synthesize provider;
@synthesize table;
@synthesize delegate;
@synthesize name;

- (id)initWithNav:(UINavigationController*)a_nav
{
	self = [super initWithNibName:@"LYListController" bundle:nil];
	if (self != nil)
	{
		nav = a_nav;
		dict = nil;
		provider = nil;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	if (provider != nil)
	{
		provider.view = table;
		table.delegate = provider;
		table.dataSource = provider;
	}
	else
	{
		provider = [[LYTableViewProvider alloc] initWithTableView:table];
		provider.cell_height = 48;
		provider.delegate = self;
		[provider.texts add_array:@"No Entry", nil];
	}
	[table reloadData];
}

- (void)viewDidUnload
{
	[provider release];
	provider = nil;
	[super viewDidUnload];
}

- (void)dealloc
{
	[provider release];
	[super dealloc];
}

- (BOOL)is_named:(NSString*)a_name
{
	return [name isEqualToString:a_name];
}

#pragma mark refreshers

- (void)refresh_named:(NSString*)a_name dict:(NSDictionary*)a_dict
{
	if ([self isViewLoaded] == NO)
		[self viewDidLoad];

	name = a_name;

	if (dict != nil)
		[dict release];
	dict = [a_dict retain];

	[provider.texts removeAllObjects];
	[provider.texts addObject:[NSArray arrayWithArray:[[a_dict allKeys] sortedArrayUsingSelector:@selector(compare:)]]];
	//[provider.texts addObject:[NSArray arrayWithArray:[a_dict keysSortedByValueUsingSelector:@selector(compare:)]]];
#if 0
	[provider.texts add_array:nil];
	for (NSString* key in a_dict)
		[[provider.texts objectAtIndex:0] addObject:key];
#endif
	[table reloadData];
}

#pragma mark actions

- (void)tableView:(UITableView*)table didSelectRowAtIndexPath:(NSIndexPath*)path
{
	[delegate perform_string:@"list_selected:" with:[dict valueForKey:[provider.texts object_at_path:path]]];
	[self action_dismiss];
}

- (IBAction)action_dismiss
{
	[nav dismissModalViewControllerAnimated:YES];
}

@end
