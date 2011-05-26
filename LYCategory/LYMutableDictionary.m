#import "LYMutableDictionary.h"

@implementation NSMutableDictionary (LYMutableDictionary)
- (void)set_string:(NSString*)str key:(NSString*)key
{
	if (str != nil)
		if ([str isKindOfClass:[NSString class]])
		{
			[self setValue:str forKey:key];
			return;
		}
	[self setValue:@"" forKey:key];
}
@end
