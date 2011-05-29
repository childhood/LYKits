#import "LYListController.h"

@implementation LYListController

@synthesize provider_table;
@synthesize dict;
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
	NSLog(@"list load");
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
	//	[table reloadData];

	picker.showsSelectionIndicator = YES;
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
	//	[picker reloadAllComponents];
}

- (void)viewDidUnload
{
#if 1
	[table retain];
	[picker retain];
	[bar_table retain];
	[bar_picker retain];
	[view_table retain];
	[view_picker retain];
#else
	//	provider_table = [provider_table release_nil];
	//	provider_picker = [provider_picker release_nil];
	[super viewDidUnload];
#endif
		NSLog(@"list unload");
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
	[self refresh_named:a_name dict:a_dict default:nil];
}

- (void)refresh_named:(NSString*)a_name dict:(NSDictionary*)a_dict default:(NSString*)a_default
{
	if ([self isViewLoaded] == NO)
		[self viewDidLoad];

	//	table
	bar_table.topItem.title = a_name;
	bar_picker.topItem.title = a_name;
	name = a_name;

	if (dict != nil)
		[dict release];
	dict = [a_dict retain];

	[provider_table.texts removeAllObjects];
	[provider_table.texts addObject:[NSArray arrayWithArray:[[a_dict allKeys] sortedArrayUsingSelector:@selector(compare:)]]];
	[table reloadData];

	//	picker
	[provider_picker.titles removeAllObjects];
	[provider_picker.titles addObject:[[a_dict allKeys] sortedArrayUsingSelector:@selector(compare:)]];
	[picker reloadAllComponents];

	if (a_default != nil)
	{
		[picker selectRow:[[provider_picker.titles objectAtIndex:0] indexOfObject:a_default] inComponent:0 animated:NO];
	}
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
	current_picker_title = nil;
#if 0
	[self.view remove_subviews];
	[self.view addSubview:view_picker];
	[nav presentModalViewController:self animated:YES];
#endif
	self.view.frame = CGRectMake(0, 20, [ly screen_width], [ly screen_height] - 20);
	[nav.view addSubview:view_picker];

	[bar_picker set_y:20 - bar_picker.frame.size.height];
	[picker set_y:264 + picker.frame.size.height];
	view_picker.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	[UIView begin_animations:0.3];
	[bar_picker reset_y:bar_picker.frame.size.height];
	[picker reset_y:-picker.frame.size.height];
	view_picker.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
	[UIView commitAnimations];
}

#pragma mark delegates

- (void)tableView:(UITableView*)table didSelectRowAtIndexPath:(NSIndexPath*)path
{
	//[delegate perform_string:@"list_selected:" with:[dict valueForKey:[provider_table.texts object_at_path:path]]];
	[delegate perform_string:@"list_selected:" with:[provider_table.texts object_at_path:path]];
	[self action_dismiss];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	//	NSLog(@"picker component: %i, row: %i", component, row);
	current_picker_title = [[provider_picker.titles objectAtIndex:0] objectAtIndex:component];		//	FIXME
}

#pragma mark actions

- (IBAction)action_done
{
	if (current_picker_title != nil)
		[delegate perform_string:@"list_selected:" with:current_picker_title];
	[self action_dismiss];
}

- (IBAction)action_dismiss
{
	if ([mode isEqualToString:@"table"])
		[nav dismissModalViewControllerAnimated:YES];
	else
	{
		[UIView begin_animations:0.3];
		[bar_picker reset_y:-bar_picker.frame.size.height];
		[picker reset_y:picker.frame.size.height];
		view_picker.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
		[UIView commitAnimations];
		[view_picker performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
	}
}

@end
