#import "LYKits.h"

static LYKits*	ly_shared_manager = nil;

@implementation LYKits

@synthesize version;

+ (id)shared
{
	@synchronized(self)
	{
		if (ly_shared_manager == nil)
			[[self alloc] init];
		return ly_shared_manager;
	}
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
		return nil;
	}
}
- (id)init
{
	self = [super init];
	if (self != nil)
		version = @"LYKits v0.1";
	return self;
}

+ (NSString*)version_string
{
	@synchronized(self)
	{
		return (NSString*)[[LYKits shared] version];		//	XXX why warning here?
	}
}

#pragma mark foundation

+ (BOOL)is_phone
{
	@synchronized(self)
	{
		return is_phone();
	}
}

+ (BOOL)is_pad
{
	@synchronized(self)
	{
		return is_pad();
	}
}

#pragma mark ui

+ (UIInterfaceOrientation)get_interface_orientation
{
	@synchronized(self)
	{
		return get_interface_orientation();
	}
}

+ (BOOL)is_interface_portrait
{
	@synchronized(self)
	{
		return is_interface_portrait();
	}
}

+ (BOOL)is_interface_landscape
{
	@synchronized(self)
	{
		return is_interface_portrait();
	}
}

+ (CGFloat)get_width:(CGFloat)width
{
	@synchronized(self)
	{
		return get_width(width);
	}
}

+ (CGFloat)get_height:(CGFloat)height
{
	@synchronized(self)
	{
		return get_height(height);
	}
}

+ (CGFloat)screen_width
{
	@synchronized(self)
	{
		return screen_width();
	}
}

+ (CGFloat)screen_height;
{
	@synchronized(self)
	{
		return screen_height();
	}
}

+ (CGFloat)screen_max
{
	@synchronized(self)
	{
		return screen_max();
	}
}

@end
