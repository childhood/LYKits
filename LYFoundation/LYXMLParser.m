#import "LYXMLParser.h"

//	#define LYXMLParserDebugEnabled		1

@implementation LYXMLParser

@synthesize data;
@synthesize mode;

- (id)initWithURLString:(NSString*)s
{
	return [self initWithURLString:s mode:@"plain"];
}

- (id)initWithURLString:(NSString*)s mode:(NSString*)a_mode
{
	self = [super init];
	if (self != nil)
	{
		done = NO;
		[self performSelector:@selector(time_out) withObject:nil afterDelay:10];

		data = [[NSMutableArray alloc] init];
		array_path = [[NSMutableArray alloc] init];
		mode = a_mode;
		NSXMLParser* xml = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:s]];
		xml.delegate = self;
		[xml parse];
#ifdef LYXMLParserDebugEnabled
		NSLog(@"PARSER RESULT: %@", [xml parserError]);
#endif
		done = YES;
		[xml release];
	}
	return self;
}

- (void)time_out
{
	//	NSLog(@"parser timeout: done=%i", done);
	if (done == NO)
	{
		//	[self abortParsing];
	}
}

- (void)dealloc
{
	[data release];
	[array_path release];
	[mode release];
	[super dealloc];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSString* s;

#ifdef LYXMLParserDebugEnabled
	NSLog(@"---- %@", string);
#endif
	//	default mode: "plain"
	if (char_added == NO)
	{
		if ([mode isEqualToString:@"simple"])
			[data addObject:string];
		else
			[data addObject:[NSArray arrayWithObjects:[self get_path], string, nil]];
			char_added = YES;
	}
	else
	{
		if ([mode isEqualToString:@"simple"])
		{
			s = [data objectAtIndex:data.count - 1];
			[data replaceObjectAtIndex:data.count - 1 withObject:[s stringByAppendingString:string]];
		}
		else
		{
			s = [[data objectAtIndex:data.count - 1] objectAtIndex:1];
			[data replaceObjectAtIndex:data.count - 1 withObject:[NSArray arrayWithObjects:[self get_path], [s stringByAppendingString:string], nil]];
		}
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
#ifdef LYXMLParserDebugEnabled
	NSLog(@">>>> %@", elementName);
#endif
	[array_path addObject:elementName];
	char_added = NO;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
#ifdef LYXMLParserDebugEnabled
	NSLog(@"<<<< %@", elementName);
#endif
	//	char_added = NO;
	if (char_added == NO)
	{
		if ([mode isEqualToString:@"simple"])
			[data addObject:@""];
		else
			[data addObject:[NSArray arrayWithObjects:[self get_path], @"", nil]];
		char_added = YES;
	}
	[array_path removeLastObject];
}

- (NSString*)get_path
{
	NSString*	s = [array_path objectAtIndex:0];
	NSInteger	i;

	for (i = 1; i < array_path.count; i++)
	{
		s = [s stringByAppendingFormat:@"-%@", [array_path objectAtIndex:i]];
	}

	return s;
}

@end
