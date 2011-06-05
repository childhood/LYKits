#import "LYMutableArray.h"

@implementation NSMutableArray (LYMutableArray)

- (void)add_objects:(id)firstObject, ...
{
	id eachObject;
	va_list argumentList;

	if (firstObject)
	{
		[self addObject: firstObject];
		va_start(argumentList, firstObject);
		while (eachObject = va_arg(argumentList, id))
		{
			//	NSLog(@"adding: %@", eachObject);
			[self addObject:eachObject];
		}
		va_end(argumentList);
	}
}

//	add mutable array with objects
- (void)add_array:(id) firstObject, ...
{
	id eachObject;
	va_list argumentList;

	if (firstObject)
	{
		[self addObject:[NSMutableArray arrayWithObjects:firstObject, nil]];
		va_start(argumentList, firstObject);
		while (eachObject = va_arg(argumentList, id))
			[[self objectAtIndex:self.count - 1] addObject:eachObject];
		va_end(argumentList);
	}
	else
		[self addObject:[NSMutableArray arrayWithObjects:nil]];
}

- (BOOL)add_object_unique:(id)obj
{
	if ([self containsObject:obj] == NO)
	{
		[self addObject:obj];
		return YES;
	}
	return NO;
}

- (BOOL)insert_unique:(id)obj at:(int)index
{
	if ([self containsObject:obj] == NO)
	{
		[self insertObject:obj atIndex:index];
		return YES;
	}
	return NO;
}

- (void)sort_by_key:(NSString*)key ascending:(BOOL)b
{
	NSSortDescriptor*   descriptor;
	descriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:b];
	[self sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
}

@end
