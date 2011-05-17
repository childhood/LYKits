#import <UIKit/UIKit.h>
#import "MQAppDelegate.h"

@class MQAppDelegate;

@interface MQAppController: UIViewController
{
	MQAppDelegate*				delegate;
	UINavigationController*		nav;
}
@property (nonatomic, retain) UINavigationController*	nav;

- (id)initWithApp:(MQAppDelegate*)app nib:(NSString*)nib;
- (id)initWithNav:(UINavigationController*)a_nav nib:(NSString*)nib;

@end
