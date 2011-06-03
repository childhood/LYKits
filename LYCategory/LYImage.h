#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (LYImage)

+ (UIImage*)image_flip_vertically:(UIImage*)originalImage;
+ (UIImage*)image_flip_horizontally:(UIImage*)originalImage;
- (UIImage*)image_with_size_aspect:(CGSize)newSize;
- (UIImage*)image_with_size_aspect_fill:(CGSize)newSize;
- (UIImage*)image_with_size:(CGSize)newSize;
- (UIImage*)image_blur_at:(CGPoint)point;

- (UIImage*)image_overlay_center:(UIImage*)another_image;
- (UIImage*)image_overlay:(UIImage*)another_image rect:(CGRect)a_rect mode:(CGBlendMode)mode alpha:(CGFloat)alpha;

@end

