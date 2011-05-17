#import "MQScrollTabController.h"

@implementation MQScrollTabController: UIViewController

@synthesize delegate;
@synthesize scroll_view;

- (id)initWithFrame:(CGRect)frame delegate:(id)a_delegate
{
	self = [super init];
	if (self != nil)
	{
		array_buttons = [[NSMutableArray alloc] init];
		delegate = a_delegate;
		self.view.frame = frame;

		scroll_view = [[UIScrollView alloc] initWithFrame:frame];
		scroll_view.contentSize = [delegate scroll_tab_size:self];
		//	NSLog(@"DEBUG content size: %@", NSStringFromCGSize(scroll_view.contentSize));
		//	scroll_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:k_filename_bg]];
		scroll_view.pagingEnabled = NO;
		scroll_view.bounces = YES;
		scroll_view.showsHorizontalScrollIndicator = NO;
		scroll_view.showsVerticalScrollIndicator = NO;
		[self.view addSubview:scroll_view];
		//	NSLog(@"DEBUG added scroll view: %@", scroll_view);

		[self reload_buttons];
		//	NSLog(@"DEBUG count: %i - %@", count, array_buttons);
	}
	return self;
}

- (void)reload_data
{
	scroll_view.contentSize = [delegate scroll_tab_size:self];
	scroll_view.contentOffset = CGPointMake(0, 0);
	[self reload_buttons];
}

- (void)reload_buttons
{
	UIButton*	button;
	NSInteger	i;

	//	remove old buttons
	for (i = 0; i < count; i++)
	{
		[[array_buttons objectAtIndex:i] removeFromSuperview];
	}
	[array_buttons removeAllObjects];

	//	add new buttons
	count = [delegate scroll_tab_count:self];
	for (i = 0; i < count; i++)
	{
		button = [delegate scroll_tab:self alloc_button_for_index:i];
		[button addTarget:self action:@selector(action_button_pressed:) forControlEvents:UIControlEventTouchUpInside];
		[array_buttons addObject:button];
		[scroll_view addSubview:button];
		//	NSLog(@"DEBUG button added %i: %@ - total %@", i, button, array_buttons);
		[button release];
	}
}

- (void)action_button_pressed:(id)sender
{
	int i;

	//	NSLog(@"DEBUG button pressed... %@ = %@", sender, array_buttons.description);
	for (i = 0; i < count; i++)
	{
		if ([array_buttons objectAtIndex:i] == sender)
		{
			//	NSLog(@"DEBUG button pressed: %i", i);
			[delegate scroll_tab:self did_select_index:i];
			return;
		}
	}
}

- (void)dealloc
{
	[array_buttons release];
	[scroll_view release];
	[self.view release];
	[super dealloc];
}

@end
