#import <UIKit/UIKit.h>

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	BOOL b = [@"sleep-disabled" setting_bool];
	NSLog(@"disable sleep: %i", b);
	[[UIApplication sharedApplication] setIdleTimerDisabled:b];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
