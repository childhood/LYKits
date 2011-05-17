#import "MQNavigationBar.h"

@implementation UINavigationBar (MQNavigationBar)

- (id)init
{
	bg = nil;
	self = [super init];
	return self;
}

#ifdef MQ_ENABLE_CATEGORY_NAVIGATIONBAR_BACKGROUND
- (void)drawRect:(CGRect)rect
{
	//	NSLog(@"nav draw rect %@", bg);
	if (bg != nil)
		[bg.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	else
		[super drawRect:rect];
}
#endif

- (void)set_background_image:(UIImage*)image
{
	//NSLog(@"uivigationbar set background image: %@", image);
	if (image == nil) return;
	bg = [[UIImageView alloc] initWithImage:image];
	bg.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
	//[self addSubview:bg];
	//[self sendSubviewToBack:bg];
	//[bg release];
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
	[super insertSubview:view atIndex:index];
	[self sendSubviewToBack:bg];
}

- (void)sendBackgroundToBack
{
	[self sendSubviewToBack:bg];
}

@end
