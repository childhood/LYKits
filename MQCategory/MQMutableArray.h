#import <Foundation/Foundation.h>
#import "MQArray.h"

@interface NSMutableArray (MQMutableArray)
- (void)add_objects:(id) firstObject, ...;
- (void)add_array:(id) firstObject, ...;
- (BOOL)add_object_unique:(id)obj;
- (void)sort_by_key:(NSString*)key ascending:(BOOL)b;
@end
