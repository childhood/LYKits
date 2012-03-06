#import "LYCategory.h"
#import "LYSingletonClass.h"

/*
 * WARNING: do *NOT* use it as singleton: still under development
 */

@interface LYStateMachine: LYSingletonClass <UIAccelerometerDelegate>
{
	id				delegate;
	NSString*		prefix;
	NSString*		state;
	NSString*		shake_caf;
	int				counter;
	int				shake_counter;
	NSDate*			date;
	UIAcceleration*	acceleration;

	UIAccelerationValue	x;
	UIAccelerationValue	y;
	UIAccelerationValue	z;

	BOOL			debug;
}
@property (nonatomic, retain) id		delegate;
@property (nonatomic, retain) NSString*	prefix;
@property (nonatomic, retain) NSString*	state;
@property (nonatomic, retain) NSString*	shake_caf;
@property (nonatomic, retain) NSDate*	date;
@property (nonatomic) int				counter;
@property (nonatomic) int				shake_counter;
@property (nonatomic) BOOL				debug;

#if 1
+ (LYStateMachine*)shared;
+ (void)start_accelerometer:(CGFloat)interval;
+ (void)stop_accelerometer;
+ (void)resume_accelerometer;
+ (void)set_prefix:(NSString*)a_prefix;
+ (void)set_state:(NSString*)a_state;
+ (NSString*)prefix;
+ (NSString*)state;
+ (int)counter;
#endif

- (void)process_state_machine;
- (void)start_accelerometer:(CGFloat)interval;
- (void)stop_accelerometer;
- (void)resume_accelerometer;
- (void)reset_state_machine;
- (void)reset_state:(NSString*)a_state;
- (void)process_state_machine;
- (NSTimeInterval)time_interval;

@end
