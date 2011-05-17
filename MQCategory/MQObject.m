#import "MQObject.h"

@implementation NSObject (MQObject)

- (id)perform_string:(NSString*)string
{
	return [self perform_selector:NSSelectorFromString(string)];
}

- (id)perform_string:(NSString*)string with:(id)obj
{
	return [self perform_selector:NSSelectorFromString(string) with:obj];
}

- (id)perform_string:(NSString*)string with:(id)obj1 with:(id)obj2
{
	return [self perform_selector:NSSelectorFromString(string) with:obj1 with:obj2];
}

- (id)perform_selector:(SEL)selector
{
	if ([self respondsToSelector:selector] == NO)
		return nil;

	return [self performSelector:selector];
}

- (id)perform_selector:(SEL)selector with:(id)obj
{
	if ([self respondsToSelector:selector] == NO)
		return nil;

	return [self performSelector:selector withObject:obj];
}

- (id)perform_selector:(SEL)selector with:(id)obj1 with:(id)obj2
{
	if (self == nil)
		return nil;
	if ([self respondsToSelector:selector] == NO)
		return nil;

	return [self performSelector:selector withObject:obj1 withObject:obj2];
}

@end
