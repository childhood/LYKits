#import "LYCategory.h"
#import "ASIHTTPRequest.h"
#import "CJSONSerializer.h"

@interface LYDatabase: NSObject
{
	NSMutableDictionary* data;
}
@property (nonatomic, retain) NSMutableDictionary*	data;

- (id)init;
- (void)name:(NSString*)name select:(NSString*)query block:(void (^)(NSArray* array, NSError* error))callback;
- (void)name:(NSString*)name insert:(NSArray*)array block:(void (^)(NSArray* keys, NSError* error))callback;
- (void)test;

@end
