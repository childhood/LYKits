#import "MQAdsController.h"

@implementation MQAdsController

@synthesize view_adwhirl;
@synthesize view_mobclix_phone1;
@synthesize view_mobclix_phone2;
@synthesize view_mobclix_pad1;
@synthesize view_mobclix_pad2;
@synthesize view_mobclix_pad3;
@synthesize view_mobclix_pad4;
@synthesize controller_adwhirl;
@synthesize controller_mobclix_phone1;
@synthesize controller_mobclix_phone2;
@synthesize controller_mobclix_pad1;
@synthesize controller_mobclix_pad2;
@synthesize controller_mobclix_pad3;
@synthesize controller_mobclix_pad4;

- (id)initWithID:(int)app
{
	self = [super init];
	app_id = app;

	view_adwhirl = [AdWhirlView requestAdWhirlViewWithDelegate:self];
	view_adwhirl.frame = CGRectMake(0, 0, 320, 48);
	controller_adwhirl = [[UIViewController alloc] initWithView:view_adwhirl];
	//	[view_adwhirl autorelease];

	//	[Mobclix start];
	[Mobclix startWithApplicationId:[self get_mobclix_id]];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		NSLog(@"SUPERADS is phone");
		view_mobclix_phone1 = [self init_mobclix:@"MobclixAdViewiPhone_320x50" frame:CGRectMake(0, 0, 320, 50)];
		view_mobclix_phone2 = [self init_mobclix:@"MobclixAdViewiPhone_300x250" frame:CGRectMake(0, 0, 300, 250)];
		controller_mobclix_phone1 = [[UIViewController alloc] initWithView:view_mobclix_phone1];
		controller_mobclix_phone2 = [[UIViewController alloc] initWithView:view_mobclix_phone2];
	}
	else
	{
		NSLog(@"SUPERADS is pad");
		view_mobclix_pad1 = [self init_mobclix:@"MobclixAdViewiPad_468x60" frame:CGRectMake(0, 0, 468, 60)];
		view_mobclix_pad2 = [self init_mobclix:@"MobclixAdViewiPad_300x250" frame:CGRectMake(0, 0, 300, 250)];
		view_mobclix_pad3 = [self init_mobclix:@"MobclixAdViewiPad_120x600" frame:CGRectMake(0, 0, 120, 600)];
		view_mobclix_pad4 = [self init_mobclix:@"MobclixAdViewiPad_728x90" frame:CGRectMake(0, 0, 728, 90)];
		controller_mobclix_pad1 = [[UIViewController alloc] initWithView:view_mobclix_pad1];
		controller_mobclix_pad2 = [[UIViewController alloc] initWithView:view_mobclix_pad2];
		controller_mobclix_pad3 = [[UIViewController alloc] initWithView:view_mobclix_pad3];
		controller_mobclix_pad4 = [[UIViewController alloc] initWithView:view_mobclix_pad4];
	}

#if 0
	view_adwhirl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;//0;	//UIViewAutoresizingFlexibleTopMargin;
	view_mobclix_phone1.autoresizingMask = 0;	//UIViewAutoresizingFlexibleTopMargin;
	view_mobclix_phone2.autoresizingMask = 0;	//UIViewAutoresizingFlexibleTopMargin;
	view_mobclix_pad1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin || UIViewAutoresizingFlexibleTopMargin;
	view_mobclix_pad2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin || UIViewAutoresizingFlexibleTopMargin;
	view_mobclix_pad3.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin || UIViewAutoresizingFlexibleTopMargin;
	view_mobclix_pad4.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin || UIViewAutoresizingFlexibleTopMargin;
#endif

	return self;
}

- (MobclixAdView*)init_mobclix:(NSString*)a_class frame:(CGRect)rect
{
	MobclixAdView*	view_mobclix;

	//	view_mobclix = [[[NSClassFromString(a_class) alloc] initWithFrame:rect] autorelease];
	view_mobclix = [[NSClassFromString(a_class) alloc] initWithFrame:rect];
	NSLog(@"SUPERADS fixme %@: %@", a_class, [MobclixAdViewiPhone_320x50 class]);
	//	view_mobclix = [[MobclixAdViewiPhone_320x50 alloc] initWithFrame:rect];
	view_mobclix.delegate = self;
	[view_mobclix getAd];
	view_mobclix.refreshTime = k_ads_mobclix_refresh;

	return view_mobclix;
}

#if 0
- (id)init_with_app:(int)app to:(UIView*)window adwhirl:(CGRect)a_rect_adwhirl mobclix:(CGRect)a_rect_mobclix
{
	[self init_with_app:app to:window adwhirl:a_rect_adwhirl mobclix:a_rect_mobclix controller:nil];
	return self;
}

