#import "LYPublic.h"

#define ly	LYKits

//	LYKits.h = MYPublic.h + LYKits Singleton Class

@interface LYKits: LYSingletonClass
{
    NSString*		version;
}
@property (nonatomic, retain) NSString*		version;
+ (id)shared;

+ (NSString*)version_string;
+ (BOOL)is_phone;
+ (BOOL)is_pad;

+ (UIInterfaceOrientation)get_interface_orientation;
+ (BOOL)is_interface_portrait;
+ (BOOL)is_interface_landscape;
+ (CGFloat)get_width:(CGFloat)width;
+ (CGFloat)get_height:(CGFloat)height;
+ (CGFloat)screen_width;
+ (CGFloat)screen_height;
+ (CGFloat)screen_max;

@end
