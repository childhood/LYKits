#import "LYAsyncImageView.h"

@implementation LYAsyncImageView

- (id)init
{
	filename = @"";
	is_downloading = NO;

	return [super init];
}

- (void)load_url:(NSString*)s
{
	NSURLRequest*	request;

	if (is_downloading == YES)
		return;

	filename = [[s url_to_filename] retain];
	//	[self.image release], self.image = nil;

	if ([filename file_exists] == YES)
	{
		//	NSLog(@"loading from cache: %@", [filename filename_document]);
		self.image = [UIImage imageWithContentsOfFile:[filename filename_document]];
	}
	else
	{
		//	NSLog(@"downloading from: %@", s);
		is_downloading = YES;
		request = [NSURLRequest requestWithURL:[NSURL URLWithString:s] 
								   cachePolicy:NSURLRequestReturnCacheDataElseLoad 
							   timeoutInterval:30.0];
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
	
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
	UIImage*	the_image = [UIImage imageWithData:data];

	is_downloading = NO;
	//	NSLog(@"got image: %@", the_image);
	//	NSLog(@"got data: %@", self);
	if (the_image != nil)
	{
		[data writeToFile:[filename filename_document] atomically:YES];
		self.image = the_image;
	}
    [data release], data = nil;
	[connection release], connection = nil;
}

- (void)dealloc
{
	[data release];
	[connection release];
    [super dealloc];
}

@end

@implementation LYAsyncButton

- (id)init
{
	filename = @"";
	is_downloading = NO;

	return [super init];
}

- (void)load_url:(NSString*)s
{
	NSURLRequest*	request;

	if (is_downloading == YES)
		return;

	filename = [[s url_to_filename] retain];
	//	[self.image release], self.image = nil;

	if ([filename file_exists] == YES)
	{
		//	NSLog(@"loading from cache: %@", [filename filename_document]);
		[self setImage:[UIImage imageWithContentsOfFile:[filename filename_document]] forState:UIControlStateNormal];
	}
	else
	{
		//	NSLog(@"downloading from: %@", s);
		is_downloading = YES;
		request = [NSURLRequest requestWithURL:[NSURL URLWithString:s] 
								   cachePolicy:NSURLRequestReturnCacheDataElseLoad 
							   timeoutInterval:30.0];
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData 
{
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
	
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
	UIImage*	the_image = [UIImage imageWithData:data];

	is_downloading = NO;
	//	NSLog(@"got image: %@", the_image);
	//	NSLog(@"got data: %@", self);
	if (the_image != nil)
	{
		[data writeToFile:[filename filename_document] atomically:YES];
		[self setImage:the_image forState:UIControlStateNormal];
	}
    [data release], data = nil;
	[connection release], connection = nil;
}

- (void)dealloc
{
	[data release];
	[connection release];
    [super dealloc];
}

@end
