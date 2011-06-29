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

+ (UIBarButtonItem*)alloc_item_named:(NSString*)filename target:(id)target action:(SEL)action;

#ifdef LY_ENABLE_MUSICKIT
+ (NSInteger)media_count_artist:(NSString*)artist album:(NSString*)album title:(NSString*)title;
+ (NSObject*)alloc_media_item_artist:(NSString*)artist album:(NSString*)album title:(NSString*)title;
#endif

+ (NSDictionary*)dict_itunes_country;
+ (NSDictionary*)dict_itunes_genre;
+ (NSDictionary*)dict_itunes_limit;
+ (NSDictionary*)dict_country_code2;

@end
