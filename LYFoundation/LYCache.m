#import "LYCache.h"

static LYCache *ly_cache_manager = nil;

@implementation LYCache

@synthesize data;
@synthesize delegate;
@synthesize view_loading;

#pragma mark shorten warp

+ (void)set:(id)an_object key:(NSString*)key
{
	[self set_object:an_object for_key:key];
}

+ (id)get_key:(NSString*)key
{
	return [self get_object_for_key:key];
}

+ (id)get_url:(NSString*)url
{
	return [self get_object_for_url:url];
}

#pragma mark cache functions

+ (UIImage*)image_for_url:(NSString*)url
{
	//	TODO: add cache support - XXX: use UIAsyncImageView instead
	return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
}

+ (void)alloc_dictionary_for_key:(NSString*)key
{
	[self alloc_object_for_key:key class:[NSMutableDictionary class]];
}

+ (void)alloc_array_for_key:(NSString*)key
{
	[self alloc_object_for_key:key class:[NSMutableArray class]];
}

+ (void)alloc_object_for_key:(NSString*)key class:(Class)class
{
	[self set_object:[[class alloc] init] for_key:key];
}

+ (BOOL)alloc_object_from_file:(NSString*)filename class:(Class)class
{
	id		item;
	BOOL	ret;

	if ([filename file_exists])
	{
		ret = YES;
		item = [[class alloc] initWithContentsOfFile:[filename filename_document]];
	}
	else
	{
		ret = NO;
		item = [[class alloc] init];
	}

	[self set_object:item for_key:filename];
	return ret;
}

+ (BOOL)alloc_array_from_file:(NSString*)filename
{
	return [self alloc_object_from_file:filename class:[NSMutableArray class]];
}

+ (BOOL)alloc_dictionary_from_file:(NSString*)filename
{
	return [self alloc_object_from_file:filename class:[NSMutableDictionary class]];
}

+ (void)save_file:(NSString*)filename
{
	NSLog(@"writting %@ - %@", filename, [self get_key:filename]);
	[[self get_object_for_key:filename] writeToFile:[filename filename_document] atomically:YES];
}

+ (void)set_object:(id)an_object for_key:(NSString*)key
{
	[[self data] setValue:an_object forKey:key];
	//	NSLog(@"cache: %@\nset: %@", [self data], key);
}

+ (id)get_object_for_key:(NSString*)key
{
	//	NSLog(@"cache: %@\ngetting: %@", [self data], key);
	return [[self data] objectForKey:key];
}

+ (id)download_object_for_url:(NSString*)url
{
	id	ret;

	[LYLoading show];
	//	[NSThread detachNewThreadSelector:@selector(start_loading_animation) toTarget:self withObject:nil];
	//	@synchronized (self)
	//	LYXMLParser* xml = [[LYXMLParser alloc] initWithURLString:url];
	LYXMLParser* xml = [[LYXMLParser alloc] initWithURLString:url mode:@"simple"];
	[self set_object:xml.data for_key:url];
	[xml release];
	//	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//	[[self view_loading] removeFromSuperview];
	ret = [self get_object_for_key:url];
	[ret retain];
	[LYLoading hide];

	return ret;
}

+ (NSString*)string_for_url:(NSString*)url
{
	NSString*	ret = [self get_object_for_key:url];
	if (ret != nil)
		if ([ret length] != 0)
			return ret;

	//	NSLog(@"downloading %@", url);
	ret = [self download_string_for_url:url];

	return ret;
}

+ (NSString*)download_string_for_url:(NSString*)url
{
	NSString*	ret;

	[LYLoading show];
	//[NSThread detachNewThreadSelector:@selector(start_loading_animation) toTarget:self withObject:nil];
	ret = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
	[self set_object:ret for_key:url];
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//[[self view_loading] removeFromSuperview];
	ret = [self get_object_for_key:url];
	[ret retain];
	[LYLoading hide];

	return ret;
}

#ifdef LY_ENABLE_SDK_ASIHTTP
+ (NSString*)async_download_string:(NSString*)url block:(void (^)(BOOL success))a_block
{
	return [LYCache async_download_string:url block:a_block progress:nil];
}

