#import "MQButtonMatrixController.h"

@implementation MQButtonMatrixController: UIViewController

@synthesize delegate;
@synthesize animation;
@synthesize style;
@synthesize sender_type;

@synthesize count;
@synthesize column;
@synthesize top;
@synthesize left;
@synthesize gap_x;
@synthesize gap_y;

@synthesize texts;
@synthesize images;
@synthesize images_normal;
@synthesize images_highlighted;
@synthesize actions;
@synthesize buttons;

@synthesize locked;
@synthesize style_random_color;

- (id)initWithFrame:(CGRect)frame count:(NSUInteger)a_count
{
	return [self initWithFrame:frame count:a_count named:nil];
}

- (id)initWithFrame:(CGRect)frame count:(NSUInteger)a_count named:(NSString*)name
{
	int i;
	UIButton*	button;

	self = [super init];

	if (self != nil)
	{
		self.view.frame	= frame;
		is_moving		= NO;
		animation		= @"";
		style			= @"swap";
		sender_type		= @"title";		//	title / index / button / nil
		//	current_button	= nil;
		locked			= NO;

		style_random_color = NO;

		//	self.view.backgroundColor	= [UIColor yellowColor];
		//self.view.autoresizingMask	= UIViewAutoresizingNone;	
		//self.view.autoresizingMask	= UIViewAutoresizingFlexibleLeftMargin || UIViewAutoresizingFlexibleTopMargin;
		//self.view.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		[self.view autoresizing_flexible_left:YES right:YES top:YES bottom:YES];
		[self.view autoresizing_add_width:YES height:YES];

		original_width	= frame.size.width;
		original_height	= frame.size.height;

		count	= a_count;
		column	= 1;
		top		= 0;
		left	= 0;
		gap_x	= 0;
		gap_y	= 0;

		buttons	= [[NSMutableArray alloc] init];
		mapping = nil;
		if (name != nil)
			if ([name file_exists])
				mapping = [[NSMutableArray alloc] initWithContentsOfFile:[name filename_document]];
		if (mapping == nil)
			mapping	= [[NSMutableArray alloc] init];
		filename_setting = name;

		for (i = 0; i < count; i++)
		{
			button = [[UIButton alloc] init];
			button.exclusiveTouch = YES;
			if (is_phone())
				button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
			else
				button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
			[button setTitleColor:[UIColor colorWithRed:113.0f/255.0f-0.05f green:120.0f/255.0f-0.05f blue:128.0f/255.0f-0.05f alpha:1] forState:UIControlStateNormal];
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
			[button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
			[button addTarget:self action:@selector(action_down:with_event:) forControlEvents:UIControlEventTouchDown];
			[button addTarget:self action:@selector(action_drag:with_event:) forControlEvents:UIControlEventTouchDragInside];
			[button addTarget:self action:@selector(action_up:with_event:) forControlEvents:UIControlEventTouchUpInside];

			[button autoresizing_flexible_left:YES right:YES top:YES bottom:YES];
			[button autoresizing_add_width:YES height:YES];

			[buttons addObject:button];
			[self.view addSubview:button];
			
			[mapping addObject:[NSNumber numberWithInteger:i]];
		}
		[self refresh];
	}

	return self;
}

#if 0
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSLog(@"rotated");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	NSLog(@"should rotate");
	return YES;
}
#endif

- (void)dealloc
{
	int i;

	for (i = 0; i < count; i++)
	{
		[[buttons objectAtIndex:i] removeFromSuperview];
		[[buttons objectAtIndex:i] release];
	}
	[buttons release];
	[mapping release];
	[super dealloc];
}

