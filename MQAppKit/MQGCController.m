#import "MQGCController.h"

@implementation MQGCController

@synthesize delegate;
@synthesize nav;
@synthesize is_authenticated;

- (id)initWithDelegate:(NSObject*)an_obj
{
	self = [super init];
	if (self != nil)
	{
		is_authenticated = NO;
		if (an_obj != nil)
		{
			delegate = an_obj;

			if ([self authentication] == YES)
				[self register_authentication_notification];
		}
	}
	return self;
}

- (void)register_authentication_notification
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(authentication_changed)
			   name:GKPlayerAuthenticationDidChangeNotificationName
			 object:nil];
}

- (void)authentication_changed
{
	if ([GKLocalPlayer localPlayer].isAuthenticated)
		is_authenticated = YES;
	else
		is_authenticated = NO;

	[delegate perform_string:@"gamecenter_authentication_changed"];
}

- (BOOL)is_available
{
	// Check for presence of GKLocalPlayer API.
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));

	// The device must be running running iOS 4.1 or later.
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);

	return (gcClass && osVersionSupported);
}

- (BOOL)authentication
{
	if ([self is_available] == NO)
		return NO;

	NSLog(@"GC authentication started");
	[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
		if (error == nil)
		{
			is_authenticated = YES;
		}
		else
		{
			NSLog(@"GC authentication failed: %@", error);
			is_authenticated = NO;
		}
		[delegate perform_string:@"gamecenter_authentication_changed"];
	}];
	return YES;
}

#pragma mark leaderboard

- (void)report_score:(int64_t)score leaderboard:(NSString*)category
{
	if (is_authenticated == NO)
		return;

	GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
	scoreReporter.value = score;
	NSLog(@"GC report score: %@", scoreReporter);

	[scoreReporter reportScoreWithCompletionHandler:^(NSError *error)
	{
		if (error != nil)
		{
			NSLog(@"GC report score failed: %@", error);
			[delegate perform_string:@"gamecenter_error:" with:@"report_leaderboard"];
		}
		else
		{
			NSLog(@"GC report score done");
		}
	}];
}

- (void)show_leaderboard
{
	if (is_authenticated == NO)
	{
		[@"Game Center Not Available" show_alert_message:@"You need to enable Game Center to use this feature."];
		return;
	}
	controller_leaderboard = [[GKLeaderboardViewController alloc] init];
	if (controller_leaderboard != nil)
	{
		controller_leaderboard.leaderboardDelegate = self;
		[nav presentModalViewController:controller_leaderboard animated:YES];
	}
	[controller_leaderboard release];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[nav dismissModalViewControllerAnimated:YES];
}

#pragma mark achievement

- (void)report_percent:(float)percent achievement:(NSString*)identifier
{
	if (is_authenticated == NO)
		return;

	GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
	NSLog(@"GC report achievement: %@", achievement);
	if (achievement)
	{
		achievement.percentComplete = percent;
		[achievement reportAchievementWithCompletionHandler:^(NSError *error)
		{
			if (error != nil)
			{
				NSLog(@"GC report achievement failed: %@", error);
				[delegate perform_string:@"gamecenter_error:" with:@"report_achievement"];
			}
			else
				NSLog(@"GC report achievement done");
		}];
	}
}
- (void)show_achievement
{
	if (is_authenticated == NO)
	{
		[@"Game Center Not Available" show_alert_message:@"You need to enable Game Center to use this feature."];
		return;
	}
	controller_achievement = [[GKAchievementViewController alloc] init];
	if (controller_achievement != nil)
	{
		controller_achievement.achievementDelegate = self;
		[nav presentModalViewController:controller_achievement animated:YES];
	}
	[controller_achievement release];
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	[nav dismissModalViewControllerAnimated:YES];
}

@end
