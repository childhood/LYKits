#import "LYView.h"
#import "LYCategory.h"

@implementation UIView (LYView)

- (UIViewController*)view_controller
{
	id nextResponder = [self nextResponder];
	if ([nextResponder isKindOfClass:[UIViewController class]])
		return nextResponder;
	else
		return nil;
}

- (void)align_horizon_center
{
	CGRect	rect = self.frame;
	self.frame = CGRectMake((screen_width() - rect.size.width) / 2, rect.origin.y, rect.size.width, rect.size.height);
}

- (void)set_position:(CGPoint)point
{
	CGSize	size = self.frame.size;
	self.frame = CGRectMake(point.x, point.y, size.width, size.height);
}

- (UIImage*)snapshot
{
	return [[self get_screenshot:self.bounds] retain];
}

- (UIImage*)get_screenshot:(CGRect)screenRect
{
	//	CGRect screenRect = [[UIScreen mainScreen] bounds];

	//	NSLog(@"size: %@", NSStringFromCGSize(screenRect.size));
	UIGraphicsBeginImageContext(screenRect.size);

	CGContextRef ctx = UIGraphicsGetCurrentContext();
#if 1
	[[UIColor blackColor] set];
	CGContextFillRect(ctx, screenRect);
#endif
	[self.layer renderInContext:ctx];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return newImage;
}

- (void)copy_style:(UIView*)target
{
	if (target.hidden == NO)
	{
		self.frame	= target.frame;
		self.alpha	= target.alpha;
		self.opaque	= target.opaque;
		self.layer.opaque		= target.layer.opaque;
		self.autoresizingMask	= target.autoresizingMask;
		self.backgroundColor	= target.backgroundColor;
	}
}

- (void)set_text:(NSString*)text interval:(int)interval block:(LYBlockBoolString)callback
{
	[NSThread detachNewThreadSelector:@selector(set_text_animated_loop:) 
							 toTarget:self 
						   withObject:[NSArray arrayWithObjects:text, [NSNumber numberWithInteger:interval], callback, nil]];
#if 0
	[self performSelector:@selector(set_text_animated_loop:) 
			   withObject:[NSArray arrayWithObjects:text, [NSNumber numberWithInteger:interval], callback, nil] 
			   afterDelay:0];	//(float)interval / 1000000];
#endif
}

- (void)set_text_animated_loop:(NSArray*)array
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString* text	= [array i:0];
	int interval	= [[array i:1] intValue];
	LYBlockBoolString block = nil;
	if (array.count > 2)
		block = [array i:2];
	for (int i = 1; i <= text.length; i++)
	{
		NSString* s = [text substringToIndex:i];
		//[self perform_string:@"setText:" with:s];
		//[self performSelector:@selector(setText:) withObject:s afterDelay:0];
		[self performSelectorOnMainThread:@selector(setText:) withObject:s waitUntilDone:NO];
		usleep(interval);
		if (block != nil)
		{
			if (block(s) == NO)
				break;
			if ([self is_displayed] == NO)
				break;
		}
	}
	[pool release];
}

