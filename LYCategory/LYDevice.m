#import "LYDevice.h"

@implementation UIDevice (LYDevice)

+ (vm_size_t)memory_stats:(vm_statistics_data_t*)vm_stat
{
	@synchronized(self)
	{
		//	physical memory not working on ios
#if 0
		int64_t physical_memory;
		int mib[2];
		mib[0] = CTL_HW;
		mib[1] = HW_MEMSIZE;
		size_t length = sizeof(int64_t);
		sysctl(mib, 2, &physical_memory, &length, NULL, 0);
		NSLog(@"physical memory: %lluG", physical_memory / 1024 / 1024 / 1024);

		uint64_t	count;
		size_t  	size=sizeof(count) ;
		if (sysctlbyname("hw.memsize",&count,&size,NULL,0)) 
			return 0;
		NSLog(@"count: %lluG", count / 1024 / 1024 / 1024);
#endif
		//	memory i used
#if 0
		struct task_basic_info t_info;
		mach_msg_type_number_t t_info_count = TASK_BASIC_INFO_COUNT;

		if (KERN_SUCCESS != task_info(mach_task_self(),
									  TASK_BASIC_INFO, (task_info_t)&t_info, 
									  &t_info_count))
		{
			return -1;
		}
		NSLog(@"resident: %uM, virtual: %uM", t_info.resident_size / 1024 / 1024, t_info.virtual_size / 1024 / 1024);
#endif

		mach_port_t host_port;
		mach_msg_type_number_t host_size;
		vm_size_t pagesize;
		
		host_port = mach_host_self();
		host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
		host_page_size(host_port, &pagesize);
	 
		if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)vm_stat, &host_size) != KERN_SUCCESS)
			return 0;

		return pagesize;
	}
}

+ (void)log_memory_usage
{
	@synchronized(self)
	{
		vm_statistics_data_t vm_stat;
		vm_size_t pagesize = [UIDevice memory_stats:&vm_stat];
		if (pagesize == 0)
		{
			NSLog(@"Failed to fetch vm statistics");
			return;
		}
#if 0
		NSLog(@"zero:	%uM", vm_stat.zero_fill_count * pagesize / 1024 / 1024);
		NSLog(@"react:	%uM", vm_stat.reactivations * pagesize / 1024 / 1024);
		NSLog(@"p.in:	%uM", vm_stat.pageins * pagesize / 1024 / 1024);
		NSLog(@"p.out:	%uM", vm_stat.pageouts * pagesize / 1024 / 1024);
		NSLog(@"faults:	%uM", vm_stat.faults * pagesize / 1024 / 1024);
		NSLog(@"cow:	%uM", vm_stat.cow_faults * pagesize / 1024 / 1024);
		NSLog(@"lookup:	%uM", vm_stat.lookups * pagesize / 1024 / 1024);
		NSLog(@"hits:	%uM", vm_stat.hits * pagesize / 1024 / 1024);
#endif
		/* Stats in bytes */ 
		uint64_t mem_wired		= vm_stat.wire_count * pagesize;
		uint64_t mem_active		= vm_stat.active_count * pagesize;
		uint64_t mem_inactive	= vm_stat.inactive_count * pagesize;
		uint64_t mem_used	= mem_wired + mem_active + mem_inactive;
		uint64_t mem_free	= vm_stat.free_count * pagesize;
		uint64_t mem_total	= mem_used + mem_free;
		//NSLog(@"wired: %lluM\tactive: %lluM\tinactive: %lluM", mem_wired / 1024 / 1024, mem_active / 1024 / 1024, mem_inactive / 1024 / 1024);
		NSLog(@"used: %lluM\tfree: %lluM\ttotal: %lluM", mem_used / 1024 / 1024, mem_free / 1024 / 1024, mem_total / 1024 / 1024);
		//NSLog(@"used: %u free: %u total: %u", mem_used, mem_free, mem_total);
	}
}

