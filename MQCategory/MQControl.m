#import "MQControl.h"


@implementation UIControl (MQControl)

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


@implementation UIBarButtonItem (MQBarButtonItemControl)

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
