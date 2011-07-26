#import "LYServiceKit.h"

@implementation LYDatabase

@synthesize data;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		data = [[NSMutableDictionary alloc] init];
		[data key:@"host"		v:@"http://super-db.appspot.com/rest"];
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
	//url = [NSString stringWithFormat:@"%@/%@", [data v:@"host"], name];
	url = [NSString stringWithFormat:@"%@/%@?username=%@&password=%@",
							 [data v:@"host"], name,
							 [data v:@"username"],
							 [data v:@"password"]];
	__block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
	//NSLog(@"url: %@", url);
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	//[request setPostValue:@"application/json" forKey:@"Content-Type"];
	//[request setPostValue:[data v:@"username"] forKey:@"username"];
	//[request setPostValue:[data v:@"password"] forKey:@"password"];
	[request appendPostData:[[CJSONDataSerializer serializer] serializeDictionary:dict]];
	[request setRequestMethod:@"POST"];
#if 0
	NSLog(@"request: %@", request);
	NSLog(@"request: %@", request.requestMethod);
	NSLog(@"request: %@", request.postBody);
	NSString* tmp;
	tmp = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
	NSLog(@"json %@", tmp);
#endif
	//[request appendPostData:[@"This is my data" dataUsingEncoding:NSUTF8StringEncoding]];
	[request setCompletionBlock:^{
		//	NSLog(@"headers: %@", request.responseHeaders);
		//	NSLog(@"response: %@", request.responseString);
		NSArray* contents = [request.responseString componentsSeparatedByString:@","];
		NSLog(@"contents: %@", contents);
		//	callback(contents, nil);
	}];
	[request setFailedBlock:^{
		NSLog(@"error: %@", request.error);
		//	callback(nil, request.error);
	}];
	[request startAsynchronous];
}

- (void)test
{
#if 0
	LYDatabase* db = [[LYDatabase alloc] init];
	[db test];
#endif

#if 0
	//	select
	[db name:@"database_model" select:@"" block:^(NSArray* array, NSError* error)
	{
		NSLog(@"result: %@ - %@", error, array);
	}];
	//	insert
	[db name:@"database_model" insert:[NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:@"id-005", @"id", @"desc-004", @"desc", @"data-004", @"data", nil],
		nil] block:nil];
	//	set scheme - should be hard coded in application abstract layer, dbxxx does not care about all these
	[[db.data v:@"scheme"] key:@"user" v:[NSArray arrayWithObjects:
		@"email",
		@"name",
		@"friends",
		nil]];
	//	insert into dbxxx (with scheme already given)
	[db db30:@"user" insert:[NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"no@name.com",
			@"email",
			@"Leo",
			@"name",
			[NSMutableArray array],
			@"friends",
			nil],
		nil] block:nil];
	[db db30:@"user" select:@"" block:nil];
#endif
}

@end
