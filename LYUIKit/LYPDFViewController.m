#import "LYPDFViewController.h"


@implementation LYTiledPDFView

// Create a new LYTiledPDFView with the desired frame and scale.
- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale{
    if ((self = [super initWithFrame:frame])) {
		//	if (is_interface_landscape())
		//		[self swap_width_height];
		//	[self autoresizing_add_width:NO height:NO];

		CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
		// levelsOfDetail and levelsOfDetailBias determine how
		// the layer is rendered at different zoom levels.  This
		// only matters while the view is zooming, since once the 
		// the view is done zooming a new LYTiledPDFView is created
		// at the correct size and scale.
        tiledLayer.levelsOfDetail = 4;
		tiledLayer.levelsOfDetailBias = 4;
		tiledLayer.tileSize = CGSizeMake(512.0, 512.0);
		
		myScale = scale;
    }
    return self;
}

// Set the layer's class to be CATiledLayer.
+ (Class)layerClass {
	return [CATiledLayer class];
}

// Set the CGPDFPageRef for the view.
- (void)setPage:(CGPDFPageRef)newPage
{
    CGPDFPageRelease(self->pdfPage);
    self->pdfPage = CGPDFPageRetain(newPage);
}

-(void)drawRect:(CGRect)r
{
    // UIView uses the existence of -drawRect: to determine if it should allow its CALayer
    // to be invalidated, which would then lead to the layer creating a backing store and
    // -drawLayer:inContext: being called.
    // By implementing an empty -drawRect: method, we allow UIKit to continue to implement
    // this logic, while doing our real drawing work inside of -drawLayer:inContext:
}

// Draw the CGPDFPageRef into the layer at the correct scale.
-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
	//	NSLog(@"draw layer began");
	// First fill the background with white.
	CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context,self.bounds);
	
	CGContextSaveGState(context);
	// Flip the context so that the PDF page is rendered
	// right side up.
	CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
	//CGContextTranslateCTM(context, 0.0, -5);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	// Scale the context so that the PDF page is rendered 
	// at the correct size for the zoom level.
	CGContextScaleCTM(context, myScale,myScale);	
	CGContextDrawPDFPage(context, pdfPage);
	CGContextRestoreGState(context);
	//	NSLog(@"draw layer ended");
}

// Clean up.
- (void)dealloc {
	CGPDFPageRelease(pdfPage);
	
    [super dealloc];
}

@end


@implementation LYPDFScrollView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
		//	if (is_interface_landscape())
		//		[self swap_width_height];
		//	[self autoresizing_add_width:NO height:NO];
		
		// Set up the UIScrollView
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		//[self setBackgroundColor:[UIColor blueColor]];
		[self setBackgroundColor:[UIColor whiteColor]];
		//self.maximumZoomScale = 1.5;
		//self.minimumZoomScale = 1;
		self.maximumZoomScale = 5.0;
		self.minimumZoomScale = 0.25;
    }
    return self;
}

- (NSInteger)load_pdf:(NSString*)filename
{
	// Open the PDF document
	//NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
	NSURL *pdfURL = [NSURL fileURLWithPath:filename];

	//	NSLog(@"url from %@: %@", filename, pdfURL);
	pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
	return CGPDFDocumentGetNumberOfPages(pdf);
}

- (void)load_page:(int)index
{		
	// Get the PDF Page that we will be drawing
	page = CGPDFDocumentGetPage(pdf, index);
	CGPDFPageRetain(page);
	
	// determine the size of the PDF page
	CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
	pdfScale = self.frame.size.width/pageRect.size.width;
	if (YES)
	//if (is_interface_portrait())
		pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
	else
		pageRect.size = CGSizeMake(pageRect.size.height*pdfScale, pageRect.size.width*pdfScale);
	
	// Create a low res image representation of the PDF page to display before the LYTiledPDFView
	// renders its content.
	UIGraphicsBeginImageContext(pageRect.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// First fill the background with white.
	CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
	CGContextFillRect(context,pageRect);
	
	CGContextSaveGState(context);
	// Flip the context so that the PDF page is rendered
	// right side up.
	CGContextTranslateCTM(context, 0.0, pageRect.size.height);
	//CGContextTranslateCTM(context, 0.0, -5);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	// Scale the context so that the PDF page is rendered 
	// at the correct size for the zoom level.
	CGContextScaleCTM(context, pdfScale,pdfScale);	
	CGContextDrawPDFPage(context, page);
	CGContextRestoreGState(context);
	
	UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
	NSLog(@"DEBUG background iamge view: %@", backgroundImageView);
	backgroundImageView.frame = pageRect;
	//[backgroundImageView set_y:100];
	//backgroundImageView.frame = [self frame_to_center];
	//NSLog(@"background image: %@", backgroundImageView);
	backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:backgroundImageView];
	[self sendSubviewToBack:backgroundImageView];
	
	// Create the LYTiledPDFView based on the size of the PDF page and scale it to fit the view.
	pdfView = [[LYTiledPDFView alloc] initWithFrame:pageRect andScale:pdfScale];

	[pdfView setPage:page];

	[self addSubview:pdfView];
}

- (void)unload_page
{
    [pdfView release];
	[backgroundImageView release];
	CGPDFPageRelease(page);
}

- (void)unload_pdf
{
	CGPDFDocumentRelease(pdf);
}

- (void)dealloc
{
	// Clean up
    [super dealloc];
}

#pragma mark -
#pragma mark Override layoutSubviews to center content

