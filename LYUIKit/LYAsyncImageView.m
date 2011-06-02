#import "LYAsyncImageView.h"

@implementation LYAsyncImageView

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		filename = nil;
		is_downloading = NO;
	}

	return [super init];
}

- (void)load_url:(NSString*)s
{
	NSURLRequest*	request;
	if (is_downloading == YES)
		return;

	filename = [[NSString alloc] initWithFormat:@"%ix%i-%@",
			 (int)self.frame.size.width, (int)self.frame.size.height, [s url_to_filename]];
	NSLog(@"xx %@", filename);
	//	[self.image release], self.image = nil;

	if ([filename file_exists] == YES)
	{
		//	NSLog(@"loading from cache: %@", [filename filename_document]);
		self.image = [UIImage imageWithContentsOfFile:[filename filename_document]];
		[filename release];
	}
	else
	{
		if (self.frame.size.width < 128)
			self.image = [UIImage imageNamed:@"ly-placeholder-2.png"];
		else if (self.frame.size.width < 256)
			self.image = [UIImage imageNamed:@"ly-placeholder-4.png"];
		else
			self.image = [UIImage imageNamed:@"ly-placeholder-8.png"];

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
		[UIView begin_animations:0.3];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
		[data writeToFile:[filename filename_document] atomically:YES];
		self.image = the_image;
		[UIView commitAnimations];
	}
	[filename release], filename = nil;
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
		if (self.frame.size.width < 128)
			[self setImage:[UIImage imageNamed:@"ly-placeholder-2.png"] forState:UIControlStateNormal];
		else if (self.frame.size.width < 256)
			[self setImage:[UIImage imageNamed:@"ly-placeholder-4.png"] forState:UIControlStateNormal];
		else
			[self setImage:[UIImage imageNamed:@"ly-placeholder-8.png"] forState:UIControlStateNormal];

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
		[UIView begin_animations:0.3];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
		[data writeToFile:[filename filename_document] atomically:YES];
		[self setImage:the_image forState:UIControlStateNormal];
		[UIView commitAnimations];
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
