#import "LYUIKit.h"

BOOL CGPointInRect(CGPoint point, CGRect rect)
{
	if ((rect.origin.x <= point.x) &&
		(rect.origin.y <= point.y) &&
		(point.x <= (rect.origin.x + rect.size.width)) &&
		(point.y <= (rect.origin.y + rect.size.height)))
	{
		return YES;
	}
	return NO;
}

UIInterfaceOrientation get_interface_orientation()
{
	return [[UIApplication sharedApplication] statusBarOrientation];
}

BOOL is_interface_portrait()
{
	if ((get_interface_orientation() == UIInterfaceOrientationPortrait) ||
		(get_interface_orientation() == UIInterfaceOrientationPortraitUpsideDown))
		return YES;
	else
		return NO;
}

BOOL is_interface_landscape()
{
	if ((get_interface_orientation() == UIInterfaceOrientationLandscapeLeft) ||
		(get_interface_orientation() == UIInterfaceOrientationLandscapeRight))
		return YES;
	else
		return NO;
}

CGFloat get_width(CGFloat width)
{
	if ((get_interface_orientation() == UIInterfaceOrientationPortrait) ||
		(get_interface_orientation() == UIInterfaceOrientationPortraitUpsideDown))
		return width * UIScreen.mainScreen.bounds.size.width;
	else
		return width * UIScreen.mainScreen.bounds.size.height;
}

CGFloat get_height(CGFloat height)
{
	if ((get_interface_orientation() == UIInterfaceOrientationPortrait) ||
		(get_interface_orientation() == UIInterfaceOrientationPortraitUpsideDown))
		return height * UIScreen.mainScreen.bounds.size.height;
	else
		return height * UIScreen.mainScreen.bounds.size.width;
}

CGFloat screen_width()
{
	return get_width(1);
}

CGFloat screen_height()
{
	return get_height(1);
}

CGFloat screen_max()
{
	if (screen_width() > screen_height())
		return screen_width();
	else
		return screen_height();
}

UIView* ly_alloc_view_loading(void)
{
	CGRect	rect = UIScreen.mainScreen.bounds;
	UIView*	view;

	view = [[UIView alloc] initWithFrame:rect];
	view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];

	UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	indicator.frame = CGRectMake(rect.size.width / 2 - 10, rect.size.height / 2 - 10, 20, 20);
	[indicator startAnimating];

	[view addSubview:indicator];

	return view;
}

@implementation LYPickerViewProvider

@synthesize titles;
@synthesize delegate;

- (id)initWithPicker:(UIPickerView*)picker
{
	self = [super init];
	if (self != nil)
	{
		delegate = nil;
		picker.delegate = self;
		picker.dataSource = self;
		titles = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[titles release];
	[super dealloc];
}

#pragma mark delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (delegate != nil)
		objc_msgSend(delegate, @selector(pickerView:didSelectRow:inComponent:), self, self, row, component);
}

#pragma mark data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return titles.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [[titles objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [[titles objectAtIndex:component] objectAtIndex:row];
}

@end

//	TODO replace with LYMiniAppsController
static LYMiniApps *ly_mini_apps_shared_controller = nil;

@implementation LYMiniApps

@synthesize nav;

+ (id)shared
{
	@synchronized(self)
	{
		if (ly_mini_apps_shared_controller == nil)
			[[self alloc] init];
	}
	return ly_mini_apps_shared_controller;
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (ly_mini_apps_shared_controller == nil)
		{
			ly_mini_apps_shared_controller = [super allocWithZone:zone];
			return ly_mini_apps_shared_controller;
		}
	}
	return nil;
}
- (id)initWithNavigationController:(UINavigationController*)a_nav
{
	if (self = [super init])
	{
		nav = a_nav;
	}
	return self;
}

- (void)show_flashlight:(UIColor*)color
{
	status_bar_hidden = [[UIApplication sharedApplication] isStatusBarHidden];

	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(-100, -100, 2148, 2148)];
	button.backgroundColor = color;
	button.alpha = 0.01;
	[button addTarget:[LYMiniApps shared] action:@selector(hide_view:) forControlEvents:UIControlEventTouchDown];
	[[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)] addSubview:button];
	if (status_bar_hidden == NO)
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

	[UIView begin_animations:0.3];
	button.alpha = 1;
	[UIView commitAnimations];
}

