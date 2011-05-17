#import <UIKit/UIKit.h>
#import "MQView.h"

@interface UIScrollView (MQScrollView)
BOOL	flag_keep_width;
- (void)set_keep_width:(BOOL)b;

- (void)copy_style:(UIScrollView*)target;
- (void)add_labels:(NSArray*)array;
- (void)add_views:(NSArray*)array;

//	adding subviews (with self content size resizing)
- (CGFloat)add_label:(UILabel*)label height:(CGFloat)height;
- (CGFloat)add_image_view:(UIImageView*)image_view height:(CGFloat)height;
- (CGFloat)add_view:(UIView*)view height:(CGFloat)height;

@end
