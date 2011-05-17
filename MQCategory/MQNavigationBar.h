#import <UIKit/UIKit.h>

@interface UINavigationBar (MQNavigationBar) 

UIImageView*	bg;

- (void)set_background_image:(UIImage*)image;
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index;
- (void)sendBackgroundToBack;

@end
