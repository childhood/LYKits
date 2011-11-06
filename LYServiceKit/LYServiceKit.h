#import "LYPublic.h"
#import "LYCategory.h"
#import "ASIHTTPRequest.h"
#import "CJSONSerializer.h"
#import "LYServiceUI.h"

#ifdef LY_ENABLE_SDK_AWS
#import <AWSiOSSDK/AmazonLogger.h>
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#endif

@class LYTextAlertView;


#ifdef LY_ENABLE_SDK_AWS
@interface LYServiceAWS: NSObject
{
	NSMutableDictionary*	data;
	AmazonSimpleDBClient*	sdb;
	AmazonS3Client*			s3;
}
@property (nonatomic, retain) NSMutableDictionary*	data;
@end


@interface LYServiceAWSSimpleDB: LYServiceAWS <AmazonServiceRequestDelegate>
{
	SimpleDBPutAttributesRequest*	request_put;

	LYBlockVoidIntError		callback_int_error;
	LYBlockVoidObjError		callback_obj_error;
}

- (void)put:(NSString*)domain;
- (void)put:(NSString*)domain name:(NSString*)name;
- (void)key:(NSString*)key unique:(NSString*)value;
- (void)key:(NSString*)key value:(NSString*)value;
- (void)put_block:(LYBlockVoidObjError)callback;

- (void)select:(NSString*)query block:(LYBlockVoidObjError)callback;
- (void)count:(NSString*)query block:(LYBlockVoidIntError)callback;

- (NSException*)put_sync;
- (NSArray*)select_sync:(NSString*)query;
- (int)count_sync:(NSString*)query;
- (NSMutableArray*)array_from_select:(SimpleDBSelectResponse*)response;

//- (void)insert_user:(NSDictionary*)dict block:(LYBlockVoidArrayError)callback;
- (void)test;

@end


@interface LYServiceAWSS3: LYServiceAWS
{
	LYBlockVoidError		callback_error;
}

- (NSString*)put_file_sync:(NSString*)filename;
- (NSString*)put_data_sync:(NSData*)data;
- (NSData*)get_data_sync:(NSString*)key;

@end
#endif	//	AWS


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
