#import "MQAppController.h"

@implementation MQAppController

@synthesize nav;

- (id)initWithApp:(MQAppDelegate*)app nib:(NSString*)nib
{
	if (nib != nil)
		self = [super initWithNibName:nib bundle:nil];
	else
		self = [super init];

	if (self != nil)
	{
		delegate = app;
		nav = app.nav;
		//	NSLog(@"APP nav: %@", nav);
	}
	return self;
}

- (id)initWithNav:(UINavigationController*)a_nav nib:(NSString*)nib
{
	if (nib != nil)
		self = [super initWithNibName:nib bundle:nil];
	else
		self = [super init];

	if (self != nil)
	{
		nav = a_nav;
		//	NSLog(@"APP nav: %@", nav);
	}
	return self;
}

@end
