#import "MQPublic.h"

/*
 * EXAMPLE
 *
	matrix = [[MQButtonMatrixController alloc] initWithFrame:CGRectMake(0, 20, 320, 460) count:9 named:@"settings.xml"];
	matrix.delegate = self;
	matrix.column = 3;
	matrix.top = 70;
	matrix.left = 10;
	matrix.gap_x = 10;
	matrix.gap_y = 10;

	matrix.images = [[NSArray alloc] initWithObjects:
		@"01.png",
		@"09.png",
		nil];
	matrix.actions = [[NSArray alloc] initWithObjects:
									   @"action_press:",
									   @"action_press:",
		nil];
	[matrix refresh];
 *
 * To support iPad, in
 * 	- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
 * Add
 * 	[UIView begin_animations:0.3];
 * 	[matrix_main refresh];
 * 	[UIView commitAnimations];
 *
 */

@interface MQButtonMatrixController: UIViewController
{
	//	button properties
	id					delegate;
	NSUInteger			count;
	NSUInteger			column;
	CGFloat				top;
	CGFloat				left;
	CGFloat				gap_x;
	CGFloat				gap_y;
	NSString*			animation;
	NSString*			style;
	NSString*			sender_type;

	CGFloat				original_width;
	CGFloat				original_height;

	NSMutableArray*		images;
	NSMutableArray*		images_normal;
	NSMutableArray*		images_highlighted;
	NSMutableArray*		texts;
	NSMutableArray*		actions;

	NSMutableArray*		buttons;
	NSMutableArray*		mapping;

	//UIButton*			current_button;
	CGPoint				current_offset;
	BOOL				is_moving;
	NSInteger			old_index;
	NSInteger			new_index;
	NSString*			filename_setting;
	BOOL				locked;

	BOOL				style_random_color;
}
@property (nonatomic, retain) id				delegate; 
@property (nonatomic, retain) NSString*			animation;
@property (nonatomic, retain) NSString*			style;
@property (nonatomic, retain) NSString*			sender_type;

@property (nonatomic) NSUInteger				count;
@property (nonatomic) NSUInteger				column;
@property (nonatomic) CGFloat					top;
@property (nonatomic) CGFloat					left;
@property (nonatomic) CGFloat					gap_x;
@property (nonatomic) CGFloat					gap_y;
@property (nonatomic, retain) NSMutableArray*	images;
@property (nonatomic, retain) NSMutableArray*	images_normal;
@property (nonatomic, retain) NSMutableArray*	images_highlighted;
@property (nonatomic, retain) NSMutableArray*	texts;
@property (nonatomic, retain) NSMutableArray*	actions;
@property (nonatomic, retain) NSMutableArray*	buttons;		//	should be readonly but it's your choice now
@property (nonatomic) BOOL						locked;
@property (nonatomic) BOOL						style_random_color;

//	- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame count:(NSUInteger)a_count;
- (id)initWithFrame:(CGRect)frame count:(NSUInteger)a_count named:(NSString*)name;
- (void)refresh;
- (void)action_down:(UIButton*)button with_event:(UIEvent*)event;
- (void)action_drag:(UIButton*)button with_event:(UIEvent*)event;
- (void)action_up:(UIButton*)button with_event:(UIEvent*)event;

- (CGRect)get_button_frame:(NSInteger)index;
- (CGRect)get_button_frame_large:(NSInteger)index;
- (void)rearrange_down;
- (void)rearrange_drag;
- (void)rearrange_up;
- (void)animation_begin;
- (void)animation_end;

@end
