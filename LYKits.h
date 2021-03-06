#import "LYPublic.h"
#import <CoreMotion/CoreMotion.h>
#include <sys/xattr.h>

#ifdef LY_ENABLE_MAPKIT
#	import <MapKit/MapKit.h>
#endif

#define ly	LYKits

//	LYKits.h = MYPublic.h + LYKits Singleton Class

@interface LYKits: LYSingletonClass
{
    NSString*				version;
	NSMutableDictionary*	data;
}
@property (nonatomic, retain) NSString*				version;
@property (nonatomic, retain) NSMutableDictionary*	data;
+ (id)shared;

+ (NSString*)version_string;
+ (NSMutableDictionary*)data;

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

+ (CMMotionManager*)motion_manager;

+ (UIBarButtonItem*)alloc_item_named:(NSString*)filename target:(id)target action:(SEL)action;
+ (UIBarButtonItem*)alloc_item_named:(NSString*)filename highlighted:(NSString*)filename_highlighted target:(id)target action:(SEL)action;

+ (void)perform_after:(NSTimeInterval)delay block:(void(^)(void))block;
+ (void)debug_dump_font;

+ (NSDate*)gregorian_date:(NSString*)str;
+ (NSString*)gregorian_string:(NSDate*)date;
+ (void)debug_dump_font;

#ifdef LY_ENABLE_MUSICKIT
+ (NSInteger)media_count_artist:(NSString*)artist album:(NSString*)album title:(NSString*)title;
+ (NSObject*)alloc_media_item_artist:(NSString*)artist album:(NSString*)album title:(NSString*)title;
#endif

#ifdef LY_ENABLE_MAPKIT
+ (CLLocationCoordinate2D)location_of_city:(NSString*)city;
#endif

+ (NSDictionary*)dict_itunes_country_music;
+ (NSDictionary*)dict_itunes_country;
+ (NSDictionary*)dict_itunes_genre;
+ (NSDictionary*)dict_itunes_limit;
+ (NSDictionary*)dict_country_code2;
+ (NSArray*)array_location_city;

+ (uint64_t)benchmark_empty;
+ (uint64_t)benchmark_int;
+ (uint64_t)benchmark_float;
+ (uint64_t)benchmark_memory;
+ (uint64_t)benchmark_disk_write;
+ (uint64_t)benchmark_disk_read;
+ (uint64_t)benchmark_colibrate:(uint64_t)u64;

+ (BOOL)no_backup:(NSString*)url;

@end

/*
	[OALSimpleAudio sharedInstance];
	[[ly.data v:@"oal-audio"] preloadEffect:@"ly-flip-clock1.caf"];
	[[ly.data v:@"oal-audio"] playEffect:[NSString stringWithFormat:@"ly-flip-clock%@.caf", s]];
*/
