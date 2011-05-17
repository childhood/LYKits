#import "LYControl.h"


@implementation UIControl (LYControl)

- (void)disable_for:(CGFloat)duration
{
	self.enabled = NO;
	[self performSelector:@selector(set_enable) withObject:nil afterDelay:duration];
}

- (void)set_enable
{
	self.enabled = YES;
}

@end


@implementation UIBarButtonItem (LYBarButtonItemControl)

- (void)disable_for:(CGFloat)duration
{
	self.enabled = NO;
	[self performSelector:@selector(set_enable) withObject:nil afterDelay:duration];
}

- (void)set_enable
{
	self.enabled = YES;
}

@end
