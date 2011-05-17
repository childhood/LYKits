#import <UIKit/UIKit.h>
#import "LYCategory.h"
#import "LYAppController.h"

@class LYAppController;

@interface LYAppDelegate: NSObject <UIApplicationDelegate>
{
	UINavigationController*		nav;
}
@property (nonatomic, retain) UINavigationController*	nav;

- (void)app_init;
- (void)app_push:(LYAppController*)app;
- (void)app_load:(LYAppController*)app with:(NSString*)action;

@end
