#import "LYLoadingViewController.h"

static LYLoadingViewController *ly_loading_view_controller_manager = nil;

@implementation LYLoadingViewController

@synthesize label_loading;
@synthesize nav;
@synthesize theme;

+ (id)shared
{
	@synchronized(self)
	{
		if (ly_loading_view_controller_manager == nil)
			[[self alloc] init];
	}
	return ly_loading_view_controller_manager;
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (ly_loading_view_controller_manager == nil)
		{
			ly_loading_view_controller_manager = [super allocWithZone:zone];
			return ly_loading_view_controller_manager;
		}
	}
	return nil;
}
- (id)init
{
	//if (self = [super init])
	if (self = [super initWithNibName:@"LYLoadingViewController" bundle:nil])
	{
		self.view.frame = CGRectMake(0, 0, screen_width(), screen_height());
		//self.view.frame = UIScreen.mainScreen.bounds;
		//self.view = ly_alloc_view_loading();
		nav = nil;
		theme = @"";
	}
	return self;
}
+ (UIView*)view
{
	return [[LYLoadingViewController shared] view];
}
+ (UILabel*)label_loading
{
	return [[LYLoadingViewController shared] label_loading];
}
+ (NSString*)theme
{
	return [[LYLoadingViewController shared] theme];
}
+ (void)set_theme:(NSString*)a_theme
{
	[[LYLoadingViewController shared] setTheme:a_theme];
}
+ (void)show
{
	@synchronized (self)
	{
		//	[[LYLoadingViewController view] setFrame:CGRectMake(0, 0, screen_width(), screen_height())];
		//	NSLog(@"LOADING show: %@", [LYLoadingViewController view]);
		//	[[LYLoadingViewController view] setFrame:CGRectMake(0, 0, screen_width(), screen_height())];
		[NSThread detachNewThreadSelector:@selector(start_loading_animation) toTarget:self withObject:nil];
	}
}
+ (void)hide
{
	@synchronized (self)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[[LYLoadingViewController view] removeFromSuperview];
	}
}
+ (void)start_loading_animation
{
	NSString* s;
	@synchronized (self)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		if ([[LYLoadingViewController theme] isEqualToString:@"national motto"])
		{
			s = [NSString stringWithFormat:@"National motto of %@", [LYRandom national_motto]];
			[LYLoadingViewController enable_label:s];
			NSLog(@"LOADING motto: %@", s);
		}
		//	NSLog(@"loading nav check: %@", [[LYLoadingViewController shared] nav]);
		//	NSLog(@"loading nav check: %@", [LYLoadingViewController view]);
		if ([[LYLoadingViewController shared] nav] == nil)
		{
			//NSLog(@"add to window: %@\n%@", (UIWindow*)[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)], [LYLoadingViewController view]);
			[[LYLoadingViewController view] setFrame:CGRectMake(0, 0, screen_width(), screen_height())];
			[(UIWindow*)[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)] addSubview:[LYLoadingViewController view]];
		}
		else
		{
			//NSLog(@"add to nav: %@", [[[LYLoadingViewController shared] nav] view]);
			//NSLog(@"LOADING nav size: %@", [[[[LYLoadingViewController shared] nav] view] frame]);
			//[[LYLoadingViewController view] setFrame:[[[[LYLoadingViewController shared] nav] view] frame]];
			[[LYLoadingViewController view] setFrame:CGRectMake(0, 0, screen_width(), screen_height())];
			[[[[LYLoadingViewController shared] nav] view] addSubview:[LYLoadingViewController view]];
			//	NSLog(@"LOADING screen: %f, %f", screen_width(), screen_height());
			//	NSLog(@"LOADING screen: %@", [LYLoadingViewController view]);
		}
		[pool release];
	}
}

+ (void)enable_label:(NSString*)s
{
	@synchronized (self)
	{
		[LYLoadingViewController label_loading].hidden = NO;
		if (s != nil)
			[LYLoading label_loading].text = s;
	}
}

+ (void)show_label:(NSString*)s
{
	@synchronized (self)
	{
		[LYLoading enable_label:s];
		[[LYLoading shared] setNav:nil];
		[LYLoading show];
	}
}

@end

@implementation LYLoading
@end