+ (uint64_t)memory_wired
{
	@synchronized(self)
	{
		vm_statistics_data_t vm_stat;
		vm_size_t pagesize = [UIDevice memory_stats:&vm_stat];
		if (pagesize == 0)
			return 0;
		uint64_t mem_wired		= vm_stat.wire_count * pagesize;
		return mem_wired;
	}
}

+ (uint64_t)memory_active
{
	@synchronized(self)
	{
		vm_statistics_data_t vm_stat;
		vm_size_t pagesize = [UIDevice memory_stats:&vm_stat];
		if (pagesize == 0)
			return 0;
		uint64_t mem_active		= vm_stat.active_count * pagesize;
		return mem_active;
	}
}

+ (uint64_t)memory_inactive
{
	@synchronized(self)
	{
		vm_statistics_data_t vm_stat;
		vm_size_t pagesize = [UIDevice memory_stats:&vm_stat];
		if (pagesize == 0)
			return 0;
		uint64_t mem_inactive	= vm_stat.inactive_count * pagesize;
		return mem_inactive;
	}
}

+ (uint64_t)memory_used
{
	@synchronized(self)
	{
		vm_statistics_data_t vm_stat;
		vm_size_t pagesize = [UIDevice memory_stats:&vm_stat];
		if (pagesize == 0)
			return 0;
		uint64_t mem_wired		= vm_stat.wire_count * pagesize;
		uint64_t mem_active		= vm_stat.active_count * pagesize;
		uint64_t mem_inactive	= vm_stat.inactive_count * pagesize;
		uint64_t mem_used	= mem_wired + mem_active + mem_inactive;
		return mem_used;
	}
}

+ (uint64_t)memory_free
{
	@synchronized(self)
	{
		vm_statistics_data_t vm_stat;
		vm_size_t pagesize = [UIDevice memory_stats:&vm_stat];
		if (pagesize == 0)
			return 0;
		uint64_t mem_free	= vm_stat.free_count * pagesize;
		return mem_free;
	}
}

+ (uint64_t)memory_total
{
	@synchronized(self)
	{
		vm_statistics_data_t vm_stat;
		vm_size_t pagesize = [UIDevice memory_stats:&vm_stat];
		if (pagesize == 0)
			return 0;
		uint64_t mem_wired		= vm_stat.wire_count * pagesize;
		uint64_t mem_active		= vm_stat.active_count * pagesize;
		uint64_t mem_inactive	= vm_stat.inactive_count * pagesize;
		uint64_t mem_used	= mem_wired + mem_active + mem_inactive;
		uint64_t mem_free	= vm_stat.free_count * pagesize;
		uint64_t mem_total	= mem_used + mem_free;
		return mem_total;
	}
}

+ (void)free_memory
{
	@synchronized(self)
	{
		uint64_t mem_free = 0;
		uint64_t mem_last;
		do
		{
			mem_last = mem_free;
			mem_free = [UIDevice memory_free];
			//	if (mem_free < 280 * 1024 * 1024)
			{
				NSLog(@"free mem: %lluM", mem_free / 1024 / 1024);
				if (mem_free > 1024 * 1024 * 6)
					mem_free -= 1024 * 1024 * 5;
				else
					mem_free /= 2;
				char* buf;
				buf = malloc(mem_free);
				memset(buf, 0, mem_free);
				free(buf);
			}
		}	while (mem_free > mem_last);
		[UIDevice log_memory_usage];
	}
}

+ (NSArray*)process_running
{
	@synchronized(self)
	{
		int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
		size_t miblen = 4;

		size_t size;
		int st = sysctl(mib, miblen, NULL, &size, NULL, 0);

		struct kinfo_proc * process = NULL;
		struct kinfo_proc * newprocess = NULL;

		do
		{
			size += size / 10;
			newprocess = realloc(process, size);

			if (!newprocess)
			{
				if (process){
					free(process);
				}

				return nil;
			}

			process = newprocess;
			st = sysctl(mib, miblen, process, &size, NULL, 0);

		} while (st == -1 && errno == ENOMEM);

		if (st == 0){

			if (size % sizeof(struct kinfo_proc) == 0){
				int nprocess = size / sizeof(struct kinfo_proc);

				if (nprocess){

					NSMutableArray * array = [[NSMutableArray alloc] init];

					for (int i = nprocess - 1; i >= 0; i--){

						NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
						NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];

						NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName, nil] 
																			forKeys:[NSArray arrayWithObjects:@"pid", @"name", nil]];
						[processID release];
						[processName release];
						[array addObject:dict];
						[dict release];
					}

					free(process);
					return [array autorelease];
				}
			}
		}

		return nil;
	}
}

