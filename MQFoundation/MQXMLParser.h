#import <UIKit/UIKit.h>

/*
 * USAGE:
 *
	MQXMLParser* xml = [[MQXMLParser alloc] initWithURLString:url mode:@"simple"];
	[MQCache set_object:xml.data for_key:url];
	[xml release];
 *
 * MODES:
 * 	simple	- ignore tag names
 * 	plain	- tag-make-like-this
 *
 */

@interface MQXMLParser: NSObject <NSXMLParserDelegate>
{
	NSMutableArray*		data;
	NSMutableArray*		array_path;
	BOOL				char_added;
	NSString*			mode;
	BOOL				done;
}
@property (nonatomic, retain) NSMutableArray*	data;
@property (nonatomic, retain) NSString*			mode;
- (id)initWithURLString:(NSString*)s;
- (id)initWithURLString:(NSString*)s mode:(NSString*)a_mode;
- (NSString*)get_path;
@end
