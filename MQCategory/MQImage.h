#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (MQImage)
+ (UIImage*)image_flip_vertically:(UIImage*)originalImage;
+ (UIImage*)image_flip_horizontally:(UIImage*)originalImage;
- (UIImage*)image_with_size_aspect:(CGSize)newSize;
- (UIImage*)image_with_size:(CGSize)newSize;
- (UIImage*)image_blur_at:(CGPoint)point;
@end

