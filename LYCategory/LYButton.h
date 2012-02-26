#import <UIKit/UIKit.h>
#import "LYCategory.h"

@interface UIButton (LYButton)

- (void)set_title:(NSString*)title;
- (void)set_image_named:(NSString*)filename;
- (void)set_background_named:(NSString*)filename;
- (void)auto_resize;

- (void)reload_setting;

- (void)bind_setting:(NSString*)key target:(id)target action:(NSString*)action;
- (void)switch_state:(UIControlState)state1 state:(UIControlState)state2;
- (void)switch_state;
//- (BOOL)flipped;

@end
