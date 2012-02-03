#import "LYServiceAWS.h"


#ifdef LY_ENABLE_SDK_AWS
@implementation LYServiceAWS
@synthesize data;
- (id)init
{
	self = [super init];
	if (self != nil)
	{
		data = [[NSMutableDictionary alloc] init];
#if 1
		[data key:@"aws-key" v:@"AKIAIG737NOEC2VVPXQQ"];
		[data key:@"aws-secret" v:@"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"];
		[data key:@"aws-key" v:[[data v:@"aws-key"] _ly_k1]];
		[data key:@"aws-secret" v:[[data v:@"aws-secret"] _ly_k1]];
		//NSLog(@"key %@", [data v:@"aws-key"]);
		//NSLog(@"sec %@", [data v:@"aws-secret"]);
#else
		[data key:@"aws-key" v:@"AKIAIG737NOEC2VVPXQQ"];
		[data key:@"aws-secret" v:@"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"];
		NSLog(@"key %@", [[data v:@"aws-key"] _ly_k1]);
		NSLog(@"sec %@", [[data v:@"aws-secret"] _ly_k1]);
#endif
		sdb	= [[AmazonSimpleDBClient alloc] initWithAccessKey:[data v:@"aws-key"] withSecretKey:[data v:@"aws-secret"]];
		s3	= [[AmazonS3Client alloc] initWithAccessKey:[data v:@"aws-key"] withSecretKey:[data v:@"aws-secret"]];
	}
	return self;
}
- (void)dealloc
{
	[sdb release];
	[data release];
	[super dealloc];
}
@end


@implementation LYServiceAWSSimpleDB

/*
 * 
	LYServiceAWSSimpleDB* sdb = [[LYServiceAWSSimpleDB alloc] init];
	//	[sdb test];
#if 0	
	[sdb select:@"select * from `user` where `name` = 'Leo'" block:^(id obj, NSError* error)
	{
		NSArray* array = (NSArray*)obj;
		NSLog(@"select result: %@", error);
		NSLog(@"select data: %@", array);
	}];
#endif
#if 1
	[sdb put:@"users" name:@"leo@superarts.org"];
	[sdb key:@"name" unique:@"Leo3"];
	[sdb key:@"friends" value:@"tom"];
	[sdb key:@"friends" value:@"jerry"];
	[sdb key:@"friends" value:@"kenny"];
	[sdb key:@"gender" value:@"male"];
	[sdb put_block:^(id obj, NSError* error)
	{
		NSLog(@"put result: %@", error);
	}];
#endif
 *
 */
#if 0
- (id)init
{
	self = [super init];
	if (self != nil)
	{
#if 0
		data = [[NSMutableDictionary alloc] init];
		[data key:@"aws-key" v:@"AKIAIG737NOEC2VVPXQQ"];
		[data key:@"aws-secret" v:@"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"];
#endif
	}
	return self;
}

- (void)dealloc
{
	//[sdb release];
	//[data release];
	[super dealloc];
}
#endif

#pragma mark put

- (void)put:(NSString*)domain
{
	[self put:domain name:[LYRandom unique_string]];
}

- (void)put:(NSString*)domain name:(NSString*)name
{
	request_put = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:domain
															   andItemName:name
															 andAttributes:nil];
														//	 andAttributes:[NSMutableArray array]];
}

- (void)key:(NSString*)key unique:(NSString*)value
{
	//SimpleDBAttribute* attr = [[SimpleDBAttribute alloc] initWithName:key andValue:value];
	SimpleDBReplaceableAttribute* attr = [[SimpleDBReplaceableAttribute alloc] initWithName:key andValue:value andReplace:YES];
	[request_put addAttribute:attr];
	[attr release];
}

- (void)key:(NSString*)key value:(NSString*)value
{
	SimpleDBReplaceableAttribute* attr = [[SimpleDBReplaceableAttribute alloc] initWithName:key andValue:value andReplace:NO];
	[request_put addAttribute:attr];
	[attr release];
}

