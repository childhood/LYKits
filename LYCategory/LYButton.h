#import <UIKit/UIKit.h>

@interface UIButton (LYButton)

- (void)set_title:(NSString*)title;
- (void)set_image_named:(NSString*)filename;
- (void)set_background_named:(NSString*)filename;

- (void)switch_state:(UIControlState)state1 state:(UIControlState)state2;
- (void)switch_state;

@end
