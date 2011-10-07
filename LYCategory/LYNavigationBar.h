#import <UIKit/UIKit.h>
#import "LYCategory.h"

@interface UINavigationBar (LYNavigationBar) 

//	UIImageView*	bg;

- (void)set_background_image:(UIImage*)image;
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index;
- (void)sendBackgroundToBack;

@end
