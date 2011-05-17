#import "MQCategory.h"

@interface UIColor (MQColor)

//	init color with filename
+ (UIColor*)colorNamed:(NSString*)filename;

//	get r, g, b, a values
- (CGFloat)get_red;
- (CGFloat)get_green;
- (CGFloat)get_blue;
- (CGFloat)get_alpha;
- (CGFloat)get_component:(NSInteger)index;
- (UIColor*)invert;
- (UIColor*)dark_color:(CGFloat)l;
- (UIColor*)light_color:(CGFloat)l;

@end
