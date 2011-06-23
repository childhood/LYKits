#import "LYScrollTabController.h"

@implementation LYScrollTabController

@synthesize delegate;
@synthesize buttons;
@synthesize scroll_view;

- (id)initWithFrame:(CGRect)frame delegate:(id)a_delegate
{
	self = [super init];
	if (self != nil)
	{
		buttons = [[NSMutableArray alloc] init];
		delegate = a_delegate;
		self.view.frame = frame;

		scroll_view = [[UIScrollView alloc] initWithFrame:frame];
		scroll_view.contentSize = [delegate scroll_tab_size:self];
		//	scroll_view.autoresizingMask = 0;
		//	NSLog(@"DEBUG content size: %@", NSStringFromCGSize(scroll_view.contentSize));
		//	scroll_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:k_filename_bg]];
		scroll_view.pagingEnabled = NO;
		scroll_view.bounces = YES;
		scroll_view.showsHorizontalScrollIndicator = NO;
		scroll_view.showsVerticalScrollIndicator = NO;
		[self.view addSubview:scroll_view];
		//	NSLog(@"DEBUG added scroll view: %@", scroll_view);

		[self reload_buttons];
		//	NSLog(@"DEBUG count: %i - %@", count, buttons);
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
		[[buttons objectAtIndex:i] removeFromSuperview];
	}
	[buttons removeAllObjects];

	//	add new buttons
	count = [delegate scroll_tab_count:self];
	for (i = 0; i < count; i++)
	{
		button = [delegate scroll_tab:self alloc_button_for_index:i];
		[button addTarget:self action:@selector(action_button_pressed:) forControlEvents:UIControlEventTouchUpInside];
		[buttons addObject:button];
		[scroll_view addSubview:button];
		//	NSLog(@"DEBUG button added %i: %@ - total %@", i, button, buttons);
		[button release];
	}
}

- (void)action_button_pressed:(id)sender
{
	int i;

	//	NSLog(@"DEBUG button pressed... %@ = %@", sender, buttons.description);
	for (i = 0; i < count; i++)
	{
		if ([buttons objectAtIndex:i] == sender)
		{
			//	NSLog(@"DEBUG button pressed: %i", i);
			[delegate scroll_tab:self did_select_index:i];
			return;
		}
	}
}

- (void)dealloc
{
	[buttons release];
	[scroll_view release];
	[self.view release];
	[super dealloc];
}

@end


@implementation LYScrollTabBarController

@synthesize scroll_tab;
@synthesize data;
@synthesize index;
@synthesize height;

- (id)init
{
	self = [super init];
	if (self)
	{
		height = 49;
		scroll_tab = [[LYScrollTabController alloc] initWithFrame:CGRectMake(0, 0, [ly screen_width], height) delegate:self];
		index = 0;
		data = [[NSMutableArray alloc] init];

		self.view.backgroundColor = [UIColor grayColor];
	}

	return self;
}

- (void)dealloc
{
	[scroll_tab release];
	[data release];
	[super dealloc];
}

- (void)reload
{
	int i;
	UIViewController* controller;

	[scroll_tab.view set_y:[ly screen_height] - height - 20];
	[scroll_tab.view set_h:height];
	[scroll_tab.scroll_view set_h:height];
	[scroll_tab reload_data];

	for (i = 0; i < data.count; i++)
	{
		UIButton* button = [scroll_tab.buttons i:i];
		[[[[data i:index] v:@"controller"] view] removeFromSuperview];
		if (index == i)
		{
			button.selected = YES;
			button.userInteractionEnabled = NO;
			//[button setBackgroundImage:[UIImage imageNamed:[[data i:i] v:@"bg-selected"]] forState:UIControlStateHighlighted];
		}
		else
		{
			button.selected = NO;
			button.userInteractionEnabled = YES;
			//[button setBackgroundImage:[UIImage imageNamed:[[data i:i] v:@"bg-normal"]] forState:UIControlStateHighlighted];
		}
	}

	controller = [[data i:index] v:@"controller"];
	[self.view addSubview:controller.view];
	[self.view bringSubviewToFront:scroll_tab.view];
	[controller.view set_y:-20];
	[controller.view set_h:screen_height() - height];
	//	NSLog(@"subview added: %@", controller.view);

	[scroll_tab.view removeFromSuperview];
	[self.view addSubview:scroll_tab.view];
}

- (void)show:(CGFloat)duration
{
	UIViewController* controller = [[data i:index] v:@"controller"];
	//	scroll_tab.view.hidden = NO;
#if 1
	[scroll_tab.view set_y:[ly screen_height] - height - 20 animation:duration];
	[controller.view set_h:screen_height() - height];
#else
	[UIView begin_animations:duration];
	[scroll_tab.view set_y:[ly screen_height] - height - 20];
	[controller.view set_h:screen_height() - height];
	[UIView commitAnimations];
#endif
}

- (void)hide:(CGFloat)duration
{
	UIViewController* controller = [[data i:index] v:@"controller"];
	//	scroll_tab.view.hidden = YES;
#if 1
	[scroll_tab.view set_y:[ly screen_height] - 20 animation:duration];
	[controller.view set_h:screen_height()];
#else
	[UIView begin_animations:duration];
	[scroll_tab.view set_y:[ly screen_height] - 20];
	[controller.view set_h:screen_height()];
	[UIView commitAnimations];
#endif
}

#pragma mark data source

- (NSInteger)scroll_tab_count:(LYScrollTabController*)controller_tab
{
	return data.count;
}

- (CGSize)scroll_tab_size:(LYScrollTabController*)controller_tab
{
	return CGSizeMake([ly screen_width], height);
}

- (UIButton*)scroll_tab:(LYScrollTabController*)controller_tab alloc_button_for_index:(NSInteger)an_index
{
	UIButton* button;
	button = [[UIButton alloc] initWithFrame:CGRectMake(80 * an_index, 0, 80, height)];
	//	button.autoresizingMask = 0;
	[button setBackgroundImage:[UIImage imageNamed:[[data i:an_index] v:@"bg-normal"]] forState:UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:[[data i:an_index] v:@"bg-selected"]] forState:UIControlStateSelected];
	return button;
}

#pragma mark delegate

- (void)scroll_tab:(LYScrollTabController*)controller_tab did_select_index:(NSInteger)an_index
{
	index = an_index;
	[self reload];
}

@end