// We use layoutSubviews to center the PDF page in the view
- (void)layoutSubviews 
{
    [super layoutSubviews];
   
#if 1
    pdfView.frame = [self frame_to_center];
	backgroundImageView.frame = [self frame_to_center];
	//	NSLog(@"background image (layout): %@", backgroundImageView);
#endif
    
	// to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
	// tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
	// which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
	pdfView.contentScaleFactor = 1.0;
}

- (CGRect)frame_to_center
{
	//	return CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    // center the image as it becomes smaller than the size of the screen
	
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = pdfView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;

	frameToCenter.origin.y = 0;		//	cache animation fix
	return frameToCenter;
}

#pragma mark -
#pragma mark UIScrollView delegate methods

// A UIScrollView delegate callback, called when the user starts zooming. 
// We return our current LYTiledPDFView.
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return pdfView;
}

// A UIScrollView delegate callback, called when the user stops zooming.  When the user stops zooming
// we create a new LYTiledPDFView based on the new zoom level and draw it on top of the old LYTiledPDFView.
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);

	// set the new scale factor for the LYTiledPDFView
	pdfScale *=scale;
#if 0
	if (pdfScale < self.frame.size.width/pageRect.size.width)
	{
		pdfScale = self.frame.size.width/pageRect.size.width;
		//	self.minimumZoomScale = 1;
	}
	//	else
	//		self.minimumZoomScale = 0.25;
#endif
	
	// Calculate the new frame for the new LYTiledPDFView
	if (YES)
	//if (is_interface_portrait())
		pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
	else
		pageRect.size = CGSizeMake(pageRect.size.height*pdfScale, pageRect.size.width*pdfScale);
	
	// Create a new LYTiledPDFView based on new frame and scaling.
	pdfView = [[LYTiledPDFView alloc] initWithFrame:pageRect andScale:pdfScale];
	[pdfView setPage:page];
	
	// Add the new LYTiledPDFView to the LYPDFScrollView.
	[self addSubview:pdfView];

	//	NSLog(@"scale: %f", pdfScale);
	[UIDevice log_memory_usage];
}

// A UIScrollView delegate callback, called when the user begins zooming.  When the user begins zooming
// we remove the old LYTiledPDFView and set the current LYTiledPDFView to be the old view so we can create a
// a new LYTiledPDFView when the zooming ends.
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
	// Remove back tiled view.
	[oldPDFView removeFromSuperview];
	[oldPDFView release];
	
	// Set the current LYTiledPDFView to be the old view.
	oldPDFView = pdfView;
	[self addSubview:oldPDFView];

	CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
	if (pdfScale <= self.frame.size.width/pageRect.size.width)
	{
		return;
	}
}

@end


@implementation LYPDFViewController

@synthesize page_index;
@synthesize page_count;
@synthesize page_min;
@synthesize page_max;
@synthesize timeout;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (id)init
{
	self = [super init];
	if (self != nil)
	{
		page_index	= 0;
		page_count	= 0;
		page_min	= 0;
		page_max	= 0;
		timeout		= 0;
		date_last	= [[NSDate alloc] init];
		loaded		= NO;
		//	if (is_interface_landscape())
		//		[self.view swap_width_height];
		[self.view autoresizing_add_width:NO height:NO];
	}
	return self;
}

- (void)loadView {
	[super loadView];
	
	// Create our LYPDFScrollView and add it to the view controller.
	//	scroll_pdf = [[LYPDFScrollView alloc] initWithFrame:[[self view] bounds]];
    //	[[self view] addSubview:scroll_pdf];
	//	[scroll_pdf release];
}

- (void)load_pdf:(NSString*)a_filename
{
	filename = [a_filename retain];
	scroll_pdf = [[LYPDFScrollView alloc] initWithFrame:[[self view] bounds]];
	page_count = [scroll_pdf load_pdf:filename];
	if (page_index < 1)
		page_index = 1;
	if (page_min == 0)
		page_min = 1;
	if (page_max == 0)
		page_max = page_count;
    [[self view] addSubview:scroll_pdf];
	//	NSLog(@"PDF page count: %i/%i", page_index, page_count);
	[UIDevice log_memory_usage];
}

- (BOOL)load_next
{
	if (page_index == page_max)
		return NO;
	else
		page_index++;
	return [self load_page:page_index];
}

- (BOOL)load_previous
{
	if (page_index == page_min)
		return NO;
	else
		page_index--;
	return [self load_page:page_index];
}

- (BOOL)test_frequency
{
	if ((-[date_last timeIntervalSinceNow] < timeout) && (loaded == YES))
	{
		return NO;
	}
	return YES;
}

- (BOOL)reload_page
{
	return [self load_page:page_index];
}

- (BOOL)load_page:(int)index
{
	if ([self test_frequency] == NO)
	{
		NSLog(@"PDF refresh too frequent: %f", [date_last timeIntervalSinceNow]);
		return NO;
	}

	//	NSLog(@"PDF load page: %i", index);
	loaded = YES;
	[date_last release];
	date_last	= [[NSDate alloc] init];

	//	NSLog(@"load page: %@", filename);
#if 1
	[self unload_page];
	[self unload_pdf];
	[self load_pdf:filename];
#endif
#if 0
	if (page_index < 1)
		page_index = 1;
	else if (page_index > page_count)
		page_index = page_count;
	else
		page_index = index;
#endif
	page_index = index;
	[scroll_pdf load_page:page_index];

	return YES;
}

- (void)unload_page
{
	[scroll_pdf unload_page];
	//page_index = 0;
	page_count = 0;
}

- (void)unload_pdf
{
	//[filename release];
	[scroll_pdf removeFromSuperview];
	[scroll_pdf unload_pdf];
	[scroll_pdf release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[self unload_page];
	[self unload_pdf];
    [super dealloc];
}

@end