- (CGRect)get_button_frame:(NSInteger)index
{
	int	row			= ceil((double)count / (double)column);
	CGFloat	width	= self.view.frame.size.width;
	CGFloat	height	= self.view.frame.size.height;
	CGFloat	button_width	= (width - left * 2 - gap_x * (column - 1)) / column;
	CGFloat	button_height	= (height - top * 2 - gap_y * (row - 1)) / row;
	CGFloat	button_x;
	CGFloat	button_y;
	CGFloat	pos_x;
	CGFloat	pos_y;
	

#if 0
	//button_width	*= width / original_width;
	//button_height	*= height / original_height;
	button_x		*= width / original_width;
	button_y		*= height / original_height;
	pos_x			*= width / original_width;
	pos_y			*= height / original_height;
#endif

	//	NSLog(@"width & height: %f / %f", width, height);
	pos_x = index % column;
	pos_y = floor(index / column);
	button_x = left + pos_x * button_width + pos_x * gap_x;
	button_y = top + pos_y * button_height + pos_y * gap_y;
	//	NSLog(@"button %i: %f, %f - size %f, %f", index, button_x, button_y, button_width, button_height);
	//NSLog(@"home button size:  %@",NSStringFromCGRect(button.frame));
	return CGRectMake(button_x, button_y, button_width, button_height);
}

//	for icon movement detection
- (CGRect)get_button_frame_large:(NSInteger)index
{
	CGRect ret = [self get_button_frame:index];
	return CGRectMake(ret.origin.x - gap_x / 2, ret.origin.y - gap_y / 2, ret.size.width + gap_x, ret.size.height + gap_y);
}

- (int)get_index_from_point:(CGPoint)point
{
	int		i;
	CGRect	rect;

	for (i = 0; i < count; i++)
	{
		rect = [self get_button_frame_large:i];
		//	NSLog(@"%@ in %@?", NSStringFromCGPoint(point), NSStringFromCGRect(rect));
		if (CGPointInRect(point, rect))
			return i;
	}

	return -1;
}

- (int)get_button_index:(UIButton*)button
{
	int i;	

	for (i = 0; i < count; i++)
		if ([buttons objectAtIndex:i] == button)
			return i;

	return -1;
}