- (void)show_image:(NSString*)filename
{
	UIViewController* controller = [[UIViewController alloc] init];
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen_width(), screen_height())];

	status_bar_hidden = [[UIApplication sharedApplication] isStatusBarHidden];
	if (status_bar_hidden == NO)
		[button reset_height:-20];
	controller.view = button;
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	button.backgroundColor = [UIColor clearColor];
	[button autoresizing_add_width:YES height:YES];
	[button set_background_named:filename];
	//[button set_image_named:filename];
	[button addTarget:[LYMiniApps shared] action:@selector(hide_controller:) forControlEvents:UIControlEventTouchDown];
	if (nav == nil)
		[[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)] addSubview:button];
	else
		[nav presentModalViewController:controller animated:YES];
}

- (void)hide_view:(UIView*)view
{
	if (status_bar_hidden == NO)
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	[UIView begin_animations:0.3];
	view.alpha = 0.01;
	[UIView commitAnimations];

	[self performSelector:@selector(remove_release:) withObject:view afterDelay:0.3];
}

- (void)hide_controller:(UIView*)view
{
	//	if (status_bar_hidden == NO)
	//		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	[nav dismissModalViewControllerAnimated:YES];
	[[view view_controller] release];
	[view release];
}

- (void)remove_release:(UIView*)view
{
	[view removeFromSuperview];
	[view release];
}

@end


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


#ifdef LY_ENABLE_SDK_AWS
@implementation LYSuarViewController

@synthesize delegate;
@synthesize tab;
@synthesize nav_wall;
@synthesize nav_profile;

- (id)init
{
	self = [super init];
	if (self)
	{
		[self loadView];
		sdb	= [[LYServiceAWSSimpleDB alloc] init];
		provider_wall = nil;
	}
	return self;
}

- (void)dealloc
{
	[sdb release];
	[super dealloc];
}

- (IBAction)load_wall
{
	if (provider_wall == nil)
	{
		provider_wall = [[LYTableViewProvider alloc] initWithTableView:table_wall];
		provider_wall.texts = [[NSMutableArray alloc] initWithObjects:[NSMutableArray array], nil];
		provider_wall.details = [[NSMutableArray alloc] initWithObjects:[NSMutableArray array], nil];
		provider_wall.image_urls = [[NSMutableArray alloc] initWithObjects:[NSMutableArray array], nil];
		provider_wall.delegate = self;
		provider_wall.cell_height = 64;

		UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 38, 20, 20)];
		activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[activity startAnimating];
		[provider_wall.data key:@"refresh-view" v:activity];
		//[provider_wall apply_theme_color:[UIColor blackColor] on:[UIColor whiteColor]];
	}

	[provider_wall.data key:@"state" v:@"refresh"];
	[table_wall reloadData];
	NSString* query = [NSString stringWithFormat:
		@"select * from `posts` where `author-mail` = '%@' and `date-create` > '20110101-00:00:00' order by `date-create` desc",
		[@"ly-suar-profile-mail" setting_string]];
		NSLog(@"query: %@", query);
	[sdb select:query block:^(id obj, NSError* error)
	{
		NSArray* array = (NSArray*)obj;
		//	NSLog(@"query result: %@", error);
		//	NSLog(@"wall: %@", array);
		[provider_wall.data key:@"state" v:@""];
		[[provider_wall.texts i:0] removeAllObjects];
		for (NSDictionary* dict_item in array)
		{
			NSDictionary* dict = [dict_item v:@"attr-dict"];
			NSString* s;

			s = [dict v:@"text-title"];
			if ([s is:@""])
				s = @"Untitled";
			[[provider_wall.texts i:0] addObject:s];

			s = [dict v:@"text-body"];
			if ([s is:@""])
				s = @"No description.";
			[[provider_wall.details i:0] addObject:s];

			s = [dict v:@"photo-main"];
			if ([s is:@""])
				s = @"";
			else
			{
				if (![[s substringToIndex:4] is:@"raw/"])
					s = [@"raw/" stringByAppendingString:s];
				s = [@"http://s3.amazonaws.com/us-general/" stringByAppendingString:s];
			}
			[[provider_wall.image_urls i:0] addObject:s];
		}
		[table_wall reloadData];
		//	NSLog(@"titles %@", provider_wall.texts);
	}];
}

