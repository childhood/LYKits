#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface UIView (LYView)

- (UIViewController*)view_controller;
- (UIImage*)screenshot;
- (UIImage*)get_screenshot:(CGRect)screenRect;
- (void)copy_style:(UIView*)target;

//	animation handling
+ (void)begin_animations:(CGFloat)duration;
- (void)move_vertically:(CGFloat)value animated:(BOOL)animated;
- (void)move_horizontally:(CGFloat)value animated:(BOOL)animated;
- (void)reset_x:(CGFloat)f animation:(CGFloat)duration;
- (void)reset_y:(CGFloat)f animation:(CGFloat)duration;
- (void)set_x:(CGFloat)f animation:(CGFloat)duration;
- (void)set_y:(CGFloat)f animation:(CGFloat)duration;
- (void)set_w:(CGFloat)f animation:(CGFloat)duration;
- (void)set_h:(CGFloat)h animation:(CGFloat)duration;

//	autoresizing warp
- (void)autoresizing_add_width:(BOOL)w height:(BOOL)h;
- (void)autoresizing_flexible_left:(BOOL)l right:(BOOL)r top:(BOOL)t bottom:(BOOL)b;

//	frame set / reset
- (void)align_horizon_center;
- (void)set_position:(CGPoint)point;
- (void)set_x:(CGFloat)f;
- (void)set_y:(CGFloat)f;
- (void)set_w:(CGFloat)f;
- (void)set_h:(CGFloat)f;
- (void)set_width:(CGFloat)f;
- (void)set_height:(CGFloat)f;
- (void)reset_x:(CGFloat)f;
- (void)reset_y:(CGFloat)f;
- (void)reset_width:(CGFloat)f;
- (void)reset_height:(CGFloat)f;
- (void)swap_width_height;

//	working with subviews
- (void)remove_subviews;
- (void)release_subviews;
- (void)debug_print_subviews:(BOOL)flag_seperator;

@end
#if 0
@interface UINavigationController (LYViewController)
@end
#endif
