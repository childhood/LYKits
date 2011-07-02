#import <UIKit/UIKit.h>
#import "LYCategory.h"

@interface UISwitch (LYSwitch)

- (void)bind_setting:(NSString*)key;
- (void)reload_setting;

@end
