#import "LYUIKit.h"
#import "LYFoundation.h"
#import "LYCategory.h"

#ifdef LY_ENABLE_SDK_TOUCHJSON
#import "CJSONDeserializer.h"
#endif

#define k_ly_cache_filename	@"ly_cache_data.xml"

@interface LYCache: LYSingletonClass
{
	NSMutableDictionary*			data;
	id								delegate;
	UIView*							view_loading;
}
@property (nonatomic, retain) NSMutableDictionary*		data;
@property (nonatomic, retain) id						delegate;
@property (nonatomic, retain) UIView*					view_loading;

- (void)realloc_data:(NSMutableDictionary*)dict;

+ (LYCache*)manager;
+ (id)data;
+ (id)delegate;
+ (id)view_loading;
+ (void)set_delegate:(id)an_object;
+ (void)set_view_loading:(UIView*)view;
+ (void)start_loading_animation;

#pragma mark manipulate objects

+ (void)set:(id)an_object key:(NSString*)key;
+ (void)remove_key:(NSString*)key;
+ (id)get_key:(NSString*)key;
+ (id)get_url:(NSString*)url;		//	XML

+ (UIImage*)image_for_url:(NSString*)url;
+ (void)set_object:(id)an_object for_key:(NSString*)key;
+ (id)get_object_for_key:(NSString*)key;
//+ (void)set_object:(id)an_object for_url:(NSString*)url;
//	always download
+ (id)download_object_for_url:(NSString*)url;
+ (NSString*)string_for_url:(NSString*)url;
+ (NSString*)download_string_for_url:(NSString*)url;
#ifdef LY_ENABLE_SDK_ASIHTTP
+ (void)async_download_file:(NSString*)string_url to:(NSString*)dir;
+ (void)async_download_files:(NSArray*)urls to:(NSString*)dir;
+ (NSString*)async_download_string:(NSString*)url block:(void (^)(BOOL success))a_block;
+ (NSString*)async_download_string:(NSString*)url block:(void (^)(BOOL success))a_block progress:(UIProgressView*)progress;
#endif
//	get from cache if not nil
+ (id)get_object_for_url:(NSString*)url;

#ifdef LY_ENABLE_SDK_TOUCHJSON
+ (NSDictionary*)dictionary_json_for_url:(NSString*)url;
#endif

#pragma mark allocate new objects

+ (void)alloc_object_for_key:(NSString*)key class:(Class)class;
+ (void)alloc_dictionary_for_key:(NSString*)key;
+ (void)alloc_array_for_key:(NSString*)key;

+ (BOOL)alloc_object_from_file:(NSString*)filename class:(Class)class;
+ (BOOL)alloc_array_from_file:(NSString*)filename;
+ (BOOL)alloc_dictionary_from_file:(NSString*)filename;

+ (void)save_file:(NSString*)filename;
+ (void)save_all;
+ (void)load_all;
+ (void)clear_all;

@end

