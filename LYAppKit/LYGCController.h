#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>
#import "LYCategory.h"

/*
	//	init
	gc = [[LYGCController alloc] initWithDelegate:self];
	gc.nav = nav;
	//	...

#pragma mark game center delegate

- (void)gamecenter_authentication_changed
{
	NSLog(@"gc status changed: %i", gc.is_authenticated);
	if (gc.is_authenticated)
	{
		NSLog(@"player: %@", [GKLocalPlayer localPlayer]);
		[self change_profile:[GKLocalPlayer localPlayer].alias];
	}
}

	[gc report_score:score leaderboard:@"org.superarts.myapp.gc.lb.total_points"];
	[gc report_percent:100 achievement:@"org.superarts.myapp.gc.ac.defeat_leo"];

	[gc show_leaderboard];
	[gc show_achievement];
 */

@interface LYGCController: UIViewController
	<GKLeaderboardViewControllerDelegate,
	 GKAchievementViewControllerDelegate>
{
	BOOL		is_authenticated;
	NSObject*	delegate;
	UINavigationController*	nav;
    GKLeaderboardViewController*	controller_leaderboard;
    GKAchievementViewController*	controller_achievement;
}
@property (nonatomic, retain) NSObject*					delegate;
@property (nonatomic, retain) UINavigationController*	nav;
@property (nonatomic) BOOL	is_authenticated;

- (id)initWithDelegate:(NSObject*)an_obj;
- (BOOL)is_available;
- (BOOL)authentication;
- (void)register_authentication_notification;

- (void)show_leaderboard;
- (void)show_achievement;

- (void)report_score:(int64_t)score leaderboard:(NSString*)category;
- (void)report_percent:(float)percent achievement:(NSString*)identifier;

@end
