#import "LYArray.h"

@implementation NSArray (LYArray)

- (id)i:(NSUInteger)index
{
	return [self objectAtIndex:index];
}

- (id)object_at_index:(NSUInteger)index
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
#ifdef LY_ENABLE_OPENAL
	se_play_caf_random(self);
#endif
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

- (NSDictionary*)whose:(NSString*)key is:(NSString*)value
{
	for (id obj in self)
	{
		if ([obj isKindOfClass:[NSDictionary class]])
		{
			NSDictionary* dict = (NSDictionary*)obj;
			if ([[dict v:key] is:value])
				return dict;
		}
	}
	return nil;
}

@end