- (void)put_block:(LYBlockVoidObjError)callback
{
	request_put.delegate = self;
	[sdb putAttributes:request_put];
	[request_put release];
	callback_obj_error = [callback copy];
}

- (NSException*)put_sync
{
	[LYLoading show];
	SimpleDBPutAttributesResponse* response = [sdb putAttributes:request_put];
	[request_put release];
	return response.exception;
}

#pragma mark select

- (void)select:(NSString*)query block:(LYBlockVoidObjError)callback
{
	SimpleDBSelectRequest* request_select = [[SimpleDBSelectRequest alloc] initWithSelectExpression:query];
	request_select.delegate = self;
	[sdb select:request_select];
	[request_select release];
	callback_obj_error = [callback copy];
}

- (NSArray*)select_sync:(NSString*)query
{
	[LYLoading show];
	SimpleDBSelectRequest* request_select = [[SimpleDBSelectRequest alloc] initWithSelectExpression:query];
	SimpleDBSelectResponse* response_select = [sdb select:request_select];
	[request_select release];
	[LYLoading hide];
	return [self array_from_select:response_select];
	//return response_select.items;
}

- (void)count:(NSString*)query block:(LYBlockVoidIntError)callback
{
	NSString* s = [NSString stringWithFormat:@"SELECT count(*) FROM %@", query];
	//	NSLog(@"count:\n%@", s);
	SimpleDBSelectRequest  *request_select = [[SimpleDBSelectRequest alloc] initWithSelectExpression:s];
	request_select.delegate = self;
	[sdb select:request_select];
	[request_select release];
	callback_int_error = [callback copy];
}

- (int)count_sync:(NSString*)query
{
	[LYLoading show];
	NSString* s = [NSString stringWithFormat:@"SELECT count(*) FROM %@", query];
	SimpleDBSelectRequest  *request_count = [[SimpleDBSelectRequest alloc] initWithSelectExpression:s];
	SimpleDBSelectResponse* response_count = [sdb select:request_count];
	SimpleDBAttribute* attr = [[[response_count.items i:0] attributes] i:0];
	[request_count release];
	[LYLoading hide];
	return [[attr value] intValue];
}

#pragma mark delete

- (void)delete:(NSString*)domain name:(NSString*)name
{
	SimpleDBDeleteAttributesRequest* request = [[SimpleDBDeleteAttributesRequest alloc] 
		initWithDomainName:domain andItemName:name];
	[sdb deleteAttributes:request];
	//	SimpleDBDeleteAttributesResponse* response = [sdb deleteAttributes:request];
	//	NSLog(@"SDB delete response: %@", response);
	[request release];
}

#pragma mark delegate

- (void)request:(AmazonServiceRequest*)request didCompleteWithResponse:(AmazonServiceResponse*)response
{
	if ([response class] == [SimpleDBPutAttributesResponse class])
	{
		//	NSLog(@"put successfully: %@", response);
		callback_obj_error(nil, nil);
		[callback_obj_error release];
	}
	else if ([response class] == [SimpleDBSelectResponse class])
	{
		SimpleDBAttribute* attr = nil;
		SimpleDBSelectResponse* response_select = (SimpleDBSelectResponse*)response;
		if (response_select.items.count > 0)
			attr = [[[response_select.items i:0] attributes] i:0];
		if ((attr != nil) && [[attr name] is:@"Count"])
		{
			callback_int_error([[attr value] intValue], nil);
			[callback_int_error release];
		}
		else
		{
			NSArray* array = [self array_from_select:response_select];
			//	NSLog(@"xxx %@", callback_obj_error);
			callback_obj_error(array, nil);
			//[callback_obj_error release];
		}
		//	NSLog(@"select: %@", response_select.items);
	}
	else
		NSLog(@"AWS response: %@\nclass: '%@'", response, NSStringFromClass([response class]));
}