+ (void)begin_animations:(CGFloat)duration
{
	[self beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
}

- (void)move_vertically:(CGFloat)value animated:(BOOL)animated
{
	CGRect rect = self.frame;

	if (animated == YES)
		[UIView begin_animations:0.3];
	self.frame = CGRectMake(rect.origin.x, rect.origin.y + value, rect.size.width, rect.size.height);
	if (animated == YES)
		[UIView commitAnimations];
}

- (void)move_horizontally:(CGFloat)value animated:(BOOL)animated
{
	CGRect rect = self.frame;

	if (animated == YES)
		[UIView begin_animations:0.3];
	self.frame = CGRectMake(rect.origin.x + value, rect.origin.y, rect.size.width, rect.size.height);
	if (animated == YES)
		[UIView commitAnimations];
}

- (void)reset_x:(CGFloat)x animation:(CGFloat)duration
{
	[UIView begin_animations:duration];
	[self reset_x:x];
	[UIView commitAnimations];
}

- (void)reset_y:(CGFloat)y animation:(CGFloat)duration
{
	[UIView begin_animations:duration];
	[self reset_y:y];
	[UIView commitAnimations];
}

- (void)set_x:(CGFloat)x animation:(CGFloat)duration
{
	[UIView begin_animations:duration];
	[self set_x:x];
	[UIView commitAnimations];
}

- (void)set_y:(CGFloat)y animation:(CGFloat)duration
{
	[UIView begin_animations:duration];
	[self set_y:y];
	[UIView commitAnimations];
}

- (void)set_w:(CGFloat)w animation:(CGFloat)duration
{
	[UIView begin_animations:duration];
	[self set_w:w];
	[UIView commitAnimations];
}

- (void)set_h:(CGFloat)h animation:(CGFloat)duration
{
	[UIView begin_animations:duration];
	[self set_h:h];
	[UIView commitAnimations];
}

- (void)autoresizing_add_width:(BOOL)w height:(BOOL)h
{
	if (w == YES)
		self.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
	if (h == YES)
		self.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
}

- (void)remove_subviews
{
	[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)release_subviews
{
	for (UIView* view in self.subviews)
	{
		[view removeFromSuperview];
		[view release];
	}
}

- (void)set_x:(CGFloat)f
{
	CGRect r = self.frame;
	self.frame = CGRectMake(f, r.origin.y, r.size.width, r.size.height);
}

- (void)set_y:(CGFloat)f
{
	CGRect r = self.frame;
	self.frame = CGRectMake(r.origin.x, f, r.size.width, r.size.height);
}

- (void)set_w:(CGFloat)f
{
	[self set_width:f];
}

- (void)set_h:(CGFloat)f
{
	[self set_height:f];
}

- (void)set_width:(CGFloat)f
{
	CGRect r = self.frame;
	self.frame = CGRectMake(r.origin.x, r.origin.y, f, r.size.height);
}

- (void)set_height:(CGFloat)f
{
	CGRect r = self.frame;
	self.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, f);
}

- (void)reset_x:(CGFloat)f
{
	CGRect r = self.frame;
	self.frame = CGRectMake(r.origin.x + f, r.origin.y, r.size.width, r.size.height);
}

- (void)reset_y:(CGFloat)f
{
	CGRect r = self.frame;
	self.frame = CGRectMake(r.origin.x, r.origin.y + f, r.size.width, r.size.height);
}

- (void)reset_width:(CGFloat)f
{
	CGRect r = self.frame;
	self.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width + f, r.size.height);
}

- (void)reset_height:(CGFloat)f
{
	CGRect r = self.frame;
	self.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height + f);
}

- (void)swap_width_height
{
	CGRect r = self.frame;
	self.frame = CGRectMake(r.origin.x, r.origin.y, r.size.height, r.size.width);
}

- (void)autoresizing_flexible_left:(BOOL)l right:(BOOL)r top:(BOOL)t bottom:(BOOL)b
{
	if (l == YES)
		self.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin;
	if (r == YES)
		self.autoresizingMask |= UIViewAutoresizingFlexibleRightMargin;
	if (t == YES)
		self.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
	if (b == YES)
		self.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
}

- (void)debug_print_subviews:(BOOL)flag_seperator
{
	NSArray*	array = self.subviews;
	UIView*		view;
	static NSInteger	indent;
	NSInteger	i;
	NSString*	s = [NSString stringWithFormat:@"%@", self];

	if (flag_seperator == YES)
	{
		for (i = 0; i < indent; i++)
			printf("\t");
		printf("DEBUG began --------\n");
	}

	for (i = 0; i < indent; i++)
		printf("\t");
	printf("DEBUG subviews %i: %s\n", array.count, [s cStringUsingEncoding:NSUTF8StringEncoding]);
	for (view in array)
	{
		indent++;
		[view debug_print_subviews:flag_seperator];
		indent--;
	}

	if (flag_seperator == YES)
	{
		for (i = 0; i < indent; i++)
			printf("\t");
		printf("DEBUG ended --------\n");
	}
}

- (NSMutableArray*)all_subviews
{
	NSMutableArray* ret = [NSMutableArray array];
	[ret addObjectsFromArray:self.subviews];
	for (UIView* view in self.subviews)
	{
		NSArray*	array;
		array = [view all_subviews];
		[ret addObjectsFromArray:array];
	}
	return ret;
}

- (BOOL)is_displayed
{
	UIWindow*	window = [[[UIApplication sharedApplication] windows] i:0];
	NSArray*	array = [window all_subviews];
	return [array containsObject:self];
}

@end

#if 0
@implementation UINavigationController (LYViewController)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	//	NSLog(@"should rotate from: %i", interfaceOrientation);
	return YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	//	NSLog(@"rotated from: %i", fromInterfaceOrientation);
	//if ([delegate respondsToSelector:@selector(did_rotate_from:)])
	//	[delegate did_rotate_from:fromInterfaceOrientation];
}
@end
#endif
