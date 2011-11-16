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
				mem_free -= 1024 * 1024 * 5;
				char* buf;
				buf = malloc(mem_free);
				memset(buf, 0, mem_free);
				free(buf);
			}
		}	while (mem_free > mem_last);
		[UIDevice log_memory_usage];
	}
}

@end
