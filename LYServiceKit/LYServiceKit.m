#import "LYServiceKit.h"

@implementation LYDatabase

@synthesize data;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		data = [[NSMutableDictionary alloc] init];
		[data key:@"host"		v:@"https://super-db.appspot.com/rest"];
		[data key:@"username"	v:@"test"];
		[data key:@"password"	v:@"passwordtest"];
	}
	return self;
}

- (void)dealloc
{
	[data release];
	[super dealloc];
}

- (void)name:(NSString*)name select:(NSString*)query block:(void (^)(NSArray* array, NSError* error))callback
{
	NSString* url;
	url = [NSString stringWithFormat:@"%@/%@?%@username=%@&password=%@",
							 [data v:@"host"], name, query,
							 [data v:@"username"],
							 [data v:@"password"]];
	//	NSLog(@"url: %@", url);
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	[request addRequestHeader:@"Accept" value:@"application/json"];
	[request setCompletionBlock:^{
		NSArray* contents = [[[request.responseString dictionary_json] v:@"list"] v:name];
		//	NSLog(@"contents: %@", contents);
		callback(contents, nil);
	}];
	[request setFailedBlock:^{
		//	NSLog(@"error: %@", request.error);
		callback(nil, request.error);
	}];
	[request startAsynchronous];
}

- (void)name:(NSString*)name insert:(NSArray*)array block:(void (^)(NSArray* keys, NSError* error))callback
{
	NSString*		url;
	NSDictionary*	dict;
	dict = [NSDictionary dictionaryWithObjectsAndKeys:
	   [NSDictionary dictionaryWithObjectsAndKeys:
		   array, name, nil],
	   @"list", nil];
	url = [NSString stringWithFormat:@"%@/%@", [data v:@"host"], name];
	NSLog(@"url: %@", url);
	__block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
	[request setPostValue:[data v:@"username"] forKey:@"username"];
	[request setPostValue:[data v:@"password"] forKey:@"password"];
	[request appendPostData:[[CJSONDataSerializer serializer] serializeDictionary:dict]];
	//[request appendPostData:[@"This is my data" dataUsingEncoding:NSUTF8StringEncoding]];
	[request setCompletionBlock:^{
		NSLog(@"response: %@", request.responseString);
		NSArray* contents = [request.responseString componentsSeparatedByString:@","];
		NSLog(@"contents: %@", contents);
		callback(contents, nil);
	}];
	[request setFailedBlock:^{
		NSLog(@"error: %@", request.error);
		callback(nil, request.error);
	}];
	[request startAsynchronous];
}

#if 0	//	test code
LYDatabase* db = [[LYDatabase alloc] init];
[db name:@"database_model" insert:[NSArray arrayWithObjects:
					[NSDictionary dictionaryWithObjectsAndKeys:@"id-002", @"id", @"desc-002", @"desc", @"data-002", @"data", nil],
													nil] block:nil];
#endif

@end