- (void)load
{
	[[provider_wall.texts i:0] addObject:@"No Post"];
	[table_wall reloadData];

	if ([@"ly-suar-profile-pin" setting_string] == nil)
	{
		segment_profile_type.selectedSegmentIndex = 1;
		[self action_profile_type];
		[field_profile_name becomeFirstResponder];
	}
	else
	{
		field_profile_name.text = [@"ly-suar-profile-name" setting_string];
		field_profile_mail.text = [@"ly-suar-profile-mail" setting_string];
		field_profile_pin1.text = [@"ly-suar-profile-pin" setting_string];
		field_profile_pin2.text = [@"ly-suar-profile-pin" setting_string];
	}
}

#pragma mark action

- (IBAction)action_delegate_dismiss
{
	[delegate perform_string:@"suar_dismiss"];
}

- (IBAction)action_profile_type
{
	switch (segment_profile_type.selectedSegmentIndex)
	{
		case 0:
			field_profile_name.hidden = YES;
			field_profile_pin2.hidden = YES;
			break;
		case 1:
			field_profile_name.hidden = NO;
			field_profile_pin2.hidden = NO;
			break;
	}
}

- (IBAction)action_profile_done
{
	if (segment_profile_type.selectedSegmentIndex == 0)
	{
		//	login
		[LYLoading enable_label:@"Logging in..."];
		[[LYLoading shared] setNav:nil];
		[LYLoading show];
		NSString* query = [NSString stringWithFormat:@"select * from `users` where itemName() = '%@'",
			field_profile_mail.text];
		//	NSLog(@"query: %@", query);
		[sdb select:query block:^(id obj, NSError* error)
		{
			NSArray* array = (NSArray*)obj;
			//	NSLog(@"login: %@", array);
			[LYLoading performSelector:@selector(hide) withObject:nil afterDelay:0.5];
			if (error != nil)
			{
				[@"Login Failed" show_alert_message:error.localizedDescription];
				return;
			}
			if (array.count == 0)
			{
				[@"Login Failed" show_alert_message:@"Username not found. Please try again or choose \"Register\" to create a new profile."];
				return;
			}
			if (![[[[array i:0] v:@"attr-dict"] v:@"pin"] is:field_profile_pin1.text])
				[@"Login Failed" show_alert_message:@"Your username/password combination is not correct. Please try again or choose \"Register\" to create a new profile."];
			else
			{
				[@"ly-suar-profile-name" setting_string:[[[array i:0] v:@"attr-dict"] v:@"name-display"]];
				[@"ly-suar-profile-mail" setting_string:field_profile_mail.text];
				[@"ly-suar-profile-pin" setting_string:field_profile_pin1.text];
				field_profile_name.text = [@"ly-suar-profile-name" setting_string];
				field_profile_pin2.text = [@"ly-suar-profile-pin" setting_string];
				//[nav dismissModalViewControllerAnimated:YES];
				[self action_delegate_dismiss];
			}
		}];
	}
	else
	{
		//	register
		if (field_profile_name.text.length < 3)
		{
			[@"Name Too Short" show_alert_message:@"The name you entered is too short. Please choose a valid name."];
			[field_profile_name becomeFirstResponder];
			return;
		}
		if ([field_profile_mail.text is_email] == NO)
		{
			[@"Invalid E-mail Address" show_alert_message:@"Please enter a valid e-mail address."];
			[field_profile_mail becomeFirstResponder];
			return;
		}
		if ([field_profile_pin1.text is:field_profile_pin2.text] == NO)
		{
			[@"Passwords Mismatch" show_alert_message:@"Please make sure the two passwords you've entered are identical."];
			[field_profile_pin1 becomeFirstResponder];
			return;
		}
		if (field_profile_pin1.text.length < 5)
		{
			[@"Password Too Short" show_alert_message:@"The password must have at least 5 characters. Please try again."];
			[field_profile_pin1 becomeFirstResponder];
			return;
		}
		[LYLoading enable_label:@"Checking username..."];
		[[LYLoading shared] setNav:nil];
		[LYLoading show];
		
		NSString* query = [NSString stringWithFormat:@"select * from `users` where itemName() = '%@' and pin is not null",
			field_profile_mail.text];
		//	NSLog(@"query: %@", query);
		[sdb select:query block:^(id obj, NSError* error)
		{
			NSArray* array = (NSArray*)obj;
			if (array.count > 0)
			{
				[@"Email already registered" show_alert_message:@"This email address has already been registered. Please choose another email as username and try again."];
				[LYLoading performSelector:@selector(hide) withObject:nil afterDelay:0.5];
			}
			else
			{
				[sdb put:@"users" name:field_profile_mail.text];
				[sdb key:@"name-display" unique:field_profile_name.text];
				[sdb key:@"pin" unique:field_profile_pin1.text];
				[sdb key:@"app" value:@"org.superarts.SPS"];
				[sdb put_block:^(id obj, NSError* error)
				{
					NSLog(@"register: %@, %@", obj, error);
					if (error == nil)
					{
						[@"ly-suar-profile-name" setting_string:field_profile_name.text];
						[@"ly-suar-profile-mail" setting_string:field_profile_mail.text];
						[@"ly-suar-profile-pin" setting_string:field_profile_pin1.text];
						//[nav dismissModalViewControllerAnimated:YES];
						[self action_delegate_dismiss];
					}
					else
					{
						[@"Registration Failed" show_alert_message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]];
					}
					NSLog(@"xxx");
					[LYLoading performSelector:@selector(hide) withObject:nil afterDelay:0.5];
				}];
			}
		}];
	}
}

