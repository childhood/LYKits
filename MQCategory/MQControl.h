#import <UIKit/UIKit.h>


@interface UIControl (MQControl)

- (void)disable_for:(CGFloat)duration;
- (void)set_enable;

@end


@interface UIBarButtonItem (MQBarButtonItemControl)

- (void)disable_for:(CGFloat)duration;
- (void)set_enable;

@end
