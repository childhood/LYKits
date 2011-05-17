#import "MQFeedParser.h"

@implementation MQFeedParser

@synthesize url;
@synthesize data;
@synthesize is_google;

- (id)initWithURL:(NSString*)a_url
{
	self = [super init];
	if (self != nil)
	{
		is_google = NO;
		url = a_url;
	}
	return self;
}

- (BOOL)parse
{
	return [self parse:nil];
}

- (BOOL)parse:(NSString*)a_url
{
	NSLog(@"FEED preparing:\t'%@'", a_url);
	if (a_url != nil)
		if (is_google)
			url = [@"http://www.google.com/reader/atom/feed/" stringByAppendingString:[a_url to_url]];
		else
			url = a_url;

	[MQCache set:url key:@"feed-current-url"];
	//	if (data != nil) [data release];
	data = [MQCache get_key:url];
	if (data != nil)
		return YES;

	[MQLoading show];
	data = [[NSMutableArray alloc] init];
	parser = [[MWFeedParser alloc] initWithFeedURL:url];
	parser.delegate = self;
	parser.feedParseType = ParseTypeFull;
	parser.connectionType = ConnectionTypeSynchronously;
	[parser parse];
	[parser release];

	if (data == nil)
		return NO;
	[MQCache set:data key:url];
	//	NSLog(@"data: %@", data);
	return YES;	
}

#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser
{
	NSLog(@"FEED started:\t'%@'", [MQCache get_key:@"feed-current-url"]);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
	title	= info.title;
	link	= info.link;
	summary	= info.summary;
	title = info.title;
	[MQCache set:info.title key:[NSString stringWithFormat:@"feed-header-%@", [MQCache get_key:@"feed-current-url"]]];
#if 0
	NSLog(@"FEED got info: %@", info);
	NSLog(@"1: %@", info.title);
	NSLog(@"2: %@", info.link);
	NSLog(@"3: %@", info.summary);
#endif
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	NSString* s;

	[dict setValue:item.identifier forKey:@"id"];
	[dict setValue:item.title forKey:@"title"];
	[dict setValue:item.link forKey:@"link"];
	[dict setValue:item.date forKey:@"date"];
	[dict setValue:item.updated forKey:@"updated"];
	if (is_google)
		s = [item.summary stringByReplacingOccurrencesOfString:@"<blockquote>Shared by " withString:@"<blockquote>Editor: "];
	else
		s = item.summary;
	[dict setValue:s forKey:@"summary"];
	[dict setValue:item.content forKey:@"content"];
	[dict setValue:item.enclosures forKey:@"enclosures"];
#if 0
	NSLog(@"FEED got item: %@", item);
	NSLog(@"1: %@", item.identifier);
	NSLog(@"2: %@", item.title);
	NSLog(@"3: %@", item.link);
	NSLog(@"4: %@", item.date);
	NSLog(@"5: %@", item.updated);
	NSLog(@"6: %@", item.summary);
	NSLog(@"7: %@", item.content);
	NSLog(@"8: %@", item.enclosures);
#endif
	[data addObject:dict];
	[dict release];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser
{
	//	NSLog(@"FEED finished: %@", data);
	[MQLoading hide];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
	NSLog(@"FEED failed: %@", error);
	[MQLoading hide];
	[data release];
	data = nil;
}

@end
