#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MQCategory.h"

/*
 MQPDFViewController* controller = [[MQPDFViewController alloc] init];
 [window addSubview:controller.view];
 */

@interface MQTiledPDFView : UIView
{
	CGPDFPageRef pdfPage;
	CGFloat myScale;
}
- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale;
- (void)setPage:(CGPDFPageRef)newPage;
@end

@interface MQPDFScrollView : UIScrollView <UIScrollViewDelegate>
{
	// The MQTiledPDFView that is currently front most
	MQTiledPDFView *pdfView;
	// The old MQTiledPDFView that we draw on top of when the zooming stops
	MQTiledPDFView *oldPDFView;
	
	// A low res image of the PDF page that is displayed until the MQTiledPDFView
	// renders its content.
	UIImageView *backgroundImageView;

	// current pdf zoom scale
	CGFloat	pdfScale;
	
	CGPDFPageRef page;
	CGPDFDocumentRef pdf;
}
- (NSInteger)load_pdf:(NSString*)a_filename;
- (void)load_page:(int)index;
- (void)unload_pdf;
- (void)unload_page;
- (CGRect)frame_to_center;
@end

@interface MQPDFViewController : UIViewController <UIScrollViewDelegate>
{
	NSString*			filename;
	MQPDFScrollView*	scroll_pdf;
	NSInteger			page_index;
	NSInteger			page_count;
	NSInteger			page_min;
	NSInteger			page_max;
	double				timeout;
	NSDate*				date_last;
	BOOL				loaded;
}
@property (nonatomic) NSInteger	page_index;
@property (nonatomic) NSInteger	page_count;
@property (nonatomic) NSInteger	page_min;
@property (nonatomic) NSInteger	page_max;
@property (nonatomic) double	timeout;
- (void)load_pdf:(NSString*)filename;
- (BOOL)reload_page;
- (BOOL)load_page:(int)index;
- (void)unload_pdf;
- (void)unload_page;
- (BOOL)load_next;
- (BOOL)load_previous;
- (BOOL)test_frequency;
@end

#if 0
#import <mach/mach.h>
#import <mach/mach_host.h>
 
static void print_free_memory () {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);        
 
    vm_statistics_data_t vm_stat;
              
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
 
    /* Stats in bytes */ 
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    NSLog(@"used: %u free: %u total: %u", mem_used, mem_free, mem_total);
}
#endif
