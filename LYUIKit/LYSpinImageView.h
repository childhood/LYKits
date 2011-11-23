#import "LYKits.h"
#import <unistd.h>

@interface LYSpinImageView: UIImageView
{
	NSMutableArray*	image_names;
	CGPoint		location_begin;
	NSInteger	index;
	NSInteger	setting_pixel_per_frame;		//	move how many pixels to change frame
	NSDate*		date_last;
	NSThread*	thread_animation;
	CGFloat		speed_last;

	CGFloat		factor_sensitivity;
	NSInteger	factor_sleep;
	CGFloat		factor_duration;
	CGFloat		factor_time;
}
@property (nonatomic, retain) NSMutableArray*	image_names;
@property (nonatomic) CGFloat	factor_sensitivity;
@property (nonatomic) NSInteger	factor_sleep;
@property (nonatomic) CGFloat	factor_duration;
@property (nonatomic) CGFloat	factor_time;

- (void)set_name_format:(NSString*)format from:(NSInteger)head to:(NSInteger)tail;
- (void)refresh;
- (void)spin:(CGFloat)factor;
- (void)apply_default_factors;

@end



