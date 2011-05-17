#import "MQKeyboardMatrixController.h"

#define k_filename_settings		@".settings_keyboard_ime.xml"

@implementation MQKeyboardMatrixController

@synthesize string;
@synthesize target;
@synthesize setter;
@synthesize getter;
@synthesize button_ime;

- (id)initWithDelegate:(id)obj
{
	self = [super init];
	if (self != nil)
	{
		delegate = obj;
		if (is_phone())
		{
			matrix_width = 160;
			matrix_height = 200;
			matrix_resize = 10;
		}
		else
		{
			matrix_width = 280;
			matrix_height = 280;
			matrix_resize = 20;
		}
		string = @"";
		hidden = YES;
		setter = @"setText:";
		getter = @"text";
		ime_is_moving = NO;

		button_ime = [[UIButton alloc] init];
		if ([k_filename_settings file_exists] == NO)
		{
			if (is_phone())
				button_ime.frame = CGRectMake(10, 10, 40, 40);
			else
				button_ime.frame = CGRectMake(10, 10, 50, 50);
			[self display_help];
			[self save_ime_settings];
		}
		else
		{
			button_ime.frame = CGRectFromString([NSString stringWithContentsOfFile:[k_filename_settings filename_document]
																	  encoding:NSUTF8StringEncoding
																		 error:nil]);
		}
		if (is_phone())
			button_ime.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
		else
			button_ime.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
		[button_ime setTitleColor:[UIColor colorWithRed:113.0f/255.0f-0.05f green:120.0f/255.0f-0.05f blue:128.0f/255.0f-0.05f alpha:1] forState:UIControlStateNormal];
		[button_ime setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		//[button_ime setBackgroundImage:[UIImage imageNamed:@"mq_bg_keyboard_matrix_pad.png"] forState:UIControlStateNormal];
		[button_ime setBackgroundImage:[UIImage imageNamed:@"mq_button_keyboard_im_na.png"] forState:UIControlStateNormal];
		[button_ime setImage:[UIImage imageNamed:@"mq_button_keyboard_im_us.png"] forState:UIControlStateNormal];
		[button_ime set_title:@"NA"];
		//	[button_ime addTarget:self action:@selector(action_ime) forControlEvents:UIControlEventTouchUpInside];
#if 1
		[button_ime addTarget:self action:@selector(action_down:with_event:) forControlEvents:UIControlEventTouchDown];
		[button_ime addTarget:self action:@selector(action_drag:with_event:) forControlEvents:UIControlEventTouchDragInside];
		[button_ime addTarget:self action:@selector(action_up:with_event:) forControlEvents:UIControlEventTouchUpInside];
#endif

		//view_background_left = [[UIView alloc] initWithFrame:CGRectMake(-matrix_width, screen_height() - matrix_height, matrix_width, matrix_height)];
		view_background_left = [[UIView alloc] initWithFrame:CGRectMake(-matrix_width, screen_height(), matrix_width, matrix_height)];
		view_background_left.backgroundColor = [UIColor blackColor];
		//view_background_right = [[UIView alloc] initWithFrame:CGRectMake(screen_width(), screen_height() - matrix_height, matrix_width, matrix_height)];
		view_background_right = [[UIView alloc] initWithFrame:CGRectMake(screen_width(), screen_height(), matrix_width, matrix_height)];
		view_background_right.backgroundColor = [UIColor blackColor];
	
		view_background_left.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
		view_background_right.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;

		matrix_left = [[MQButtonMatrixController alloc] initWithFrame:CGRectMake(0, 0, matrix_width, matrix_height) count:30 named:k_filename_settings];
		matrix_left.delegate = self;
		matrix_left.column = 5;
		matrix_left.top = 1;
		matrix_left.left = 1;
		matrix_left.gap_x = 1;
		matrix_left.gap_y = 1;
		matrix_left.locked = YES;

		matrix_left.texts = [[NSMutableArray alloc] init];

		matrix_left.images = [[NSArray alloc] initWithObjects:
			@"mq_bg_keyboard_matrix_pad.png",
			nil];
		matrix_left.actions = [[NSArray alloc] initWithObjects:
									   @"action_key_press:",
			nil];

		matrix_right = [[MQButtonMatrixController alloc] initWithFrame:CGRectMake(0, 0, matrix_width, matrix_height) count:30 named:k_filename_settings];
		matrix_right.delegate = self;
		matrix_right.column = 5;
		matrix_right.top = 1;
		matrix_right.left = 1;
		matrix_right.gap_x = 1;
		matrix_right.gap_y = 1;
		matrix_right.locked = YES;

		matrix_right.texts = [[NSMutableArray alloc] init];

		matrix_right.images = [[NSArray alloc] initWithObjects:
			@"mq_bg_keyboard_matrix_pad.png",
			nil];
		matrix_right.actions = [[NSArray alloc] initWithObjects:
									   @"action_key_press:",
			nil];

		current_keyboard_layout = @"qwerty";
		current_keyboard_status = @"lower";
		[self apply_keyboard_layout];

		[view_background_left addSubview:matrix_left.view];
		[view_background_right addSubview:matrix_right.view];

		controller_ime		= [[UIViewController alloc] init];
		controller_left		= [[UIViewController alloc] init];
		controller_right	= [[UIViewController alloc] init];
		controller_ime.view		= button_ime;
		controller_left.view	= view_background_left;
		controller_right.view	= view_background_right;

		[[delegate perform_string:@"main_view"] addSubview:controller_left.view];
		[[delegate perform_string:@"main_view"] addSubview:controller_right.view];
		[[delegate perform_string:@"main_view"] addSubview:controller_ime.view];
	}
	return self;
}

- (void)action_down:(UIButton*)button with_event:(UIEvent*)event
{
	current_ime_offset = [[[event allTouches] anyObject] locationInView:button];
}

- (void)action_drag:(UIButton*)button with_event:(UIEvent*)event
{
	CGPoint location = [[[event allTouches] anyObject] locationInView:[delegate perform_string:@"main_view"]];
	button.frame = CGRectMake(location.x - current_ime_offset.x, location.y - current_ime_offset.y, button.frame.size.width, button.frame.size.height);
	ime_is_moving = YES;
}

- (void)action_up:(UIButton*)button with_event:(UIEvent*)event
{
	if (ime_is_moving == YES)
	{
		ime_is_moving = NO;
		[self save_ime_settings];
	}
	else
		[self action_ime];
}

- (void)save_ime_settings
{
	[NSStringFromCGRect(button_ime.frame) writeToFile:[k_filename_settings filename_document] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (CGFloat)get_screen_height
{
	UIView* the_view = [delegate perform_string:@"main_view"];
	if (the_view != nil)
		return the_view.frame.size.height;
	else
		return screen_height();
}

- (void)hide_matrix
{
	view_background_left.frame = CGRectMake(-matrix_width, [self get_screen_height], matrix_width, matrix_height);
	view_background_right.frame = CGRectMake(screen_width(), [self get_screen_height], matrix_width, matrix_height);
}

- (void)show_matrix
{
	view_background_left.frame = CGRectMake(0, [self get_screen_height] - matrix_height, matrix_width, matrix_height);
	view_background_right.frame = CGRectMake(screen_width() - matrix_width, [self get_screen_height] - matrix_height, matrix_width, matrix_height);
}

- (void)show
{
	//	matrix_left.view.hidden = NO;
	//	matrix_right.view.hidden = NO;

	if (hidden == NO)
		return;
	hidden = NO;

	[self hide_matrix];
	[UIView begin_animations:0.3];
	[self show_matrix];
	[UIView commitAnimations];
}

- (void)hide
{
	if (hidden == YES)
		return;
	hidden = YES;

	[self show_matrix];
	[UIView begin_animations:0.3];
	[self hide_matrix];
	[UIView commitAnimations];

	//	matrix_left.view.hidden = YES;
	//	matrix_right.view.hidden = YES;
}

- (void)apply_keyboard_layout
{
	[matrix_left.texts removeAllObjects];
	[matrix_right.texts removeAllObjects];

	[self perform_string:[NSString stringWithFormat:@"apply_layout_%@_%@", 
		current_keyboard_layout, current_keyboard_status]];

	[matrix_left refresh];
	[matrix_right refresh];
}

- (void)apply_layout_qwerty_lower
{
	[matrix_left.texts add_objects:
		@"1", @"2", @"3", @"4", @"5", 
		@"q", @"w", @"e", @"r", @"t", 
		@"a", @"s", @"d", @"f", @"g", 
		@"z", @"x", @"c", @"v", @"b", 
		@"↑", @"-", @"=", @"[", @"]",
		@"cap", @"qwt", @"lck", @"hlp", @" ",
		nil];
	[matrix_right.texts add_objects:
		@"6", @"7", @"8", @"9", @"0", 
		@"y", @"u", @"i", @"o", @"p", 
		@"h", @"j", @"k", @"l", @";", 
		@"n", @"m", @",", @".", @"←", 
		@"`", @"'", @"\\", @"/", @"↑",
		@" ", @"↓", @"++", @"--", @"↵",
		nil];
}

- (void)apply_layout_qwerty_shift
{
	[matrix_left.texts add_objects:
		@"!", @"@", @"#", @"$", @"%", 
		@"Q", @"W", @"E", @"R", @"T", 
		@"A", @"S", @"D", @"F", @"G", 
		@"Z", @"X", @"C", @"V", @"B", 
		@"⇑", @"_", @"+", @"{", @"}",
		@"cap", @"qwt", @"lck", @"hlp", @" ",
		nil];
	[matrix_right.texts add_objects:
		@"^", @"&", @"*", @"(", @")", 
		@"Y", @"U", @"I", @"O", @"P", 
		@"H", @"J", @"K", @"L", @":", 
		@"N", @"M", @"<", @">", @"←", 
		@"~", @"\"", @"|", @"?", @"⇑",
		@" ", @"↓", @"++", @"--", @"↵",
		nil];
}

- (void)apply_layout_qwerty_upper
{
	[matrix_left.texts add_objects:
		@"1", @"2", @"3", @"4", @"5", 
		@"Q", @"W", @"E", @"R", @"T", 
		@"A", @"S", @"D", @"F", @"G", 
		@"Z", @"X", @"C", @"V", @"B", 
		@"↑", @"-", @"=", @"[", @"]",
		@"CAP", @"qwt", @"lck", @"hlp", @" ",
		nil];
	[matrix_right.texts add_objects:
		@"6", @"7", @"8", @"9", @"0", 
		@"Y", @"U", @"I", @"O", @"P", 
		@"H", @"J", @"K", @"L", @";", 
		@"N", @"M", @",", @".", @"←", 
		@"`", @"'", @"\\", @"/", @"↑",
		@" ", @"↓", @"++", @"--", @"↵",
		nil];
}

- (void)apply_layout_dvorak_lower
{
	[matrix_left.texts add_objects:
		@"1", @"2", @"3", @"4", @"5", 
		@"'", @",", @".", @"p", @"y", 
		@"a", @"o", @"e", @"u", @"i", 
		@";", @"q", @"j", @"k", @"x", 
		@"↑", @"-", @"=", @"[", @"]",
		@"cap", @"dvr", @"lck", @"hlp", @" ",
		nil];
	[matrix_right.texts add_objects:
		@"6", @"7", @"8", @"9", @"0", 
		@"f", @"g", @"c", @"r", @"l", 
		@"d", @"h", @"t", @"n", @"s", 
		@"b", @"m", @"w", @"v", @"z", 
		@"`", @" ", @"\\", @"/", @"←",
		@" ", @"↓", @"++", @"--", @"↵",
		nil];
}

- (void)apply_layout_dvorak_shift
{
	[matrix_left.texts add_objects:
		@"!", @"@", @"#", @"$", @"%", 
		@"'", @",", @".", @"p", @"y", 
		@"a", @"o", @"e", @"u", @"i", 
		@";", @"q", @"j", @"k", @"x", 
		@"⇑", @"_", @"+", @"{", @"}",
		@"cap", @"dvr", @"lck", @"hlp", @" ",
		nil];
	[matrix_right.texts add_objects:
		@"^", @"&", @"*", @"(", @")", 
		@"f", @"g", @"c", @"r", @"l", 
		@"d", @"h", @"t", @"n", @"s", 
		@"b", @"m", @"w", @"v", @"z", 
		@"~", @" ", @"|", @"?", @"←",
		@" ", @"↓", @"++", @"--", @"↵",
		nil];
}

- (void)apply_layout_dvorak_upper
{
	[matrix_left.texts add_objects:
		@"1", @"2", @"3", @"4", @"5", 
		@"'", @",", @".", @"P", @"Y", 
		@"A", @"O", @"E", @"U", @"I", 
		@";", @"Q", @"J", @"K", @"X", 
		@"↑", @"-", @"=", @"[", @"]",
		@"CAP", @"dvr", @"lck", @"hlp", @" ",
		nil];
	[matrix_right.texts add_objects:
		@"6", @"7", @"8", @"9", @"0", 
		@"F", @"G", @"C", @"R", @"L", 
		@"D", @"H", @"T", @"N", @"S", 
		@"B", @"M", @"W", @"V", @"Z", 
		@"`", @" ", @"\\", @"/", @"←",
		@" ", @" ", @" ", @" ", @"↵",
		nil];
}

- (void)action_key_press:(NSString*)title
{
	//	NSLog(@"title: %@", title);
	if ([title isEqualToString:@"↑"])
	{
		current_keyboard_status = @"shift";
		[self apply_keyboard_layout];
	}
	else if ([title isEqualToString:@"⇑"])
	{
		current_keyboard_status = @"lower";
		[self apply_keyboard_layout];
	}
	else if ([title isEqualToString:@"cap"])
	{
		current_keyboard_status = @"upper";
		[self apply_keyboard_layout];
	}
	else if ([title isEqualToString:@"CAP"])
	{
		current_keyboard_status = @"lower";
		[self apply_keyboard_layout];
	}
	else if ([title isEqualToString:@"qwt"])
	{
		current_keyboard_layout = @"dvorak";
		[self apply_keyboard_layout];
	}
	else if ([title isEqualToString:@"dvr"])
	{
		current_keyboard_layout = @"qwerty";
		[self apply_keyboard_layout];
	}
	else if ([title isEqualToString:@"↓"])
	{
		[self apply_ime_na];
	}
	else if ([title isEqualToString:@"lck"])
	{
		if (matrix_left.locked)
			[@"Keyboard Unlocked" show_alert_message:@"Now you can move the buttons of the keyboard freely to create your own layout."];
		else
			[@"Keyboard Locked" show_alert_message:@"Unlock keyboard to move the buttons of the keyboard to create your own layout."];
		matrix_left.locked = !matrix_left.locked;
		matrix_right.locked = !matrix_left.locked;
	}
	else if ([title isEqualToString:@"hlp"])
	{
		[self display_help];
	}
	else if ([title isEqualToString:@"++"])
	{
		if (matrix_width < screen_width() / 2)
		{
			matrix_width += matrix_resize;
			matrix_height += matrix_resize;
		}
		[self resize_keyboard];
	}
	else if ([title isEqualToString:@"--"])
	{
		if (matrix_width > 100)
		{
			matrix_width -= matrix_resize;
			matrix_height -= matrix_resize;
		}
		[self resize_keyboard];
	}
	else if ([title isEqualToString:@"←"])
	{
		string = [target perform_string:getter];
		if (string.length > 0)
			[target perform_string:setter with:[string substringToIndex:string.length - 1]];
	}
	else if ([title isEqualToString:@"↵"])
	{
		string = [target perform_string:getter];
		[target perform_string:setter with:[string stringByAppendingString:@"\n"]];
	}
	else
	{
		string = [target perform_string:getter];
		[target perform_string:setter with:[string stringByAppendingString:title]];
		//	[string release];	//	CRASH ME
		//	NSLog(@"%@", string);
	}
}

- (void)resize_keyboard
{
	//	NSLog(@"size: %f, %f", matrix_width, matrix_height);
	[UIView begin_animations:0.3];
	view_background_left.frame = CGRectMake(0, [self get_screen_height] - matrix_height, matrix_width, matrix_height);
	view_background_right.frame = CGRectMake(screen_width() - matrix_width, [self get_screen_height] - matrix_height, matrix_width, matrix_height);
	matrix_left.view.frame = CGRectMake(0, 0, matrix_width, matrix_height);
	matrix_right.view.frame = CGRectMake(0, 0, matrix_width, matrix_height);
	[UIView commitAnimations];
	[matrix_left refresh];
	[matrix_right refresh];
}

- (void)action_ime
{
	[button_ime setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
	if ([[button_ime titleForState:UIControlStateNormal] isEqualToString:@"NA"])
	{
		[target perform_string:@"resignFirstResponder"];
		//	if ([target respondsToSelector:@selector(editable)])
		if ([target isKindOfClass:[UITextView class]])
		{
			[button_ime set_title:@"sys"];
			[(UITextView*)target setEditable:NO];
			[(UITextView*)target resignFirstResponder];
		}
		else
			[button_ime set_title:@" ↓"];
		[self show];
	}
	else if ([[button_ime titleForState:UIControlStateNormal] isEqualToString:@"sys"])
	{
		[self apply_ime_edit];
	}
	else if ([[button_ime titleForState:UIControlStateNormal] isEqualToString:@" ↓"])
	{
		[self apply_ime_na];
	}
}

- (void)apply_ime_edit
{
	NSLog(@"apply ime edit: %@", button_ime);
	[button_ime setImage:nil forState:UIControlStateNormal];
	[button_ime set_title:@" ↓"];
	[self hide];
	[(UITextView*)target setEditable:YES];
	[(UITextView*)target becomeFirstResponder];
}

- (void)apply_ime_na
{
	[button_ime set_title:@"NA"];
	[button_ime setImage:[UIImage imageNamed:@"mq_button_keyboard_im_us.png"] forState:UIControlStateNormal];
	[self hide];
	[target perform_string:@"resignFirstResponder"];
}

- (void)display_help
{
	[@"About Keyboard+" show_alert_message:@"To enable Keyboard+, tap the US flag button. Keyboard+ allows you to switch between insert mode, edit mode, and view mode. In insert mode, you can switch between Qwerty and Dvorak layouts, or even create your own layout by using the lock/unlock (lck) button.\n\nThis message will be shown during the first time you run this app. To view it again, please press the help (hlp) button."];
}

@end
