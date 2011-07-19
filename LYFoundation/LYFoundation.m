#import "LYFoundation.h"

BOOL is_phone(void)
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		return YES;
	else
		return NO;
}

BOOL is_pad(void)
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return YES;
	else
		return NO;
}

void set_setting_bool(NSString* key, BOOL b)
{
	[[NSUserDefaults standardUserDefaults] setBool:b forKey:key];
}

void set_setting_integer(NSString* key, NSInteger i)
{
	[[NSUserDefaults standardUserDefaults] setInteger:i forKey:key];
}

void set_setting_string(NSString* key, NSObject* obj)
{
	[[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
}

BOOL setting_bool(NSString* key)
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

NSInteger setting_integer(NSString* key)
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

NSString* setting_string(NSString* key)
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}
