#import "LYSwitch.h"

@implementation UISwitch (LYSwitch)

- (void)bind_setting:(NSString*)key
{
	[self associate:@"ly-setting-name" with:key];
	[self reload_setting];
	[self addTarget:self action:@selector(value_changed) forControlEvents:UIControlEventValueChanged];
}

- (void)reload_setting
{
	[[self associated:@"ly-setting-name"] setting_set_switch:self];
}

- (void)value_changed
{
	//	NSLog(@"SWITCH value changed: %i", self.on);
	[[self associated:@"ly-setting-name"] setting_bool:self.on];
}

@end
