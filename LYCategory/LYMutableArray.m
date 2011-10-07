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
		eachObject = va_arg(argumentList, id);
		while (eachObject)
		{
			//	NSLog(@"adding: %@", eachObject);
			[self addObject:eachObject];
			eachObject = va_arg(argumentList, id);
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
		eachObject = va_arg(argumentList, id);
		while (eachObject)
		{
			[[self objectAtIndex:self.count - 1] addObject:eachObject];
			eachObject = va_arg(argumentList, id);
		}
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

- (BOOL)exchange_path:(NSIndexPath*)path1 with:(NSIndexPath*)path2
{
	id obj1 = [self object_at_path:path1];
	id obj2 = [self object_at_path:path2];
	if ((obj1 == nil) || (obj2 == nil))
		return NO;

	//	NSLog(@"exchange: %@\n%@", obj1, obj2);
	if (path1.section == path2.section)
	{
		[[self objectAtIndex:path1.section] exchangeObjectAtIndex:path1.row withObjectAtIndex:path2.row];
	}
	else
	{
		[[self objectAtIndex:path1.section] insertObject:obj2 atIndex:path1.row];
		[[self objectAtIndex:path2.section] insertObject:obj1 atIndex:path2.row];
		[[self objectAtIndex:path1.section] removeObjectAtIndex:path1.row + 1];
		[[self objectAtIndex:path2.section] removeObjectAtIndex:path2.row + 1];
	}

	return YES;
}

@end