- (id)init_with_app:(int)app to:(UIView*)window adwhirl:(CGRect)a_rect_adwhirl mobclix:(CGRect)a_rect_mobclix controller:(UIViewController*)controller
{
	self = [super init];
	app_id = app;
	controller_adwhirl = controller;

	rect_adwhirl = a_rect_adwhirl;
	rect_mobclix = a_rect_mobclix;

#if 1
	[Mobclix start];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		NSLog(@"SUPERADS is phone");
		view_mobclix = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:rect_mobclix] autorelease];
		view_mobclix.delegate = self;
		[view_mobclix getAd];
		view_mobclix.refreshTime = k_ads_mobclix_refresh;
		[controller.view addSubview:view_mobclix];
	}
	else
	{
		NSLog(@"SUPERADS is pad");
#if 1
		view_mobclix1 = [[[MobclixAdViewiPad_468x60 alloc] initWithFrame:CGRectMake(20, 16, 468, 60)] autorelease];
		view_mobclix1.delegate = self;
		[view_mobclix1 getAd];
		view_mobclix1.refreshTime = k_ads_mobclix_refresh;
		[controller.view addSubview:view_mobclix1];
#endif
#if 1
		view_mobclix2 = [[[MobclixAdViewiPad_300x250 alloc] initWithFrame:CGRectMake(768 - 20 - 300, 16 + 600 + 16, 300, 250)] autorelease];
		view_mobclix2.delegate = self;
		[view_mobclix2 getAd];
		view_mobclix2.refreshTime = k_ads_mobclix_refresh;
		[controller.view addSubview:view_mobclix2];
#endif
#if 0	//	dummy view2
		view_mobclix2 = [[UIView alloc] initWithFrame:CGRectMake(768 - 20 - 120, 16, 120, 600)];
		view_mobclix2.backgroundColor = [UIColor blueColor];
		[controller.view addSubview:view_mobclix2];
#endif
#if 1
		view_mobclix3 = [[[MobclixAdViewiPad_120x600 alloc] initWithFrame:CGRectMake(768 - 20 - 120, 16, 120, 600)] autorelease];
		view_mobclix3.delegate = self;
		[view_mobclix3 getAd];
		view_mobclix3.refreshTime = k_ads_mobclix_refresh;
		[controller.view addSubview:view_mobclix3];
#endif
#if 1
		view_mobclix4 = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(20, 1004 - 90 - 16, 728, 90)] autorelease];
		view_mobclix4.delegate = self;
		[view_mobclix4 getAd];
		view_mobclix4.refreshTime = k_ads_mobclix_refresh;
		[controller.view addSubview:view_mobclix4];
#endif
	}

#if 1
	//ARRollerView* rollerView = [ARRollerView requestRollerViewWithDelegate:self];
	rollerView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
	rollerView.frame = rect_adwhirl;
	[window addSubview:rollerView];
	//	[rollerView autorelease];
#endif

	//controller_mobclix = [[UIViewController alloc] init];
	//controller_mobclix.view = view_mobclix;

#if 0
	view_mobclix.frame = CGRectMake(10, 430, 300, 50);
	[window addSubview:controller_mobclix.view];
#endif
	//	visible area test
#if 0
	view_mobclix = [[UIView alloc] initWithFrame:rect_mobclix];
	view_mobclix.backgroundColor = [UIColor yellowColor];
#endif
	//	[controller.view addSubview:view_mobclix];
	/*
	bannerAdView = [MMABannerXLAdView new];
	bannerAdView = [MobclixAdViewiPhone_300x50 new];
	bannerAdView.frame = rect_mobclix;
	bannerAdView.delegate = self;

	[bannerAdView getAd];
	bannerAdView.refreshTime = k_ads_mobclix_refresh;

	[window addSubview:bannerAdView];
	*/
	//	[bannerAdView autorelease];
#endif

	return self;
}
#endif

- (NSString*)adWhirlApplicationKey
{
	switch (app_id)
	{
		case k_ads_asianboobs:
			return @"00f9f977498d102d840c2e1e0de86337";		//	AsianBoobs
		case k_ads_hotgirls:
			return @"eb12fdc32ba3102da8949a322e50052a";		//	HotGirls
		case k_ads_modmyi:
			return @"9c4e74bbf709102c96dc5b26aef5c1e9";		//	ModMyI - winbugs, currently
		default:
			NSLog(@"SUPERADS wrong app id");
	}
	return @"eb12fdc32ba3102da8949a322e50052a";		//	HotGirls
}

- (NSString*)get_mobclix_id
{
	switch (app_id)
	{
		case k_ads_asianboobs:
			return @"eadd27ad-ab72-42f8-86cf-8f2c717d16ab";
		case k_ads_hotgirls:
			return @"eadd27ad-ab72-42f8-86cf-8f2c717d16ab";
		case k_ads_modmyi:
			return @"453ea50b-f472-4296-a06c-9d4300d87dfb";
		default:
			NSLog(@"SUPERADS wrong mobclix id");
	}
	return @"eadd27ad-ab72-42f8-86cf-8f2c717d16ab";
}

