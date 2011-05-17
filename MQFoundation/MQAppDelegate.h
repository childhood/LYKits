#import <UIKit/UIKit.h>
#import "MQCategory.h"
#import "MQAppController.h"

@class MQAppController;

@interface MQAppDelegate: NSObject <UIApplicationDelegate>
{
	UINavigationController*		nav;
}
@property (nonatomic, retain) UINavigationController*	nav;

- (void)app_init;
- (void)app_push:(MQAppController*)app;
- (void)app_load:(MQAppController*)app with:(NSString*)action;

@end
