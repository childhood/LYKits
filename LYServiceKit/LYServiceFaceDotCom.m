#import "LYServiceFaceDotCom.h"

#ifdef LY_ENABLE_SDK_ASIHTTP
@implementation LYServiceFaceDotCom

@synthesize data;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		data = [[NSMutableDictionary alloc] init];
		[data key:@"host"	v:@"http://api.face.com"];
		[data key:@"key"	v:@"a354202bc6a9000b86f3da747470a64b"];
		[data key:@"secret"	v:@"cf03cb8a4dc6696259ff9664f49e6b4d"];
	}
	return self;
}

- (void)dealloc
{
	[data release];
	[super dealloc];
}

- (void)limits:(LYBlockVoidDictError)callback
{
	NSString* url = [NSString stringWithFormat:@"%@/account/limits?api_key=%@&api_secret=%@",
									   [data v:@"host"],
									   [data v:@"key"],
									   [data v:@"secret"]];
	//	NSLog(@"url: %@", url);
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	[request addRequestHeader:@"Accept" value:@"application/json"];
	[request setCompletionBlock:^{
		NSDictionary* dict = [request.responseString dictionary_json];
		if ([[dict v:@"status"] is:@"success"])
			callback([dict v:@"usage"], nil);
		else
			callback(nil, [NSError errorWithDomain:@"FACE Get Limit Failed" code:1 userInfo:nil]);
	}];
	[request setFailedBlock:^{
		//	NSLog(@"error: %@", request.error);
		callback(nil, request.error);
	}];
	[request startAsynchronous];
}

- (void)detect:(NSString*)filename block:(LYBlockVoidArrayError)callback
{
	NSString* url = [NSString stringWithFormat:@"%@/faces/detect?api_key=%@&api_secret=%@&detector=Aggressive&attributes=all",
									   [data v:@"host"],
									   [data v:@"key"],
									   [data v:@"secret"]];
	__block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
	[request addRequestHeader:@"Accept" value:@"application/json"];
	[request setRequestMethod:@"POST"];
	[request setFile:filename forKey:@"_file"];
	NSLog(@"FACE url: %@", url);
	[request setCompletionBlock:^{
		NSDictionary* dict = [request.responseString dictionary_json];
		NSLog(@"response: %@", dict);
		if ([[dict v:@"status"] is:@"success"])
			callback([dict v:@"photos"], nil);
		else
			callback(nil, [NSError errorWithDomain:@"FACE Get Limit Failed" code:1 userInfo:nil]);
	}];
	[request setFailedBlock:^{
		callback(nil, request.error);
	}];
	[request startAsynchronous];
}

@end
#endif