- (void)rollerDidReceiveAd:(ARRollerView*)adWhirlView
{
	NSLog(@"SUPERADS roller received: %@", [adWhirlView mostRecentNetworkName]);
	//	resize
#if 0
	[UIView beginAnimations:@"AdResize" context:nil];
	[UIView setAnimationDuration:0.7];
	CGSize adSize = [adWhirlView actualAdSize];
	CGRect newFrame = adWhirlView.frame;
	newFrame.size.height = adSize.height; 
	// fit the ad
	newFrame.size.width = adSize.width;
	newFrame.origin.x = (controller_adwhirl.view.bounds.size.width - adSize.width)/2; 
	// center
	adWhirlView.frame = newFrame;
	// ... adjust surrounding views here ...
	[UIView commitAnimations];
#endif
}

- (void)rollerDidFailToReceiveAd:(ARRollerView*)adWhirlView usingBackup:(BOOL)YesOrNo
{
	NSLog(@"SUPERADS roller failed: %@. Backup: %@", [adWhirlView mostRecentNetworkName], YesOrNo ? @"YES" : @"NO");
}

- (void)adView: (MobclixAdView*) adView didFailLoadWithError: (NSError*) error
{
	NSLog(@"SUPERADS mobclix got error: %i - %@", error.code, error.localizedDescription);
}

- (void)adViewWillTouchThrough:(MobclixAdView*)adView
{
	NSLog(@"SUPERADS mobclix will touch: %@", adView);
	UIWindow* window = [[[UIApplication sharedApplication] delegate] performSelector:@selector(window)];
#if 0
	superview_mobclix_pad1 = view_mobclix_pad1.superview;
	superview_mobclix_pad2 = view_mobclix_pad2.superview;
	superview_mobclix_pad3 = view_mobclix_pad3.superview;
	superview_mobclix_pad4 = view_mobclix_pad4.superview;
	[window addSubview:view_mobclix_pad1];
	[window addSubview:view_mobclix_pad2];
	[window addSubview:view_mobclix_pad3];
	[window addSubview:view_mobclix_pad4];
#endif
	adView.hidden = YES;
	current_rect_mobclix = adView.frame;
	superview_mobclix = adView.superview;
	[window addSubview:adView];
	//	[self hide_ads];
}

- (void)adViewDidFinishTouchThrough:(MobclixAdView*)adView
{
	NSLog(@"SUPERADS mobclix touched: %@", adView);
#if 0
	[superview_mobclix_pad1 addSubview:view_mobclix_pad1];
	[superview_mobclix_pad2 addSubview:view_mobclix_pad2];
	[superview_mobclix_pad3 addSubview:view_mobclix_pad3];
	[superview_mobclix_pad4 addSubview:view_mobclix_pad4];
#endif
	adView.frame = current_rect_mobclix;
	[superview_mobclix addSubview:adView];
	adView.hidden = NO;
	//	[self show_ads];
}

- (void)hide_ads
{
	view_adwhirl.hidden = YES;
	view_mobclix_phone1.hidden = YES;
	view_mobclix_phone2.hidden = YES;
	view_mobclix_pad1.hidden = YES;
	view_mobclix_pad2.hidden = YES;
	view_mobclix_pad3.hidden = YES;
	view_mobclix_pad4.hidden = YES;
}

- (void)show_ads
{
	view_adwhirl.hidden = NO;
	view_mobclix_phone1.hidden = NO;
	view_mobclix_phone2.hidden = NO;
	view_mobclix_pad1.hidden = NO;
	view_mobclix_pad2.hidden = NO;
	view_mobclix_pad3.hidden = NO;
	view_mobclix_pad4.hidden = NO;
}

- (UIViewController *)viewControllerForPresentingModalView
{
	return controller_adwhirl;
}

- (void)adWhirlReceivedRequestForDeveloperToFufill:(AdWhirlView *)adWhirlView
{
	NSLog(@"SUPERADS adwhirl generic notification");
}

- (void)enable_test
{
	view_adwhirl.backgroundColor = [UIColor redColor];
	view_mobclix_phone1.backgroundColor = [UIColor blueColor];
	view_mobclix_phone2.backgroundColor = [UIColor blueColor];
	view_mobclix_pad1.backgroundColor = [UIColor greenColor];
	view_mobclix_pad2.backgroundColor = [UIColor greenColor];
	view_mobclix_pad3.backgroundColor = [UIColor greenColor];
	view_mobclix_pad4.backgroundColor = [UIColor greenColor];
}

- (void)set_alpha:(CGFloat)alpha
{
	view_adwhirl.alpha = alpha;
	view_mobclix_phone1.alpha = alpha;
	view_mobclix_phone2.alpha = alpha;
	view_mobclix_pad1.alpha = alpha;
	view_mobclix_pad2.alpha = alpha;
	view_mobclix_pad3.alpha = alpha;
	view_mobclix_pad4.alpha = alpha;
}

@end
