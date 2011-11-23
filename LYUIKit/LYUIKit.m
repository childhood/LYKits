#import "LYUIKit.h"

BOOL CGPointInRect(CGPoint point, CGRect rect)
{
	if ((rect.origin.x <= point.x) &&
		(rect.origin.y <= point.y) &&
		(point.x <= (rect.origin.x + rect.size.width)) &&
		(point.y <= (rect.origin.y + rect.size.height)))
	{
		return YES;
	}
	return NO;
}

UIInterfaceOrientation get_interface_orientation()
{
	return [[UIApplication sharedApplication] statusBarOrientation];
}

BOOL is_interface_portrait()
{
	if ((get_interface_orientation() == UIInterfaceOrientationPortrait) ||
		(get_interface_orientation() == UIInterfaceOrientationPortraitUpsideDown))
		return YES;
	else
		return NO;
}

BOOL is_interface_landscape()
{
	if ((get_interface_orientation() == UIInterfaceOrientationLandscapeLeft) ||
		(get_interface_orientation() == UIInterfaceOrientationLandscapeRight))
		return YES;
	else
		return NO;
}

CGFloat get_width(CGFloat width)
{
	if ((get_interface_orientation() == UIInterfaceOrientationPortrait) ||
		(get_interface_orientation() == UIInterfaceOrientationPortraitUpsideDown))
		return width * UIScreen.mainScreen.bounds.size.width;
	else
		return width * UIScreen.mainScreen.bounds.size.height;
}

CGFloat get_height(CGFloat height)
{
	if ((get_interface_orientation() == UIInterfaceOrientationPortrait) ||
		(get_interface_orientation() == UIInterfaceOrientationPortraitUpsideDown))
		return height * UIScreen.mainScreen.bounds.size.height;
	else
		return height * UIScreen.mainScreen.bounds.size.width;
}

CGFloat screen_width()
{
	return get_width(1);
}

CGFloat screen_height()
{
	return get_height(1);
}

CGFloat screen_max()
{
	if (screen_width() > screen_height())
		return screen_width();
	else
		return screen_height();
}

UIView* ly_alloc_view_loading(void)
{
	CGRect	rect = UIScreen.mainScreen.bounds;
	UIView*	view;

	view = [[UIView alloc] initWithFrame:rect];
	view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];

	UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	indicator.frame = CGRectMake(rect.size.width / 2 - 10, rect.size.height / 2 - 10, 20, 20);
	[indicator startAnimating];

	[view addSubview:indicator];

	return view;
}


#if 0
//	TODO replace with LYMiniAppsController
static LYMiniApps *ly_mini_apps_shared_controller = nil;

@implementation LYMiniApps

@synthesize nav;

+ (id)shared
{
	@synchronized(self)
	{
		if (ly_mini_apps_shared_controller == nil)
			[[self alloc] init];
	}
	return ly_mini_apps_shared_controller;
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (ly_mini_apps_shared_controller == nil)
		{
			ly_mini_apps_shared_controller = [super allocWithZone:zone];
			return ly_mini_apps_shared_controller;
		}
	}
	return nil;
}
- (id)initWithNavigationController:(UINavigationController*)a_nav
{
	if (self = [super init])
	{
		nav = a_nav;
	}
	return self;
}

- (void)show_flashlight:(UIColor*)color
{
	status_bar_hidden = [[UIApplication sharedApplication] isStatusBarHidden];

	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(-100, -100, 2148, 2148)];
	button.backgroundColor = color;
	button.alpha = 0.01;
	[button addTarget:[LYMiniApps shared] action:@selector(hide_view:) forControlEvents:UIControlEventTouchDown];
	[[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)] addSubview:button];
	if (status_bar_hidden == NO)
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

	[UIView begin_animations:0.3];
	button.alpha = 1;
	[UIView commitAnimations];
}

- (void)show_image:(NSString*)filename
{
	UIViewController* controller = [[UIViewController alloc] init];
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen_width(), screen_height())];

	status_bar_hidden = [[UIApplication sharedApplication] isStatusBarHidden];
	if (status_bar_hidden == NO)
		[button reset_height:-20];
	controller.view = button;
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	button.backgroundColor = [UIColor clearColor];
	[button autoresizing_add_width:YES height:YES];
	[button set_background_named:filename];
	//[button set_image_named:filename];
	[button addTarget:[LYMiniApps shared] action:@selector(hide_controller:) forControlEvents:UIControlEventTouchDown];
	if (nav == nil)
		[[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)] addSubview:button];
	else
		[nav presentModalViewController:controller animated:YES];
}

- (void)hide_view:(UIView*)view
{
	if (status_bar_hidden == NO)
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	[UIView begin_animations:0.3];
	view.alpha = 0.01;
	[UIView commitAnimations];

	[self performSelector:@selector(remove_release:) withObject:view afterDelay:0.3];
}

- (void)hide_controller:(UIView*)view
{
	//	if (status_bar_hidden == NO)
	//		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	[nav dismissModalViewControllerAnimated:YES];
	[[view view_controller] release];
	[view release];
}

- (void)remove_release:(UIView*)view
{
	[view removeFromSuperview];
	[view release];
}

@end
#endif