#pragma mark delegate

- (BOOL)textFieldShouldReturn:(UITextField *)field
{
	if (field == field_profile_name)
		[field_profile_mail becomeFirstResponder];
	else if (field == field_profile_mail)
		[field_profile_pin1 becomeFirstResponder];
	else if (field == field_profile_pin1)
	{
		if (segment_profile_type.selectedSegmentIndex == 0)
			[field_profile_pin1 resignFirstResponder];
		else
			[field_profile_pin2 becomeFirstResponder];
	}
	else if (field == field_profile_pin2)
		[field_profile_pin2 resignFirstResponder];

	return YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)controller
{
	//	NSLog(@"should select index: %i", tab.selectedIndex);
	if (controller == nav_wall)
		if ([@"ly-suar-profile-pin" setting_string] == nil)
			return NO;
	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	//	NSLog(@"index: %i", tab.selectedIndex);
	if (tab.selectedIndex == 1)
	{
		if (provider_wall == nil)
			[self load_wall];
	}
}

@end
#endif


@implementation LYFlipImageView

@synthesize data;

- (id)initWithFrame:(CGRect)rect
{
	self = [super initWithFrame:rect];
	if (self)
	{
		data = [[NSMutableDictionary alloc] init];
		[data key:@"chars" v:[[NSMutableArray alloc] init]];
		[self set_char_numbers];

		UILabel* label = [[UILabel alloc] initWithFrame:rect];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.backgroundColor = [UIColor blackColor];
		label.font = [UIFont systemFontOfSize:512];
		label.minimumFontSize = 10;
		label.adjustsFontSizeToFitWidth = YES;
		[data key:@"label" v:label];
	}
	return self;
}

- (void)dealloc
{
	[data release];
}

- (void)set_char_numbers
{
	NSMutableArray* array = [data v:@"chars"];
	[array removeAllObjects];
	for (char c = '0'; c <= '9'; c++)
		[array addObject:[NSString stringWithFormat:@"%c", c]];
	NSLog(@"xxx %@", array);
}

- (void)flip_to:(NSString*)c
{
}

@end
