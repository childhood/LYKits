#import <UIKit/UIKit.h>
#import "LYView.h"

@interface UIScrollView (LYScrollView)
//	BOOL	flag_keep_width;
- (void)set_keep_width:(BOOL)b;

- (void)copy_style:(UIScrollView*)target;
- (void)add_labels:(NSArray*)array;
- (void)add_views:(NSArray*)array;

//	adding subviews (with self content size resizing)
- (CGFloat)add_label:(UILabel*)label height:(CGFloat)height;
- (CGFloat)add_image_view:(UIImageView*)image_view height:(CGFloat)height;
- (CGFloat)add_view:(UIView*)view height:(CGFloat)height;

//	no delegate / event for both controls; use contentInset for self
- (void)pagecontrol_associate:(UIPageControl*)pagecontrol;

@end
