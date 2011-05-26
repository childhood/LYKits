#import "LYSwitch.h"

@implementation UISwitch (LYSwitch)
- (void)bind_setting:(NSString*)key
{
	[key setting_set_switch:self];
	[self associate:@"ly-setting-name" with:key];
	[self addTarget:self action:@selector(value_changed) forControlEvents:UIControlEventValueChanged];
}
- (void)value_changed
{
	[[self associated:@"ly-setting-name"] setting_bool:self.on];
}
@end
