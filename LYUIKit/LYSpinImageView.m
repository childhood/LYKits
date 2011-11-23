#import "LYSpinImageView.h"


@implementation LYSpinImageView

@synthesize image_names;
@synthesize factor_sensitivity;
@synthesize factor_sleep;
@synthesize factor_duration;
@synthesize factor_time;

- (void)set_name_format:(NSString*)format from:(NSInteger)head to:(NSInteger)tail
{
	int i;
	NSString* s;

	if (image_names == nil)
		image_names = [[NSMutableArray alloc] init];
	if (self.animationImages != nil)
		[self.animationImages release];		//	TODO: release each image?

	NSMutableArray*	array;
	array = [NSMutableArray arrayWithObjects:nil];
	for (i = head; i <= tail; i++)
	{
		s = [NSString stringWithFormat:format, i];
		[image_names addObject:s];
		[array addObject:[[UIImage alloc] initWithContentsOfFile:[s filename_bundle]]];
	}
	self.animationImages = array;
	self.animationDuration = 0;
	[self stopAnimating];
	//	NSLog(@"SWIPE names: %@", image_names);
	index = 0;
	[self refresh];

	thread_animation = nil;
}

- (void)refresh
{
	self.image = [self.animationImages objectAtIndex:index];
#if 0
	NSString* filename = [image_names objectAtIndex:index];
	//	NSLog(@"loading image: %@", filename);
	if (self.image != nil)
		[self.image release];
	self.image = [[UIImage alloc] initWithContentsOfFile:[filename filename_bundle]];
#endif
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	location_begin = [touch locationInView:self];
	//	NSLog(@"SWIPE touch began: %@", event);
	date_last = [[NSDate date] retain];
	//	[self startAnimating];
	if (thread_animation != nil)
	{
		NSLog(@"stop animation");
		[thread_animation cancel];
		[thread_animation release];
	}
	speed_last = 0;
}

- (NSTimeInterval)update_interval
{
	NSTimeInterval	interval = [date_last timeIntervalSinceNow];

	[date_last release];
	date_last = [[NSDate date] retain];

	return interval;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch*	touch = [[event allTouches] anyObject];
	CGPoint location_new = [touch locationInView:self];
	//CGPoint location_old = [touch previousLocationInView:self];
	//CGFloat		diff = location_new.x - location_old.x;
	CGFloat		diff = location_new.x - location_begin.x;
	CGFloat		step = 2.0 * self.frame.size.width / (CGFloat)image_names.count * factor_sensitivity;

	//NSLog(@"step: %f", step);
#if 1
	int new_index = index;
	//	NSLog(@"diff: %f", diff);
	if (diff > step)
		new_index -= diff / step;
	if (diff < -step)
		new_index -= diff / step;
	while (new_index >= (int)image_names.count)
	{
		new_index -= image_names.count;
	}
	while (new_index < 0)
	{
		new_index += image_names.count;
	}
	
	if (index != new_index)
	{
		index = new_index;
		[self refresh];
		location_begin = location_new;
		speed_last = diff / [self update_interval] * 0.5 + speed_last * 0.5;
		NSLog(@"speed: %f", speed_last);
		//	NSLog(@"index: %i", index);
	}
	//	NSLog(@"id: %i from %@ to %@", (int)self, NSPointToString(location_old), NSPointToString(location_new));
	//	NSLog(@"SWIPE touch moved: %@", event);
#endif
#if 0
	int diff_index;
	self.animationDuration = diff / interval;
	NSLog(@"diff: %f, interval: %f, duration: %f", diff, interval, self.animationDuration);
	if (self.animationDuration != 0)	
		[self startAnimating];
#endif
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location_new = [touch locationInView:self];
	CGPoint location_old = [touch previousLocationInView:self];
	CGFloat interval = [self update_interval];
	int diff = location_new.x - location_old.x;

	//	NSLog(@"id: %i from %@ to %@", (int)self, NSPointToString(location_begin), NSPointToString(location_new));
	//	NSLog(@"id: %i from %@ to %@", (int)self, NSPointToString(location_old), NSPointToString(location_new));
	//	NSLog(@"diff: %i", diff);
	speed_last = diff / interval * 0.5 + speed_last * 0.5;
		NSLog(@"speed: %f, interval %f", speed_last, interval);
	//	thread_animation = [[NSThread alloc] initWithTarget:self selector:@selector(refresh_more:) object:[NSNumber numberWithInteger:diff * 2]];
	[self spin:speed_last * factor_time / -interval];
	//	thread_animation = [[NSThread alloc] initWithTarget:self selector:@selector(refresh_more:) object:[NSNumber numberWithFloat:speed_last * 0.01 / -interval]];
	//	[thread_animation start];
	//	NSLog(@"SWIPE touch ended: %@", event);
	//	[self stopAnimating];
}

- (void)spin:(CGFloat)factor
{
	thread_animation = [[NSThread alloc] initWithTarget:self selector:@selector(refresh_more:) object:[NSNumber numberWithFloat:factor]];
	[thread_animation start];
}

- (void)refresh_more:(NSNumber*)number
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int i, count, direction;
#if 0
	i = [number intValue];
	if (i > 0)
	{
		count = i;
		direction = -1;
	}
	else
	{
		count = -i;
		direction = 1;
	}
#endif
#if 1
	CGFloat f = [number floatValue];
	NSLog(@"refresh factor: %f", f);
	if (f > 0)
	{
		count = f / factor_duration;
		direction = 1;
	}
	else
	{
		count = -f / factor_duration;
		direction = -1;
	}
#endif

	for (i = 0; i < count; i++)
	{
		index += direction;
		if (index < 0)
			index = image_names.count - 1;
		if (index >= image_names.count)
			index = 0;
		//	[self refresh];
		[self performSelectorOnMainThread:@selector(refresh_delay) withObject:nil waitUntilDone:YES];
		usleep(i * factor_sleep);
		if (thread_animation.isCancelled)
			break;
	}
	
	[pool release];
	thread_animation = nil;
}

- (void)apply_default_factors
{
	factor_sleep = 1000;
	factor_duration = 10.0;
	factor_time = 0.01;
	factor_sensitivity = 1.0;
}

- (void)refresh_delay
{
	//	NSLog(@"refreshing %i", index);
	[self refresh];
	//	usleep(50);
}

@end
