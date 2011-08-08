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
		[data key:@"scheme"		v:[NSMutableDictionary dictionary]];
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
	//[request setRequestMethod:@"GET"];
	[request setCompletionBlock:^{
		NSArray* contents = [[[request.responseString dictionary_json] v:@"list"] v:name];
		//	NSLog(@"response: %@", request.responseString);
		//	NSLog(@"contents: %@", contents);
		callback(contents, nil);
	}];
	[request setFailedBlock:^{
		//	NSLog(@"error: %@", request.error);
		callback(nil, request.error);
	}];
	[request startAsynchronous];
}

- (void)name:(NSString*)name key:(NSString*)query block:(void (^)(NSArray* array, NSError* error))callback
{
	NSString* url;
	url = [NSString stringWithFormat:@"%@/%@/%@?username=%@&password=%@",
							 [data v:@"host"], name, query,
							 [data v:@"username"],
							 [data v:@"password"]];
	//	NSLog(@"url: %@", url);
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	[request addRequestHeader:@"Accept" value:@"application/json"];
	//[request setRequestMethod:@"GET"];
	[request setCompletionBlock:^{
		NSArray* contents = [[request.responseString dictionary_json] v:name];
		//	NSLog(@"response: %@", request.responseString);
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
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	//[request setPostValue:@"application/json" forKey:@"Content-Type"];
	//[request setPostValue:[data v:@"username"] forKey:@"username"];
	//[request setPostValue:[data v:@"password"] forKey:@"password"];
	[request appendPostData:[[CJSONSerializer serializer] serializeDictionary:dict error:nil]];
	[request setRequestMethod:@"POST"];
#if 0
	NSLog(@"url: %@", url);
	NSLog(@"request: %@", request);
	NSLog(@"request: %@", request.requestMethod);
	NSLog(@"request: %@", request.postBody);
	NSString* tmp;
	tmp = [[NSString alloc] initWithData:request.postBody encoding:NSUTF8StringEncoding];
	NSLog(@"json %@", tmp);
#endif
	//[request appendPostData:[@"This is my data" dataUsingEncoding:NSUTF8StringEncoding]];
	[request setCompletionBlock:^{
			NSLog(@"headers: %@", request.responseHeaders);
		//	NSLog(@"response: %@", request.responseString);
		NSArray* contents = [request.responseString componentsSeparatedByString:@","];
		//	NSLog(@"contents: %@", contents);
		callback(contents, nil);
	}];
	[request setFailedBlock:^{
		//	NSLog(@"error: %@", request.error);
		callback(nil, request.error);
	}];
	[request startAsynchronous];
}

- (void)set_scheme_user
{
	[[data v:@"scheme"] key:@"user" v:[NSDictionary dictionaryWithObjectsAndKeys:
		@"db30_model",
		@"database",
		[NSArray arrayWithObjects:
			@"email",
			@"name",
			nil],
		@"s",
		[NSArray arrayWithObjects:
			@"friends",
			nil],
		@"t",
		nil]];
}

- (void)sdb:(NSString*)dbname insert:(NSArray*)source block:(void (^)(NSArray* keys, NSError* error))callback
{
	NSDictionary* dict			= [[data v:@"scheme"] v:dbname];
	NSMutableDictionary* dest	= [NSMutableDictionary dictionary];
	int index;
	NSString* type;

	[dest key:@"name" v:dbname];
	[dest key:@"username" v:[data v:@"username"]];
	[dest key:@"password" v:[data v:@"password"]];
#if 0
	int i, count;
	if ([[dict v:@"database"] is:@"db30_model"])
		count = 30;
	for (i = 0; i < count; i++)
	{
		[dest key:[NSString stringWithFormat:@"s%i", i] v:@""];
		[dest key:[NSString stringWithFormat:@"t%i", i] v:@""];
	}
#endif
	NSLog(@"scheme: %@", dict);
	for (NSDictionary* dict_item in source)
	{
		for (NSString* key in dict_item)
		{
			id obj = [dict_item v:key];
			if ([obj isKindOfClass:[NSString class]])
				type = @"s";
			else if ([obj isKindOfClass:[NSArray class]])
			{
				obj = [NSString stringWithUTF8String:[[[CJSONSerializer serializer] serializeArray:obj error:nil] bytes]];
				type = @"t";
			}
			index = [[dict v:type] indexOfObject:key];
			NSLog(@"%i: %@", index, key);
			[dest key:[NSString stringWithFormat:@"%@%i", type, index] v:obj];
		}
	}
	NSLog(@"dest: %@", dest);
#if 1
	[self name:[dict v:@"database"] insert:[NSArray arrayWithObjects:dest,
		//[NSDictionary dictionaryWithObjectsAndKeys:@"id-006", @"id", @"desc-006", @"desc", @"data-006", @"data", nil],
		nil] block:^(NSArray* array, NSError* error)
	{
		NSLog(@"add user result: %@ - %@", error, array);
	}];
#endif
}

- (void)test
{
	LYDatabase* db = [[LYDatabase alloc] init];
#if 0
	//	select
	//[db name:@"database_model" select:@"" block:^(NSArray* array, NSError* error)
	//[db name:@"database_model" select:@"feq_desc=desc-002&" block:^(NSArray* array, NSError* error)
	[db name:@"database_model" key:@"agpzfnN1cGVyLWRichULEg5kYXRhYmFzZV9tb2RlbBjrBww" block:^(NSArray* array, NSError* error)
	{
		NSLog(@"result: %@ - %@", error, array);
	}];
#endif
#if 0
	//	insert
	[db name:@"database_model" insert:[NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:@"id-006", @"id", @"desc-006", @"desc", @"data-006", @"data", nil],
		nil] block:^(NSArray* array, NSError* error)
	{
		NSLog(@"result: %@ - %@", error, array);
	}];
#endif
#if 1
	//	insert into dbxxx (with scheme already given)
	[db set_scheme_user];
	[db sdb:@"user" insert:[NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"no@name.com",
			@"email",
			@"Leo.002",
			@"name",
			[NSMutableArray arrayWithObjects:
				@"noa@name.com",
				@"nob@name.com",
				nil],
			@"friends",
			nil],
		nil] block:nil];
#endif
#if 0
	[db db30_model:@"user" select:@"" block:nil];
#endif
	[db release];
}

@end
