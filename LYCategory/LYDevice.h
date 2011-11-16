#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <sys/types.h>
#import <sys/sysctl.h>

@interface UIDevice (LYDevice)

+ (vm_size_t)memory_stats:(vm_statistics_data_t*)vm_stat;
+ (void)log_memory_usage;
+ (uint64_t)memory_wired;
+ (uint64_t)memory_active;
+ (uint64_t)memory_inactive;
+ (uint64_t)memory_used;
+ (uint64_t)memory_free;
+ (uint64_t)memory_total;
+ (void)free_memory;

@end
