#import "LYPublic.h"
#import "LYCategory.h"
#import "ASIHTTPRequest.h"
#import "CJSONSerializer.h"
#import "LYServiceUI.h"

#ifdef LY_ENABLE_SDK_AWS
#import <AWSiOSSDK/AmazonLogger.h>
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>
#endif

@class LYTextAlertView;


@interface LYServiceAWSSimpleDB: NSObject <AmazonServiceRequestDelegate>
{
	NSMutableDictionary*			data;
	AmazonSimpleDBClient*			sdb;
	SimpleDBPutAttributesRequest*	request_put;
}
@property (nonatomic, retain) NSMutableDictionary*	data;

- (void)put:(NSString*)domain;
- (void)key:(NSString*)key unique:(NSString*)value;
- (void)key:(NSString*)key value:(NSString*)value;
- (void)put_block:(LYBlockVoidArrayError)callback;

- (void)select:(NSString*)query block:(LYBlockVoidArrayError)callback;

//- (void)insert_user:(NSDictionary*)dict block:(LYBlockVoidArrayError)callback;
- (void)test;

@end


@interface LYDatabase: NSObject
{
	NSMutableDictionary*	data;
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
