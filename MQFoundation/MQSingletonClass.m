#import "MQSingletonClass.h"

@implementation MQSingletonClass
- (id)copyWithZone:(NSZone *)zone
{
	return self;
}
- (id)retain
{
	return self;
}
- (unsigned)retainCount
{
	return UINT_MAX; //denotes an object that cannot be released
}
- (void)release
{
	// never release
}
- (id)autorelease
{
	return self;
}
- (id)init
{
	self = [super init];
	return self;
}
- (void)dealloc {
	// Should never be called, but just here for clarity really.
	[super dealloc];
}
@end

@implementation MQSingletonViewController
- (id)copyWithZone:(NSZone *)zone
{
	return self;
}
- (id)retain
{
	return self;
}
- (unsigned)retainCount
{
	return UINT_MAX; //denotes an object that cannot be released
}
- (void)release
{
	// never release
}
- (id)autorelease
{
	return self;
}
- (id)init
{
	self = [super init];
	return self;
}
- (void)dealloc {
	// Should never be called, but just here for clarity really.
	[super dealloc];
}
@end

#pragma mark Singleton Example

static MySingletonClass *my_shared_manager = nil;

@implementation MySingletonClass

@synthesize property;

+ (id)shared
{
	@synchronized(self)
	{
		if (my_shared_manager == nil)
			[[self alloc] init];
	}
	return my_shared_manager;
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (my_shared_manager == nil)
		{
			my_shared_manager = [super allocWithZone:zone];
			return my_shared_manager;
		}
	}
	return nil;
}
- (id)init
{
	if (self = [super init])
		property = @"string";
	return self;
}
@end
