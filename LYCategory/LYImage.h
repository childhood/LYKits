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

- (UIImage*)image_filter:(NSString*)filter_name dict:(NSDictionary*)dict;
- (UIImage*)image_filter:(NSString*)filter_name key:(NSString*)key v:(id)value;
- (UIImage*)image_filter:(NSString*)filter_name key:(NSString*)key float:(CGFloat)f;
- (UIImage*)image_filter:(NSString*)filter_name key:(NSString*)key r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;

@end
