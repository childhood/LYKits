#import "MQLoadingViewController.h"

static MQLoadingViewController *mq_loading_view_controller_manager = nil;

@implementation MQLoadingViewController

@synthesize label_loading;
@synthesize nav;
@synthesize theme;

+ (id)shared
{
	@synchronized(self)
	{
		if (mq_loading_view_controller_manager == nil)
			[[self alloc] init];
	}
	return mq_loading_view_controller_manager;
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (mq_loading_view_controller_manager == nil)
		{
			mq_loading_view_controller_manager = [super allocWithZone:zone];
			return mq_loading_view_controller_manager;
		}
	}
	return nil;
}
- (id)init
{
	//if (self = [super init])
	if (self = [super initWithNibName:@"MQLoadingViewController" bundle:nil])
	{
		self.view.frame = CGRectMake(0, 0, screen_width(), screen_height());
		//self.view.frame = UIScreen.mainScreen.bounds;
		//self.view = mq_alloc_view_loading();
		nav = nil;
		theme = @"";
	}
	return self;
}
+ (UIView*)view
{
	return [[MQLoadingViewController shared] view];
}
+ (UILabel*)label_loading
{
	return [[MQLoadingViewController shared] label_loading];
}
+ (NSString*)theme
{
	return [[MQLoadingViewController shared] theme];
}
+ (void)set_theme:(NSString*)a_theme
{
	[[MQLoadingViewController shared] setTheme:a_theme];
}
+ (void)show
{
	@synchronized (self)
	{
		//	[[MQLoadingViewController view] setFrame:CGRectMake(0, 0, screen_width(), screen_height())];
		//	NSLog(@"LOADING show: %@", [MQLoadingViewController view]);
		//	[[MQLoadingViewController view] setFrame:CGRectMake(0, 0, screen_width(), screen_height())];
		[NSThread detachNewThreadSelector:@selector(start_loading_animation) toTarget:self withObject:nil];
	}
}
+ (void)hide
{
	@synchronized (self)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[[MQLoadingViewController view] removeFromSuperview];
	}
}
+ (void)start_loading_animation
{
	NSString* s;
	@synchronized (self)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		if ([[MQLoadingViewController theme] isEqualToString:@"national motto"])
		{
			s = [NSString stringWithFormat:@"National motto of %@", [MQRandom national_motto]];
			[MQLoadingViewController enable_label:s];
			NSLog(@"LOADING motto: %@", s);
		}
		//	NSLog(@"loading nav check: %@", [[MQLoadingViewController shared] nav]);
		//	NSLog(@"loading nav check: %@", [MQLoadingViewController view]);
		if ([[MQLoadingViewController shared] nav] == nil)
			[(UIWindow*)[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)] addSubview:[MQLoadingViewController view]];
		else
		{
			//NSLog(@"LOADING nav size: %@", [[[[MQLoadingViewController shared] nav] view] frame]);
			//[[MQLoadingViewController view] setFrame:[[[[MQLoadingViewController shared] nav] view] frame]];
			[[MQLoadingViewController view] setFrame:CGRectMake(0, 0, screen_width(), screen_height())];
			[[[[MQLoadingViewController shared] nav] view] addSubview:[MQLoadingViewController view]];
			//	NSLog(@"LOADING screen: %f, %f", screen_width(), screen_height());
			//	NSLog(@"LOADING screen: %@", [MQLoadingViewController view]);
		}
		[pool release];
	}
}

+ (void)enable_label:(NSString*)s
{
	@synchronized (self)
	{
		[MQLoadingViewController label_loading].hidden = NO;
		if (s != nil)
			[MQLoading label_loading].text = s;
	}
}

@end

@implementation MQLoading
@end
