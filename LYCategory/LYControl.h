#import <UIKit/UIKit.h>


@interface UIControl (LYControl)

- (void)disable_for:(CGFloat)duration;
- (void)set_enable;

@end


@interface UIBarButtonItem (LYBarButtonItemControl)

- (void)disable_for:(CGFloat)duration;
- (void)set_enable;

@end
