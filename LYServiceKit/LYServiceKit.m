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

- (void)name:(NSString*)name select:(NSString*)query block:(LYBlockVoidArrayError)callback
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

- (void)name:(NSString*)name key:(NSString*)query block:(LYBlockVoidArrayError)callback
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

- (void)name:(NSString*)name insert:(NSArray*)array block:(LYBlockVoidArrayError)callback
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
		//	NSLog(@"headers: %@", request.responseHeaders);
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
	if ([[data v:@"scheme"] v:@"user"] == nil)
	{
		[[data v:@"scheme"] key:@"user" v:[NSDictionary dictionaryWithObjectsAndKeys:
			@"db30_model",
			@"database",
			[NSArray arrayWithObjects:
				@"email",
				nil],
			@"unique",
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
}

- (void)sdb:(NSString*)dbname insert:(NSArray*)source block:(LYBlockVoidArrayError)callback
{
	NSDictionary* dict			= [[data v:@"scheme"] v:dbname];
	NSMutableArray* array_dest	= [NSMutableArray array];
	int index;
	NSString* type;

	//	NSLog(@"scheme: %@", dict);
	for (NSDictionary* dict_item in source)
	{
		NSMutableDictionary* dest	= [NSMutableDictionary dictionary];

		[dest key:@"name" v:dbname];
		[dest key:@"username" v:[data v:@"username"]];
		[dest key:@"password" v:@"********"];
#if 0
		int i, count;
		if ([[dict v:@"database"] is:@"db30_model"])
			count = 30;
		for (i = 0; i < count; i++)
		{
			[dest key:[NSString stringWithFormat:@"s%i", i] v:@""];
			[dest key:[NSString stringWithFormat:@"t%i", i] v:@""];
		}

		NSString* query_unique = @"";
		for (NSString* item in [dict v:@"unique"])
			query_unique = [query_unique stringByAppendingFormat:@"feq_%@=%@&", item, [dict_item v:item]];
		NSLog(@"query unique: %@", query_unique);
#endif

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
			//	NSLog(@"%i: %@", index, key);
			[dest key:[NSString stringWithFormat:@"%@%i", type, index] v:obj];
		}
		[array_dest addObject:dest];
	}
	//	NSLog(@"dest: %@", dest);
#if 1
	[self name:[dict v:@"database"] insert:array_dest block:^(NSArray* array, NSError* error)
	{
		callback(array, error);
		//	NSLog(@"add user result: %@ - %@", error, array);
	}];
#endif
}

- (void)insert_user:(NSDictionary*)dict block:(LYBlockVoidArrayError)callback
{
	NSDictionary* source = dict;
	[self set_scheme_user];

	NSString* query_unique = @"";
	for (NSString* item in [[[data v:@"scheme"] v:@"user"] v:@"unique"])
	{
		NSString* s = [NSString stringWithFormat:@"s%i", [[[[data v:@"scheme"] v:@"user"] v:@"s"] indexOfObject:item]];
		query_unique = [query_unique stringByAppendingFormat:@"feq_%@=%@&", s, [dict v:item]];
	}
	//	NSLog(@"query unique: %@", query_unique);

	[self name:[[[data v:@"scheme"] v:@"user"] v:@"database"] select:query_unique block:^(NSArray* array, NSError* error)
	{
		if ([array count] > 0)
		{
			//	NSLog(@"user already exists");
			callback(nil, [NSError errorWithDomain:@"SDB User Already Exists" code:1 userInfo:nil]);
		}
		else
		{
			//	NSLog(@"result: %@ - %@, %i", error, array, array.count);
			[self sdb:@"user" insert:[NSArray arrayWithObjects:source, nil] block:^(NSArray* array, NSError* error)
			{
				callback(array, error);
			}];
		}
	}];
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
#if 0
	//	insert into dbxxx (with scheme already given)
	[db set_scheme_user];
	[db sdb:@"user" insert:[NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"no1@name.com",
			@"email",
			@"Leo.004",
			@"name",
			[NSMutableArray arrayWithObjects:
				@"noa@name.com",
				@"nob@name.com",
				nil],
			@"friends",
			nil],
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"no2@name.com",
			@"email",
			@"Leo.005",
			@"name",
			[NSMutableArray arrayWithObjects:
				@"noa@name.com",
				@"nob@name.com",
				nil],
			@"friends",
			nil],
		nil] block:^(NSArray* array, NSError* error)
	{
		NSLog(@"result sdb insert: %@ - %@", error, array);
	}];
#endif
	[db insert_user:[NSDictionary dictionaryWithObjectsAndKeys:
		@"no5@name.com",
		@"email",
		@"Leo.004",
		@"name",
		[NSMutableArray arrayWithObjects:
			@"noa@name.com",
		@"nob@name.com",
		nil],
		@"friends",
		nil] block:^(NSArray* array, NSError* error)
	{
		NSLog(@"result user insert: %@ - %@", error, array);
	}];

#if 0
	[db db30_model:@"user" select:@"" block:nil];
#endif
	[db release];
}

@end
