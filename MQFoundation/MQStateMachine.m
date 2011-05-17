#import "MQStateMachine.h"

static MQStateMachine *mq_state_machine_shared_manager = nil;

@implementation MQStateMachine

@synthesize delegate;
@synthesize prefix;
@synthesize state;
@synthesize date;
@synthesize counter;
@synthesize shake_caf;
@synthesize shake_counter;
@synthesize debug;

#if 1
+ (id)shared
{
	@synchronized(self)
	{
		if (mq_state_machine_shared_manager == nil)
			[[self alloc] init];
	}
	return mq_state_machine_shared_manager;
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (mq_state_machine_shared_manager == nil)
		{
			mq_state_machine_shared_manager = [super allocWithZone:zone];
			return mq_state_machine_shared_manager;
		}
	}
	return nil;
}

+ (void)start_accelerometer:(CGFloat)interval
{
	[[UIAccelerometer sharedAccelerometer] setDelegate:[MQStateMachine shared]];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:interval];
}

+ (void)stop_accelerometer
{
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

+ (void)resume_accelerometer
{
	[[UIAccelerometer sharedAccelerometer] setDelegate:[MQStateMachine shared]];
}

+ (void)set_prefix:(NSString*)a_prefix
{
	[[MQStateMachine shared] setPrefix:a_prefix];
}

+ (void)set_state:(NSString*)a_state
{
	[[MQStateMachine shared] setState:a_state];
}

+ (NSString*)prefix
{
	return [[MQStateMachine shared] prefix];
}

+ (NSString*)state
{
	return @"init";
	//return [[MQStateMachine shared] state];
}

+ (int)counter
{
	return [[MQStateMachine shared] counter];
}
#endif

- (id)init
{
	if (self = [super init])
	{
		delegate = [[UIApplication sharedApplication] delegate];
		prefix = @"action_";
		state = @"init";
		shake_caf = nil;
		x = 0;
		y = 0;
		z = 0;
		debug = NO;
		[self reset_state_machine];
	}
	return self;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)an_acceleration
{
	UIAccelerationValue	x1, y1, z1, d;

	x1 = an_acceleration.x;
	y1 = an_acceleration.y;
	z1 = an_acceleration.z;

	d = (x1 - x) * (x1 - x) + (y1 - y) * (y1 - y) + (z1 - z) * (z1 - z);

	if (d > 16)
	{
		//	NSLog(@"SHAKE: %f, %f, %f - %f", x1, y1, z1, d);
		shake_counter++;
		if (shake_caf != nil)
			[shake_caf play_caf];
	}

	x = x1;
	y = y1;
	z = z1;
	[self process_state_machine];
}

- (void)start_accelerometer:(CGFloat)interval
{
	[self reset_state_machine];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:interval];
}

- (void)stop_accelerometer
{
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

- (void)resume_accelerometer
{
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

- (void)reset_state_machine
{
	counter = 0;
	shake_counter = 0;
	date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
}

- (void)reset_state:(NSString*)a_state
{
	[self reset_state_machine];
	state = a_state;
}

- (void)process_state_machine
{
	if (debug == YES)
		NSLog(@"%@:\t%i\tshaked: %i\ttimer: %.01f", state, counter, shake_counter, [self time_interval]);
	counter++;
	[delegate perform_string:[prefix stringByAppendingString:state]];
}

- (NSTimeInterval)time_interval
{
	return [[NSDate date] timeIntervalSinceDate:date];
}

@end
