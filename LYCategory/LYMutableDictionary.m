#import "LYMutableDictionary.h"

@implementation NSMutableDictionary (LYMutableDictionary)

- (void)key:(NSString*)key v:(id)obj
{
	[self setValue:obj forKey:key];
}

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
