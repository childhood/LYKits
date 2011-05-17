#include "MQUIKit.h"

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

UIView* mq_alloc_view_loading(void)
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

static MQMiniApps *mq_mini_apps_shared_controller = nil;

@implementation MQMiniApps

@synthesize nav;

+ (id)shared
{
	@synchronized(self)
	{
		if (mq_mini_apps_shared_controller == nil)
			[[self alloc] init];
	}
	return mq_mini_apps_shared_controller;
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (mq_mini_apps_shared_controller == nil)
		{
			mq_mini_apps_shared_controller = [super allocWithZone:zone];
			return mq_mini_apps_shared_controller;
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
	[button addTarget:[MQMiniApps shared] action:@selector(hide_view:) forControlEvents:UIControlEventTouchDown];
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
	[button addTarget:[MQMiniApps shared] action:@selector(hide_controller:) forControlEvents:UIControlEventTouchDown];
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


@implementation MQSpinImageView

@synthesize image_names;
@synthesize factor_sensitivity;
@synthesize factor_sleep;
@synthesize factor_duration;
@synthesize factor_time;

- (void)set_name_format:(NSString*)format from:(NSInteger)head to:(NSInteger)tail
{
	int i;
	NSString* s;

	if (image_names == nil)
		image_names = [[NSMutableArray alloc] init];
	if (self.animationImages != nil)
		[self.animationImages release];		//	TODO: release each image?

	NSMutableArray*	array;
	array = [NSMutableArray arrayWithObjects:nil];
	for (i = head; i <= tail; i++)
	{
		s = [NSString stringWithFormat:format, i];
		[image_names addObject:s];
		[array addObject:[[UIImage alloc] initWithContentsOfFile:[s filename_bundle]]];
	}
	self.animationImages = array;
	self.animationDuration = 0;
	[self stopAnimating];
	//	NSLog(@"SWIPE names: %@", image_names);
	index = 0;
	[self refresh];

	thread_animation = nil;
}

- (void)refresh
{
	self.image = [self.animationImages objectAtIndex:index];
#if 0
	NSString* filename = [image_names objectAtIndex:index];
	//	NSLog(@"loading image: %@", filename);
	if (self.image != nil)
		[self.image release];
	self.image = [[UIImage alloc] initWithContentsOfFile:[filename filename_bundle]];
#endif
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	location_begin = [touch locationInView:self];
	//	NSLog(@"SWIPE touch began: %@", event);
	date_last = [[NSDate date] retain];
	//	[self startAnimating];
	if (thread_animation != nil)
	{
		NSLog(@"stop animation");
		[thread_animation cancel];
		[thread_animation release];
	}
	speed_last = 0;
}

- (NSTimeInterval)update_interval
{
	NSTimeInterval	interval = [date_last timeIntervalSinceNow];

	[date_last release];
	date_last = [[NSDate date] retain];

	return interval;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch*	touch = [[event allTouches] anyObject];
	CGPoint location_new = [touch locationInView:self];
	//CGPoint location_old = [touch previousLocationInView:self];
	//CGFloat		diff = location_new.x - location_old.x;
	CGFloat		diff = location_new.x - location_begin.x;
	CGFloat		step = 2.0 * self.frame.size.width / (CGFloat)image_names.count * factor_sensitivity;

	//NSLog(@"step: %f", step);
#if 1
	int new_index = index;
	//	NSLog(@"diff: %f", diff);
	if (diff > step)
		new_index -= diff / step;
	if (diff < -step)
		new_index -= diff / step;
	while (new_index >= (int)image_names.count)
	{
		new_index -= image_names.count;
	}
	while (new_index < 0)
	{
		new_index += image_names.count;
	}
	
	if (index != new_index)
	{
		index = new_index;
		[self refresh];
		location_begin = location_new;
		speed_last = diff / [self update_interval] * 0.5 + speed_last * 0.5;
		NSLog(@"speed: %f", speed_last);
		//	NSLog(@"index: %i", index);
	}
	//	NSLog(@"id: %i from %@ to %@", (int)self, NSPointToString(location_old), NSPointToString(location_new));
	//	NSLog(@"SWIPE touch moved: %@", event);
#endif
#if 0
	int diff_index;
	self.animationDuration = diff / interval;
	NSLog(@"diff: %f, interval: %f, duration: %f", diff, interval, self.animationDuration);
	if (self.animationDuration != 0)	
		[self startAnimating];
#endif
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location_new = [touch locationInView:self];
	CGPoint location_old = [touch previousLocationInView:self];
	CGFloat interval = [self update_interval];
	int diff = location_new.x - location_old.x;

	//	NSLog(@"id: %i from %@ to %@", (int)self, NSPointToString(location_begin), NSPointToString(location_new));
	//	NSLog(@"id: %i from %@ to %@", (int)self, NSPointToString(location_old), NSPointToString(location_new));
	//	NSLog(@"diff: %i", diff);
	speed_last = diff / interval * 0.5 + speed_last * 0.5;
		NSLog(@"speed: %f, interval %f", speed_last, interval);
	//	thread_animation = [[NSThread alloc] initWithTarget:self selector:@selector(refresh_more:) object:[NSNumber numberWithInteger:diff * 2]];
	[self spin:speed_last * factor_time / -interval];
	//	thread_animation = [[NSThread alloc] initWithTarget:self selector:@selector(refresh_more:) object:[NSNumber numberWithFloat:speed_last * 0.01 / -interval]];
	//	[thread_animation start];
	//	NSLog(@"SWIPE touch ended: %@", event);
	//	[self stopAnimating];
}

- (void)spin:(CGFloat)factor
{
	thread_animation = [[NSThread alloc] initWithTarget:self selector:@selector(refresh_more:) object:[NSNumber numberWithFloat:factor]];
	[thread_animation start];
}

- (void)refresh_more:(NSNumber*)number
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int i, count, direction;
#if 0
	i = [number intValue];
	if (i > 0)
	{
		count = i;
		direction = -1;
	}
	else
	{
		count = -i;
		direction = 1;
	}
#endif
#if 1
	CGFloat f = [number floatValue];
	NSLog(@"refresh factor: %f", f);
	if (f > 0)
	{
		count = f / factor_duration;
		direction = 1;
	}
	else
	{
		count = -f / factor_duration;
		direction = -1;
	}
#endif

	for (i = 0; i < count; i++)
	{
		index += direction;
		if (index < 0)
			index = image_names.count - 1;
		if (index >= image_names.count)
			index = 0;
		//	[self refresh];
		[self performSelectorOnMainThread:@selector(refresh_delay) withObject:nil waitUntilDone:YES];
		usleep(i * factor_sleep);
		if (thread_animation.isCancelled)
			break;
	}
	
	[pool release];
	thread_animation = nil;
}

- (void)apply_default_factors
{
	factor_sleep = 1000;
	factor_duration = 10.0;
	factor_time = 0.01;
	factor_sensitivity = 1.0;
}

- (void)refresh_delay
{
	//	NSLog(@"refreshing %i", index);
	[self refresh];
	//	usleep(50);
}

@end