@end


@implementation UIDevice (Hardware)
/*
 Platforms
 
 iFPGA ->        ??

 iPhone1,1 ->    iPhone 1G, M68
 iPhone1,2 ->    iPhone 3G, N82
 iPhone2,1 ->    iPhone 3GS, N88
 iPhone3,1 ->    iPhone 4/AT&T, N89
 iPhone3,2 ->    iPhone 4/Other Carrier?, ??
 iPhone3,3 ->    iPhone 4/Verizon, TBD
 iPhone4,1 ->    (iPhone 5/AT&T), TBD
 iPhone4,2 ->    (iPhone 5/Verizon), TBD

 iPod1,1   ->    iPod touch 1G, N45
 iPod2,1   ->    iPod touch 2G, N72
 iPod2,2   ->    Unknown, ??
 iPod3,1   ->    iPod touch 3G, N18
 iPod4,1   ->    iPod touch 4G, N80
 
 // Thanks NSForge
 iPad1,1   ->    iPad 1G, WiFi and 3G, K48
 iPad2,1   ->    iPad 2G, WiFi, K93
 iPad2,2   ->    iPad 2G, GSM 3G, K94
 iPad2,3   ->    iPad 2G, CDMA 3G, K95
 iPad3,1   ->    (iPad 3G, GSM)
 iPad3,2   ->    (iPad 3G, CDMA)

 AppleTV2,1 ->   AppleTV 2, K66

 i386, x86_64 -> iPhone Simulator
*/

#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
}

- (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Tom Harrington (Atomicbird)
- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!
- (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
    NSString *platform = [self platform];

    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;

    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])            return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])            return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])            return UIDevice5iPhone;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])             return UIDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"])              return UIDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"])              return UIDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"])              return UIDevice4GiPod;

    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDevice1GiPad;
    if ([platform hasPrefix:@"iPad2"])              return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad3"])              return UIDevice3GiPad;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;

    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    
     // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceiPhoneSimulatoriPhone : UIDeviceiPhoneSimulatoriPad;
    }

    return UIDeviceUnknown;
}

- (NSString *) platformString
{
    switch ([self platformType])
    {
        case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
        case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
        case UIDevice3GSiPhone: return IPHONE_3GS_NAMESTRING;
        case UIDevice4iPhone: return IPHONE_4_NAMESTRING;
        case UIDevice5iPhone: return IPHONE_5_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
        
        case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
        case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
        case UIDevice3GiPod: return IPOD_3G_NAMESTRING;
        case UIDevice4GiPod: return IPOD_4G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad : return IPAD_1G_NAMESTRING;
        case UIDevice2GiPad : return IPAD_2G_NAMESTRING;
        case UIDevice3GiPad : return IPAD_3G_NAMESTRING;
        case UIDeviceUnknowniPad : return IPAD_UNKNOWN_NAMESTRING;
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceUnknownAppleTV: return APPLETV_UNKNOWN_NAMESTRING;
            
        case UIDeviceiPhoneSimulator: return IPHONE_SIMULATOR_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPhone: return IPHONE_SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPad: return IPHONE_SIMULATOR_IPAD_NAMESTRING;
            
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
        default: return IOS_FAMILY_UNKNOWN_DEVICE;
    }
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    // NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X", 
    //                       *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);

    return outstring;
}

// Illicit Bluetooth check -- cannot be used in App Store
/* 
Class  btclass = NSClassFromString(@"GKBluetoothSupport");
if ([btclass respondsToSelector:@selector(bluetoothStatus)])
{
    printf("BTStatus %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
    bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
    printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
}
*/
@end
