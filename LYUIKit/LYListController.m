#import "LYListController.h"

@implementation LYListController

@synthesize provider_table;
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
		provider_table = nil;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.frame = CGRectMake(0, 20, [ly screen_width], [ly screen_height] - 20);

	if (provider_table != nil)
	{
		provider_table.view = table;
		table.delegate = provider_table;
		table.dataSource = provider_table;
	}
	else
	{
		provider_table = [[LYTableViewProvider alloc] initWithTableView:table];
		provider_table.cell_height = 48;
		provider_table.delegate = self;
		[provider_table.texts add_array:@"No Entry", nil];
	}
	[table reloadData];

	if (provider_picker != nil)
	{
		picker.delegate = provider_picker;
		picker.dataSource = provider_picker;
	}
	else
	{
		provider_picker = [[LYPickerViewProvider alloc] initWithPicker:picker];
		provider_picker.delegate = self;
	}
}

- (void)viewDidUnload
{
	provider_table = [provider_table release_nil];
	provider_picker = [provider_picker release_nil];
	[super viewDidUnload];
}

- (void)dealloc
{
	[provider_picker release];
	[provider_table release];
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

	[provider_table.texts removeAllObjects];
	[provider_table.texts addObject:[NSArray arrayWithArray:[[a_dict allKeys] sortedArrayUsingSelector:@selector(compare:)]]];
	//[provider_table.texts addObject:[NSArray arrayWithArray:[a_dict keysSortedByValueUsingSelector:@selector(compare:)]]];
#if 0
	[provider_table.texts add_array:nil];
	for (NSString* key in a_dict)
		[[provider_table.texts objectAtIndex:0] addObject:key];
#endif
	[table reloadData];

	[provider_picker.titles removeAllObjects];
	[provider_picker.titles addObject:[[a_dict allKeys] sortedArrayUsingSelector:@selector(compare:)]];
	[picker reloadAllComponents];
}

- (void)show_table
{
	mode = @"table";
	[self.view remove_subviews];
	[self.view addSubview:view_table];
	[nav presentModalViewController:self animated:YES];
}

- (void)show_picker
{
	mode = @"picker";
#if 0
	[self.view remove_subviews];
	[self.view addSubview:view_picker];
	[nav presentModalViewController:self animated:YES];
#endif
	self.view.frame = CGRectMake(0, 20, [ly screen_width], [ly screen_height] - 20);
	[nav.view addSubview:view_picker];
}

#pragma mark delegates

- (void)tableView:(UITableView*)table didSelectRowAtIndexPath:(NSIndexPath*)path
{
	[delegate perform_string:@"list_selected:" with:[dict valueForKey:[provider_table.texts object_at_path:path]]];
	[self action_dismiss];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

#pragma mark actions

- (IBAction)action_dismiss
{
	if ([mode isEqualToString:@"table"])
		[nav dismissModalViewControllerAnimated:YES];
	else
		[view_picker removeFromSuperview];
}

@end
