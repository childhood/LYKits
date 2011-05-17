#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

@interface UIDevice (MQDevice)

+ (void)log_memory_usage;

@end
