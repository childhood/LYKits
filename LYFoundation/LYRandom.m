#import "LYRandom.h"

static LYRandom *ly_shared_manager = nil;

@implementation LYRandom

//	@synthesize property;

+ (CGPoint)random_point:(CGSize)win_size
{
	return CGPointMake(random() % (int)win_size.width, random() % (int)win_size.height);
}

+ (NSUInteger)get_hash:(NSString*)string
{
	return [self get_hash:string with_correction:0];
}

+ (NSUInteger)get_hash:(NSString*)string with_correction:(NSUInteger)correction
{
	const char*	p;
	NSUInteger	i, ret;
	@synchronized(self)
	{
		ret = 0;
		p = [string UTF8String];
		for (i = 0; i < string.length; i++)
		{
			//	NSLog(@"%i: %i", i, p[i]);
			ret += (NSUInteger)(p[i] + correction) * (12345678 + i);
		}
	}
	return ret;
}

+ (NSString*)unique_string
{
	return [[NSProcessInfo processInfo] globallyUniqueString];
}

+ (NSUInteger)random_max:(NSUInteger)max key:(NSString*)key
{
	NSUInteger ret;
	@synchronized(self)
	{
		ret = [self get_hash:key] % max;
	}
	return ret;
}

#pragma mark font

+ (NSString*)font_family
{
	return [self font_family_with_random:random()];
}

+ (NSString*)font_family_for_key:(NSString*)key
{
	return [self font_family_with_random:[self get_hash:key]];
}

+ (NSString*)font_family_with_random:(NSUInteger)r
{
	NSString* ret;
	@synchronized(self)
	{
		NSArray* array = [UIFont familyNames];
		int index = r % array.count;
		ret = [array objectAtIndex:index];
	}
	return ret;
}

+ (NSString*)font_name
{
	return [self font_name_with_random:random() family:[self font_family]];
}

+ (NSString*)font_name_for_key:(NSString*)key
{
	return [self font_name_with_random:[self get_hash:key] family:[self font_family_for_key:key]];
}

+ (NSString*)font_name_with_random:(NSUInteger)r family:(NSString*)family;
{
	NSString* ret;
	@synchronized(self)
	{
		NSArray* array = [UIFont fontNamesForFamilyName:family];
		int index = r % array.count;
		ret = [array objectAtIndex:index];
	}
	return ret;
}

#pragma mark color

+ (UIColor*)color_with_random_r:(NSUInteger)red g:(NSUInteger)green b:(NSUInteger)blue from:(NSUInteger)min to:(NSUInteger)max
{
	UIColor* ret;
	@synchronized(self)
	{
		CGFloat r = max + red % min;
		CGFloat g = max + green % min;
		CGFloat b = max + blue % min;
		ret = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1];
	}
	return ret;
}

+ (UIColor*)dark_color
{
	return [self color_with_random_r:random() g:random() b:random() from:100 to:0];
}

+ (UIColor*)dark_color_for_key:(NSString*)key
{
	return [self color_with_random_r:[self get_hash:key with_correction:1] 
								   g:[self get_hash:key with_correction:2]
								   b:[self get_hash:key with_correction:3]
								from:100 to:50];
}

+ (UIColor*)bright_color
{
	return [self color_with_random_r:random() g:random() b:random() from:55 to:200];
}

+ (UIColor*)bright_color_for_key:(NSString*)key
{
	return [self color_with_random_r:[self get_hash:key with_correction:4] 
								   g:[self get_hash:key with_correction:5]
								   b:[self get_hash:key with_correction:6]
								from:55 to:200];
}

#pragma mark singleton

+ (id)manager
{
	@synchronized(self)
	{
		if (ly_shared_manager == nil)
			[[self alloc] init];
	}
	return ly_shared_manager;
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (ly_shared_manager == nil)
		{
			ly_shared_manager = [super allocWithZone:zone];
			return ly_shared_manager;
		}
	}
	return nil;
}
- (id)init
{
	if (self = [super init])
	{
		srandomdev();
		//	property = @"string";
	}
	return self;
}

+ (NSString*)contents_of_file:(NSString*)filename separator:(NSString*)separator
{
	NSString*	s;
	NSArray*	array;

	@synchronized(self)
	{
		s = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
		if (s == nil)
			return s;
		array = [s componentsSeparatedByString:separator];
	}
	//	NSLog(@"file contents array: %@, %i", array, random() % array.count);
	return [array objectAtIndex:random() % array.count];
}

+ (NSString*)national_motto
{
	return [LYRandom contents_of_file:[@"ly_database_national_motto.txt" filename_bundle] separator:@"\n"];
}

@end
