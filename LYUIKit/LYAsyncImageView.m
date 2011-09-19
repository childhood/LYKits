#import "LYAsyncImageView.h"

@implementation LYAsyncImageView

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		self.contentMode = UIViewContentModeScaleAspectFill;
		self.clipsToBounds = YES;
		filename_original = nil;
		filename = nil;
		is_downloading = NO;
		data = nil;
		connection = nil;
	}

	return [super init];
}

- (void)load_url:(NSString*)s
{
	NSURLRequest*	request;
	if (is_downloading == YES)
		return;

#if 1
	filename = [[NSString alloc] initWithFormat:@"%ix%i-%@",
			 (int)self.frame.size.width, (int)self.frame.size.height, [s url_to_filename]];
#else
	filename = [[NSString alloc] initWithString:[s url_to_filename]];
#endif
	//	[self.image release], self.image = nil;

	//	NSLog(@"checking filename: %@", [@"" filename_document]);
	if ([filename file_exists] == YES)
	{
		//	NSLog(@"loading from cache: %@", [filename filename_document]);
		self.image = [UIImage imageWithContentsOfFile:[filename filename_document]];
		[filename release];
	}
	else
	{
		filename_original = [[NSString alloc] initWithString:[s url_to_filename]];
		if ([filename_original file_exists])
		{
			UIImage* the_image = [UIImage imageWithContentsOfFile:[filename_original filename_document]];
			UIImage* resized_image = [the_image image_with_size_aspect_fill:CGSizeMake(self.frame.size.width, self.frame.size.height)];
			[UIView begin_animations:0.3];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
			[UIImagePNGRepresentation(resized_image) writeToFile:[filename filename_document] atomically:YES];
			self.image = resized_image;
			[UIView commitAnimations];
			[filename_original release], filename_original = nil;
			[filename release], filename = nil;
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
		the_image = [the_image image_with_size_aspect_fill:CGSizeMake(self.frame.size.width, self.frame.size.height)];
		[data writeToFile:[filename_original filename_document] atomically:YES];
		[UIImagePNGRepresentation(the_image) writeToFile:[filename filename_document] atomically:YES];
		self.image = the_image;
		[UIView commitAnimations];
	}
	[filename_original release], filename_original = nil;
	[filename release], filename = nil;
    [data release], data = nil;
	[connection release], connection = nil;
}

- (void)dealloc
{
	//[data release];
	//[connection release];
    [super dealloc];
}

@end


@implementation LYAsyncButton

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		self.imageView.contentMode = UIViewContentModeScaleAspectFill;
		self.imageView.clipsToBounds = YES;
		filename_original = nil;
		filename = nil;
		is_downloading = NO;
		data = nil;
		connection = nil;
	}

	return self;
}

- (void)load_url:(NSString*)s
{
	NSURLRequest*	request;

	if (is_downloading == YES)
		return;

	filename = [[NSString alloc] initWithFormat:@"%ix%i-%@",
			 (int)self.frame.size.width, (int)self.frame.size.height, [s url_to_filename]];
	//	[self.image release], self.image = nil;

	if ([filename file_exists] == YES)
	{
		//	NSLog(@"loading from cache: %@", [filename filename_document]);
		[self setBackgroundImage:[UIImage imageWithContentsOfFile:[filename filename_document]] forState:UIControlStateNormal];
		[filename release];
	}
	else
	{
		filename_original = [[NSString alloc] initWithString:[s url_to_filename]];
		if ([filename_original file_exists])
		{
			//	NSLog(@"loading from original...");
			UIImage* the_image = [UIImage imageWithContentsOfFile:[filename_original filename_document]];
			UIImage* resized_image = [the_image image_with_size_aspect_fill:CGSizeMake(self.frame.size.width, self.frame.size.height)];
			[UIView begin_animations:0.3];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
			[UIImagePNGRepresentation(resized_image) writeToFile:[filename filename_document] atomically:YES];
			[self setBackgroundImage:resized_image forState:UIControlStateNormal];
			[UIView commitAnimations];
			[filename_original release], filename_original = nil;
			[filename release], filename = nil;
		}
		else
		{
			if (self.frame.size.width < 128)
				[self setBackgroundImage:[UIImage imageNamed:@"ly-placeholder-2.png"] forState:UIControlStateNormal];
			else if (self.frame.size.width < 256)
				[self setBackgroundImage:[UIImage imageNamed:@"ly-placeholder-4.png"] forState:UIControlStateNormal];
			else
				[self setBackgroundImage:[UIImage imageNamed:@"ly-placeholder-8.png"] forState:UIControlStateNormal];

			//	NSLog(@"downloading from: %@", s);
			is_downloading = YES;
			request = [NSURLRequest requestWithURL:[NSURL URLWithString:s] 
									   cachePolicy:NSURLRequestReturnCacheDataElseLoad 
								   timeoutInterval:30.0];
			connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		}
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
		the_image = [the_image image_with_size_aspect_fill:CGSizeMake(self.frame.size.width, self.frame.size.height)];
		[data writeToFile:[filename_original filename_document] atomically:YES];
		[UIImagePNGRepresentation(the_image) writeToFile:[filename filename_document] atomically:YES];
		[self setBackgroundImage:the_image forState:UIControlStateNormal];
		[UIView commitAnimations];
		//	NSLog(@"saving %@", [filename filename_document]);
	}
	[filename_original release], filename_original = nil;
	[filename release], filename = nil;
    [data release], data = nil;
	[connection release], connection = nil;
}

- (void)dealloc
{
	//	[data release];
	//	[connection release];
    [super dealloc];
}

@end
