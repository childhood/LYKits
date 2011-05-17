#import <Foundation/Foundation.h>
#import "supersound.h"

@interface NSArray (MQArray)

//	"safe" version of objectAtIndex
- (id)object_at_index:(NSInteger)index;
- (id)object_at_path:(NSIndexPath*)path;

//	suppose obj is the Xth object in array, return the Xth object of self
- (id)object_as_object:(id)obj in_array:(NSArray*)array;
- (BOOL)contains_string:(NSString*)s;
//	suppose obj is the Xth object in self, return the i+Xth object, with option report or not
- (id)object_of:(id)obj offset:(int)i repeat:(BOOL)b;

- (void)play_caf;

@end
