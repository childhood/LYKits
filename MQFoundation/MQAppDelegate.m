#import "MQAppDelegate.h"

@implementation MQAppDelegate

@synthesize nav;

- (void)app_init
{
	nav = [[UINavigationController alloc] init];
	//	NSLog(@"DELEGATE nav: %@\n%@", nav, nav.view);
}

- (void)app_push:(MQAppController*)app
{
	[nav pushViewController:app animated:YES];
}

- (void)app_load:(MQAppController*)app with:(NSString*)action
{
	[app loadView];
	[app perform_string:action];
	[nav pushViewController:app animated:YES];
}

- (void)dealloc
{
	[nav release];
	[super dealloc];
}

@end
