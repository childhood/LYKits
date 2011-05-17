#import <UIKit/UIKit.h>
#import "LYAppDelegate.h"

@class LYAppDelegate;

@interface LYAppController: UIViewController
{
	LYAppDelegate*				delegate;
	UINavigationController*		nav;
}
@property (nonatomic, retain) UINavigationController*	nav;

- (id)initWithApp:(LYAppDelegate*)app nib:(NSString*)nib;
- (id)initWithNav:(UINavigationController*)a_nav nib:(NSString*)nib;

@end
