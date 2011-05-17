#import <UIKit/UIKit.h>
#import "LYCategory.h"

#ifdef LY_ENABLE_OPENAL
#import "supersound.h"
#endif

#ifdef LY_ENABLE_SDK_ASIHTTP
#import "ASIFormDataRequest.h"
#endif

#ifdef LY_ENABLE_SDK_TOUCHJSON
#import "CJSONDeserializer.h"
#endif

@interface NSString (LYString)
BOOL supersound_inited;

//	ui
- (void)show_alert_title:(NSString*)title message:(NSString*)msg;
- (void)show_alert_message:(NSString*)msg;
- (void)show_alert_title:(NSString*)title;
- (void)show_alert_message:(NSString*)msg delegate:(id)an_obj;
- (void)show_alert_title:(NSString*)title delegate:(id)an_obj;
- (void)show_alert_title:(NSString*)title message:(NSString*)msg delegate:(id)an_obj;

//	application
- (BOOL)go_url;
- (BOOL)can_go_url;
- (BOOL)at_least_version;

//	file
- (NSString*)filename_documents;
- (NSString*)filename_document;
- (NSString*)filename_library;
- (NSString*)filename_bundle;
- (NSString*)filename_private;
- (BOOL)is_directory;
- (BOOL)file_exists;
- (BOOL)file_exists_documents;
- (BOOL)file_exists_bundle;
- (BOOL)create_dir_absolute;
- (BOOL)create_dir;
- (BOOL)file_remove;
- (BOOL)file_backup;
- (BOOL)file_backup_private;
- (BOOL)file_backup_to:(NSString*)dest;
- (NSArray*)list_documents;
- (NSArray*)list_private;
#ifdef LY_ENABLE_APP_ZIP
- (BOOL)unzip_to:(NSString*)dest;
- (NSArray*)zip_content_array;
#endif

//	url
- (NSString*)url_to_filename;
- (NSString*)to_url;
- (BOOL)is_email;
- (BOOL)is_english_name;

//	string
- (BOOL)has_substring:(NSString*)sub;
- (NSString*)string_without_leading_space;
- (NSString*)string_replace:(NSString*)substring with:(NSString*)replacement;
- (NSString*)string_without:(NSString*)head to:(NSString*)tail;
- (NSString*)string_without:(NSString*)head to:(NSString*)tail except:(NSArray*)exceptions;
- (NSString*)string_between:(NSString*)head and:(NSString*)tail;
+ (NSString*)string_from_int:(int)i;
- (NSString*)s_int:(int)i;				//	[@"photo" s_int:3] == @"3 photos"
- (NSString*)s_int_with_no:(int)i;
- (NSString*)s_int_with_No:(int)i;
- (NSString*)append_line:(NSString*)str;
- (NSString*)append_line2:(NSString*)str;
- (NSString*)append_line:(NSString*)str divider:(NSString*)divider;

//	date and time
- (NSString*)convert_date_from:(NSString*)format_old to:(NSString*)format_new;
- (NSString*)format_date:(NSDate*)date;

//	sound - external/supersound needed
- (void)play_caf;

//	setting
- (BOOL)setting_bool;
- (NSInteger)setting_integer;
- (NSString*)setting_string;
- (id)setting_object;
- (void)setting_bool:(BOOL)b;
- (void)setting_integer:(NSInteger)i;
- (void)setting_string:(NSString*)s;
- (void)setting_object:(id)obj;

#ifdef LY_ENABLE_SDK_ASIHTTP
- (NSString*)blob_post_dictionary:(NSDictionary*)dict;
- (NSString*)http_post_dictionary:(NSDictionary*)dict;
#endif

#ifdef LY_ENABLE_SDK_TOUCHJSON
- (NSDictionary*)dictionary_json;
- (NSArray*)array_json;
#endif

@end