+ (NSString*)async_download_string:(NSString*)string_url block:(void (^)(BOOL success))a_block progress:(UIProgressView*)progress
{
	NSString*	ret = [self get_object_for_key:string_url];
	if (ret != nil)
	{
		if (([ret is:@""]) || ([ret is:@"null"]))
			a_block(NO);
		else
			a_block(YES);
		return ret;
	}

	NSURL *url = [NSURL URLWithString:string_url];
	__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
		request.timeOutSeconds = 60;
	//	[request setNumberOfTimesToRetryOnTimeout:2];
	//	[request setPersistentConnectionTimeoutSeconds:30];
	//	[request setShouldAttemptPersistentConnection:NO];
	if (progress != nil)
		[request setDownloadProgressDelegate:progress];
	[request setCompletionBlock:^
	{
		//	NSString *responseString = [request responseString];
		if (([request.responseString is:@""]) ||
			([request.responseString is:@"null"]))
		{
			//	nothing new
			a_block(NO);
		}
		else
		{
			[LYCache set:request.responseString key:string_url];
			a_block(YES);
		}
	}];
	[request setFailedBlock:^
	{
		//	NSError *error = [request error];
		//	[LYCache nil:nil key:string_url];
		NSLog(@"CACHE async error: %@", request.error);
		a_block(NO);
	}];
	[request startAsynchronous];

	return nil;
}
#endif

+ (id)get_object_for_url:(NSString*)url
{
	id	ret = [self get_object_for_key:url];
	if (ret != nil)
		if ([ret count] != 0)
			return ret;

	//	NSLog(@"downloading %@", url);
	ret = [self download_object_for_url:url];

	return ret;
}

+ (void)remove_key:(NSString*)key
{
	[[self data] removeObjectForKey:key];
}

+ (void)start_loading_animation
{
	@synchronized (self)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

		//	UIView* view = ly_alloc_view_loading();
		//	[self set_view_loading:view];
#if 0
		CGRect rect = UIScreen.mainScreen.bounds;
		[self set_view_loading:[[UIView alloc] initWithFrame:rect]];
		[[self view_loading] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];

		UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		indicator.frame = CGRectMake(rect.size.width / 2 - 10, rect.size.height / 2 - 10, 20, 20);
		[indicator startAnimating];

		[[self view_loading] addSubview:indicator];
#endif
		[[[self delegate] window] addSubview:[self view_loading]];
		//	[[self view_loading] release];
		[pool release];
	}
}

#ifdef LY_ENABLE_SDK_TOUCHJSON
+ (NSDictionary*)dictionary_json_for_url:(NSString*)url
{
	NSString*	s;
	s = [LYCache string_for_url:url];
	if (s == nil)
		return nil;
	return [s dictionary_json];
}
#endif

+ (void)set_object:(id)an_object for_url:(NSString*)url
{
}

+ (void)save_all
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[self data]];
	[dict removeObjectForKey:@"current_location"];
	[dict writeToFile:[k_ly_cache_filename filename_private] atomically:YES];
	[ly no_backup:[k_ly_cache_filename filename_private]];
	//	NSLog(@"CACHE saved: %@\n%@", dict, [k_ly_cache_filename filename_private]);
}

+ (void)load_all
{
	NSMutableDictionary* dict;
	if ([k_ly_cache_filename file_exists])
	{
		dict = [[NSMutableDictionary alloc] initWithContentsOfFile:[k_ly_cache_filename filename_private]];
		//	NSLog(@"load: %@", dict);
		[[self manager] realloc_data:dict];
	}
}

+ (void)clear_all
{
	NSMutableDictionary* dict;
	dict = [[NSMutableDictionary alloc] init];
	[[self manager] realloc_data:dict];
	[self save_all];
}

+ (id)data
{
	return [[self manager] data];
}

+ (id)delegate
{
	return [[self manager] delegate];
}

+ (id)view_loading
{
	return [[self manager] view_loading];
}

+ (void)set_delegate:(id)an_object
{
	[[self manager] setDelegate:an_object];
}

+ (void)set_view_loading:(UIView*)view
{
	[[self manager] setView_loading:view];
}

#pragma mark singleton

+ (LYCache*)manager
{
	@synchronized (self)
	{
		if (ly_cache_manager == nil)
			[[self alloc] init];
	}
	return ly_cache_manager;
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized (self)
	{
		if (ly_cache_manager == nil)
		{
			ly_cache_manager = [super allocWithZone:zone];
			return ly_cache_manager;
		}
	}
	return nil;
}
- (id)init
{
	if (self = [super init])
	{
		srandomdev();
		data = [[NSMutableDictionary alloc] init];
		[LYCache set_view_loading:[LYLoading view]];
	}
	return self;
}
- (void)realloc_data:(NSMutableDictionary*)dict
{
	[data release];
	data = dict;
}

@end