- (void)refresh
{
	int	i, index;
	UIButton*	button;
	NSString*	image;
	NSString*	image_normal;
	NSString*	image_highlighted;
	NSString*	text;

	for (i = 0; i < count; i++)
	{
		index	= [[mapping objectAtIndex:i] integerValue];

		//	get button properties
		text	= [texts object_at_index:index];
		image	= [images object_at_index:index];
		if (image == nil)
			image = [images object_at_index:0];
		image_normal		= [images_normal object_at_index:index];
		image_highlighted	= [images_highlighted object_at_index:index];

		//	reset button
		button	= [buttons objectAtIndex:index];
		button.frame = [self get_button_frame:i];
		if (text != nil)
			[button set_title:text];
		//	[button set_background_named:image];
		if (image != nil)
		{
			if ([image isEqualToString:@""] == NO)
			{
				[button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
			}
		}
#if 1
		if (image_normal != nil)
			[button setImage:[UIImage imageNamed:image_normal] forState:UIControlStateNormal];
		if (image_highlighted != nil)
			[button setImage:[UIImage imageNamed:image_highlighted] forState:UIControlStateHighlighted];
#endif
		//[button autoresizing_add_width:NO height:NO];
		//NSLog(@"button: %@", button);
		//button.autoresizingMask = UIViewAutoresizingNone;
		//button.autoresizingMask = UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight;
		//button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin || UIViewAutoresizingFlexibleTopMargin;

		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		button.titleLabel.textAlignment = UITextAlignmentCenter;
		button.titleLabel.numberOfLines = 0;
		if (style_random_color)
		{
			//NSLog(@"color key: %@", text);
			//button.backgroundColor = [MQRandom bright_color_for_key:text];
			button.backgroundColor = [MQRandom bright_color];
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
			//[button setTitleColor:[MQRandom dark_color] forState:UIControlStateNormal];
			[button setTitleColor:[button.backgroundColor invert] forState:UIControlStateNormal];
		}

		//	NSLog(@"set button %i: %i - %@\n%@", i, index, text, button);
	}
}

#pragma mark actions

- (void)action_down:(UIButton*)button with_event:(UIEvent*)event
{
	CGPoint location = [[[event allTouches] anyObject] locationInView:self.view];

	if (locked == YES)
		return;

	current_offset = [[[event allTouches] anyObject] locationInView:button];
	old_index = [self get_index_from_point:location];
	
	[self rearrange_down];
	[self.view bringSubviewToFront:button];

	//	NSLog(@"button down: %@", NSStringFromCGPoint(current_offset));
}

- (void)action_drag:(UIButton*)button with_event:(UIEvent*)event
{
	CGPoint location = [[[event allTouches] anyObject] locationInView:self.view];

	if (locked == YES)
		return;

	new_index = [self get_index_from_point:location];

	if (is_moving == NO)
	{
		is_moving = YES;
		if ([animation isEqualToString:@"wiggle"])
			[self animation_begin];
	}

	[self rearrange_drag];
	[self.view bringSubviewToFront:button];
	button.frame = CGRectMake(location.x - current_offset.x, location.y - current_offset.y, button.frame.size.width, button.frame.size.height);
}

- (void)action_up:(UIButton*)button with_event:(UIEvent*)event
{
	NSString*	action;
	CGPoint location = [[[event allTouches] anyObject] locationInView:self.view];
	//	int new_index;

	if (is_moving == YES)
	{
		if ([animation isEqualToString:@"wiggle"])
			[self animation_end];
		is_moving = NO;

		new_index = [self get_index_from_point:location];

		[self rearrange_up];

		[UIView begin_animations:0.3];
		[self refresh];
		[UIView commitAnimations];

		if (filename_setting != nil)
		{
			//	NSLog(@"MATRIX saving settings: %@", filename_setting);
			[mapping writeToFile:[filename_setting filename_document] atomically:YES];
		}
	}
	else
	{
		new_index = [self get_button_index:button];
		action = [actions object_at_index:new_index];
		if (action == nil)
			action = [actions object_at_index:0];

		if ([sender_type isEqualToString:@"title"])
			[delegate perform_string:action with:[button titleForState:UIControlStateNormal]];
		else if ([sender_type isEqualToString:@"index"])
			[delegate perform_string:action with:[NSNumber numberWithInteger:new_index]];
		else if ([sender_type isEqualToString:@"button"])
			[delegate perform_string:action with:button];
		else
			[delegate perform_string:action];

		//	if ([delegate respondsToSelector:NSSelectorFromString([actions objectAtIndex:new_index])])
		//		[delegate performSelector:NSSelectorFromString([actions objectAtIndex:new_index]) withObject:[NSNumber numberWithInteger:new_index]];
		//	NSLog(@"button pressed: %@", button);
	}
}

#pragma mark rearrange icon position

- (void)rearrange_down
{
}

- (void)rearrange_drag
{
}

- (void)rearrange_up
{
	if (new_index >= 0)
	{
		[mapping exchangeObjectAtIndex:old_index withObjectAtIndex:new_index];
		[self.view bringSubviewToFront:[buttons objectAtIndex:old_index]];
		[self.view bringSubviewToFront:[buttons objectAtIndex:new_index]];
	}
}

#pragma mark animation

- (void)animation_begin
{
	int			i;
	UIButton*	the_button;
	//	i = old_index;
	for (i = 0; i < count; i++)
	{
		the_button = [buttons objectAtIndex:i];
		CABasicAnimation *wiggle = [CABasicAnimation animationWithKeyPath:@"transform"];
		wiggle.duration = 0.1;
		wiggle.repeatCount = 1e100f;
		wiggle.autoreverses = YES;
		wiggle.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(the_button.layer.transform, 0.1, 0.0 ,1.0 ,2.0)];

		// doing the wiggle
		[the_button.layer addAnimation:wiggle forKey:@"wiggle"];
	}
}

- (void)animation_end
{
	int			i;
	UIButton*	the_button;
	//	i = old_index;
	for (i = 0; i < count; i++)
	{
		the_button = [buttons objectAtIndex:i];
		[the_button.layer removeAllAnimations];
	}
}

@end
