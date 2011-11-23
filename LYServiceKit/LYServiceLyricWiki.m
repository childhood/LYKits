#import "LYServiceLyricWiki.h"

#ifdef LY_ENABLE_SDK_ASIHTTP
@implementation LYServiceLyricWiki

@synthesize data;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		data = [[NSMutableDictionary alloc] init];
		[data key:@"host"	v:@"http://lyrics.wikia.com"];
		[data key:@"head"	v:@"<div class='lyricbox'>"];
		[data key:@"tail"	v:@"<p>NewPP limit report"];
	}
	return self;
}

- (void)dealloc
{
	[data release];
	[super dealloc];
}

- (void)lyric_by_artist:(NSString*)artist song:(NSString*)song block:(LYBlockVoidStringError)callback
{
	NSString* url = [NSString stringWithFormat:@"%@/%@:%@", [data v:@"host"], [artist to_url], [song to_url]];
	__block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
	//	NSLog(@"LYRIC url: %@", url);
	[request setCompletionBlock:^{
		NSString* html = request.responseString;
		NSRange range_head, range_tail;
		range_head = [html rangeOfString:[data v:@"head"]];
		range_tail = [html rangeOfString:[data v:@"tail"]];
		if (range_head.location != NSNotFound)
		{
			html = [html substringFromIndex:range_head.location + range_head.length];
			html = [html substringToIndex:range_tail.location - range_head.location - range_head.length];

			range_head = [html rangeOfString:@"</div>"];
			if (range_head.location != NSNotFound)
			{
				html = [html substringFromIndex:range_head.location + range_head.length];
				html = [html substringToIndex:html.length - 6];
				callback(html, nil);
			}
			else
				callback(nil, [NSError errorWithDomain:@"Error Parsing Lyric" code:3 userInfo:nil]);
			//	NSLog(@"LYRIC html: %@", html);
		}
		else
			callback(nil, [NSError errorWithDomain:@"Lyric Not Found" code:4 userInfo:nil]);
	}];
	[request setFailedBlock:^{
		callback(nil, request.error);
	}];
	[request startAsynchronous];
}

@end
#endif
