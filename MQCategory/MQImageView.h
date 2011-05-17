#import "MQPublic.h"

@interface UIImageView (MQImage)

- (id)initWithImageNamed:(NSString*)filename;
- (void)draw_frame_with_r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a width:(CGFloat)width;
- (void)draw_cross_with_r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a width:(CGFloat)width;
- (void)draw_frame_black;
- (void)draw_frame_white;
- (void)draw_cross_black;
- (void)draw_cross_white;

@end
