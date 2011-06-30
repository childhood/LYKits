#import "LYDictionary.h"

@implementation NSDictionary (LYDictionary)
- (id)v:(NSString*)key
{
	return [self valueForKey:key];
}
@end
