#import "LYPublic.h"
#import "LYCategory.h"
#import "ASIHTTPRequest.h"
#import "CJSONSerializer.h"
#import "LYServiceUI.h"

@class LYTextAlertView;

@interface LYDatabase: NSObject
{
	NSMutableDictionary* data;
}
@property (nonatomic, retain) NSMutableDictionary*	data;

- (id)init;
- (void)name:(NSString*)name select:(NSString*)query block:(LYBlockVoidArrayError)callback;
- (void)name:(NSString*)name key:(NSString*)query block:(LYBlockVoidArrayError)callback;
- (void)name:(NSString*)name insert:(NSArray*)array block:(LYBlockVoidArrayError)callback;

- (void)sdb:(NSString*)dbname insert:(NSArray*)source block:(LYBlockVoidArrayError)callback;
- (void)sdb:(NSString*)dbname select:(NSDictionary*)dict block:(LYBlockVoidArrayError)callback;
- (void)sdb:(NSString*)dbname verify:(NSDictionary*)dict block:(LYBlockVoidDictError)callback;
- (void)sdb:(NSString*)dbname key:(NSString*)s block:(LYBlockVoidDictError)callback;
- (void)sdb:(NSString*)dbname insert_unique:(NSDictionary*)dict block:(LYBlockVoidStringError)callback;

- (void)insert_user:(NSDictionary*)dict block:(LYBlockVoidArrayError)callback;
- (NSString*)blob_upload:(NSData*)data type:(NSString*)type;
- (NSString*)blob_upload_jpeg:(UIImage*)image;
- (NSString*)url_blob:(NSString*)function;
- (NSString*)url_blob_serve:(NSString*)key;

- (void)test;
- (void)set_scheme_user;
- (void)set_scheme_post;

@end


@interface LYServiceAWS: NSObject
{
	NSMutableDictionary* data;
}
@property (nonatomic, retain) NSMutableDictionary*	data;

- (void)insert_user:(NSDictionary*)dict block:(LYBlockVoidArrayError)callback;

@end


@interface LYServiceFaceDotCom: NSObject
{
	NSMutableDictionary* data;
}
@property (nonatomic, retain) NSMutableDictionary*	data;

- (void)limits:(LYBlockVoidDictError)callback;
- (void)detect:(NSString*)filename block:(LYBlockVoidArrayError)callback;

@end


@interface LYServiceLyricWiki: NSObject
{
	NSMutableDictionary* data;
}
@property (nonatomic, retain) NSMutableDictionary*	data;

- (void)lyric_by_artist:(NSString*)artist song:(NSString*)song block:(LYBlockVoidStringError)callback;

@end
