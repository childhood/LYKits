#import "MQUIKit.h"
#import "MWFeedParser.h"
#import "NSString+HTML.h"

@interface MQFeedParser: NSObject <MWFeedParserDelegate>
{
	MWFeedParser*	parser;
	NSMutableArray*	data;
	NSString*	title;
	NSString*	link;
	NSString*	summary;
	NSString*	url;
	BOOL		is_google;
}
@property (nonatomic, retain) NSString*			url;
@property (nonatomic, retain) NSMutableArray*	data;
@property (nonatomic) BOOL	is_google;

- (id)initWithURL:(NSString*)a_url;
- (BOOL)parse;
- (BOOL)parse:(NSString*)a_url;

@end