- (NSMutableArray*)array_from_select:(SimpleDBSelectResponse*)response
{
	NSMutableArray* array = [NSMutableArray array];
	for (SimpleDBItem* item in response.items)
	{
		NSMutableArray* attributes = [NSMutableArray array];
		NSMutableDictionary* attr_unique = [NSMutableDictionary dictionary];
		for (SimpleDBAttribute* attr in item.attributes)
		{
			[attributes addObject:[NSDictionary dictionaryWithObjectsAndKeys:
				attr.value,
				attr.name,
				nil]];
			[attr_unique key:attr.name v:attr.value];
		}
		[array addObject:[NSDictionary dictionaryWithObjectsAndKeys:
			attributes,
			@"attributes",
			attr_unique,
			@"attr-dict",
			item.name,
			@"name",
			nil]];
	}
	return array;
}

- (void)request:(AmazonServiceRequest*)request didFailWithError:(NSError*)error
{
	callback_obj_error(nil, error);
}

- (void)test
{
	//	[AmazonLogger verboseLogging];
	NSLog(@"AWS testing started...");
	sdb = [[AmazonSimpleDBClient alloc] initWithAccessKey:[data v:@"aws-key"] withSecretKey:[data v:@"aws-secret"]];
#if 1
	SimpleDBSelectRequest  *request_select  = [[[SimpleDBSelectRequest alloc] initWithSelectExpression:@"select * from `user` where `name` = 'Leo1'"] autorelease];
	request_select.delegate = self;
	SimpleDBSelectResponse *response_select = [sdb select:request_select];
	NSLog(@"select: %@", response_select.items);
#endif
#if 0
	SimpleDBPutAttributesRequest* request_put;
	request_put = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:@"user"
															   andItemName:@"item-001"
															 andAttributes:[NSMutableArray arrayWithObjects:
					   [[[SimpleDBReplaceableAttribute alloc] initWithName:@"name" andValue:@"Leo2" andReplace:NO] autorelease], 
					   [[[SimpleDBReplaceableAttribute alloc] initWithName:@"name" andValue:@"Leo3" andReplace:NO] autorelease], 
					   [[[SimpleDBReplaceableAttribute alloc] initWithName:@"name" andValue:@"Leo4" andReplace:NO] autorelease], 
					   [[[SimpleDBReplaceableAttribute alloc] initWithName:@"mail" andValue:@"no2@name.com" andReplace:YES] autorelease], 
					   nil]];
	request_put.delegate = self;
	[sdb putAttributes:request_put];
	[request_put release];
#endif
	[sdb release];
	NSLog(@"AWS testing done");
}

@end


@implementation LYServiceAWSS3

- (id)init
{
	self = [super init];
	if (self)
	{
		[self.data key:@"s3-folder" v:@""];
	}
	return self;
}

- (NSString*)put_file_sync:(NSString*)filename
{
	[LYLoading show];
	NSString* uid = [[self.data v:@"s3-folder"] stringByAppendingString:[LYRandom unique_string]];
	S3PutObjectRequest* request = [[S3PutObjectRequest alloc] initWithKey:uid inBucket:@"us-general"];
	request.cannedACL = [S3CannedACL publicRead];
	request.filename = filename;
	[s3 putObject:request];
	[request release];
	[LYLoading hide];
	return uid;
}

- (NSString*)put_data_sync:(NSData*)a_data
{
	[LYLoading show];
	NSString* uid = [[self.data v:@"s3-folder"] stringByAppendingString:[LYRandom unique_string]];
	S3PutObjectRequest* request = [[S3PutObjectRequest alloc] initWithKey:uid inBucket:@"us-general"];
	request.cannedACL = [S3CannedACL publicRead];
	request.data = a_data;
	[s3 putObject:request];
	[request release];
	[LYLoading hide];
	return uid;
}

- (NSData*)get_data_sync:(NSString*)key
{
	[LYLoading show];
	S3GetObjectRequest* request = [[S3GetObjectRequest alloc] initWithKey:key withBucket:@"us-general"];
	S3GetObjectResponse* response = [s3 getObject:request];
	[request release];
#if 0
	NSLog(@"got: %@", response);
	NSLog(@"body: %@", response.body);
	NSLog(@"length: %i", response.contentLength);
#endif
	[LYLoading hide];
	return response.body;
}

@end
#endif	//	AWS
