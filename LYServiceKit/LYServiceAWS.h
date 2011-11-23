#import "LYServiceKit.h"

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
