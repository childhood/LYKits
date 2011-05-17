#import "MQArray.h"

@implementation NSArray (MQArray)

- (id)object_at_index:(NSInteger)index
{
	if (self.count > index)
		return [self objectAtIndex:index];
	else
		return nil;
}

- (id)object_at_path:(NSIndexPath*)path
{
	if ([self object_at_index:path.section] != nil)
 		return [[self object_at_index:path.section] object_at_index:path.row];
	
	return nil;
}

- (id)object_as_object:(id)obj in_array:(NSArray*)array
{
	int i;

	for (i = 0; i < array.count; i++)
	{
		if (obj == [array objectAtIndex:i])
			return [self object_at_index:i];
	}

	return nil;
}

- (BOOL)contains_string:(NSString*)s
{
	id	obj;
	for (obj in self)
		if ([obj isKindOfClass:[NSString class]])
			if ([(NSString*)[obj uppercaseString] isEqualToString:[s uppercaseString]])
				return YES;
	return NO;
}

- (void)play_caf
{
	se_play_caf_random(self);
}

- (id)object_of:(id)obj offset:(int)i repeat:(BOOL)b
{
	int index = [self indexOfObject:obj];
	index += i;
	if (index >= (int)self.count)
	{
		if (b == YES)
			index = index - self.count;
		else
			index = self.count - 1;
	}
	else if (index < 0)
	{
		if (b == YES)
			index = self.count + index;
		else
			index = 0;
	}
	return [self object_at_index:index];
}

@end
