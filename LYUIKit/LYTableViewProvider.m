#import "LYTableViewProvider.h"

#define k_ly_table_cell_height				64
#define k_ly_table_accessory_size			32
#define k_ly_table_cell_image_gap			14
#define k_ly_table_header_height_plain		21
#define k_ly_table_footer_height_plain		21
#define k_ly_table_header_height_grouped	46
#define k_ly_table_footer_height_grouped	21

@implementation LYTableViewProvider

@synthesize view;
@synthesize controller;
@synthesize delegate;
@synthesize style;
@synthesize theme;
@synthesize current_path;
@synthesize current_text;
@synthesize data;
//	XXX: current header & details?
@synthesize accessory_type;
@synthesize accessory_name;
@synthesize accessories;
@synthesize animation_delete;
@synthesize can_edit;
@synthesize cell_selection;
@synthesize cell_image_rect;
@synthesize cell_image_mode;
@synthesize cell_image_place;

@synthesize texts;
@synthesize details;
@synthesize images;
@synthesize image_urls;
@synthesize indexes;
@synthesize index_length;
@synthesize headers;
@synthesize footers;

@synthesize text_label;
@synthesize detail_label;

//@synthesize header_bg;
//@synthesize footer_bg;
@synthesize header_label;
@synthesize footer_label;

@synthesize cell_height;
@synthesize cell_bg_color;
@synthesize cell_bg;
@synthesize cell_bg_top;
@synthesize cell_bg_bottom;
@synthesize cell_bg_middle;
@synthesize cell_bg_selected;
@synthesize cell_bg_top_selected;
@synthesize cell_bg_bottom_selected;
@synthesize cell_bg_middle_selected;
@synthesize cell_bg_color_interlace;

@synthesize search_bar;
@synthesize additional_views;

- (id)initWithStyle:(UITableViewStyle)table_style
{
	//CGRect rect = [[UIScreen mainScreen] bounds];
	//view = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) style:table_style];
	view = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width(), screen_height()) style:table_style];
	self = [self initWithTableView:nil];
	return self;
}

- (id)initWithTableView:(UITableView*)table_view
{
	CGRect rect = [[UIScreen mainScreen] bounds];

	self = [super init];
	if (self != nil)
	{
		if (table_view != nil)
			view = table_view;

		if (view.view_controller != nil)
		{
			controller = view.view_controller;
		}
		else
		{
			controller = [[UIViewController alloc] init];
			controller.view = view;
			//NSLog(@"xxx 1 %@", controller.navigationItem);
			//NSLog(@"xxx 2 %@", controller.navigationItem.rightBarButtonItem);
			//controller.view.autoresizingMask |= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			//[controller.view addSubview:view];
		}

		button_mask = [[UIButton alloc] initWithFrame:view.frame];
		button_mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
		[button_mask addTarget:self action:@selector(action_search_resign) forControlEvents:UIControlEventTouchUpInside];

		switch (view.style)
		{
			case UITableViewStylePlain:
				table_header_height = k_ly_table_header_height_plain;
				table_footer_height = k_ly_table_footer_height_plain;
				break;
			case UITableViewStyleGrouped:
				table_header_height = k_ly_table_header_height_grouped;
				table_footer_height = k_ly_table_footer_height_grouped;
				break;
		}

		view.delegate	= self;
		view.dataSource	= self;
		
		current_path	= nil;
		current_text	= @"";
		theme			= @"";

		can_edit		= NO;
		style			= UITableViewCellStyleSubtitle;
		index_length	= 0;

		animation_delete = UITableViewRowAnimationFade;

		texts		= [[NSMutableArray alloc] init];
		details		= [[NSMutableArray alloc] init];
		images		= [[NSMutableArray alloc] init];
		image_urls	= [[NSMutableArray alloc] init];
		indexes		= [[NSMutableArray alloc] init];
		headers		= [[NSMutableArray alloc] init];
		footers		= [[NSMutableArray alloc] init];
		data		= [[NSMutableDictionary alloc] init];
		header_counts		= [[NSMutableArray alloc] init];
		accessories			= [[NSMutableArray alloc] init];
		additional_views	= [[NSMutableArray alloc] init];

		[data setValue:NSStringFromCGSize(CGSizeMake(k_ly_table_accessory_size, k_ly_table_accessory_size)) forKey:@"accessory-size"];
		[data setValue:[NSMutableArray array] forKey:@"accessory-highlighted"];
		[data setValue:[NSNumber numberWithBool:NO] forKey:@"move-enabled"];
		[data setValue:[NSMutableArray array] forKey:@"edit-exclude"];
		[data setValue:[NSMutableArray array] forKey:@"badge-array"];
		[data setValue:[NSMutableArray array] forKey:@"badge2-array"];
		[data setValue:[NSMutableArray array] forKey:@"filter-array"];
		[data setValue:[NSMutableDictionary dictionary] forKey:@"cell-subviews"];
		[data setValue:[NSMutableDictionary dictionary] forKey:@"cell-gestures"];
		[data setValue:@"Loading..." forKey:@"refresh-text"];
		[data setValue:@"ly_transparent_64x64.png" forKey:@"image-placeholder"];
		[data setValue:nil forKey:@"source-deleted-object"];
		//	[data setValue:nil forKey:@"source-deleted-row"];

		//	init preset ui
		UILabel* label_badge = [[UILabel alloc] init];
		label_badge.hidden = YES;
		UIImageView* image_badge = [[UIImageView alloc] init];
		image_badge.hidden = YES;
		UILabel* label_badge2 = [[UILabel alloc] init];
		label_badge2.hidden = YES;
		UIImageView* image_badge2 = [[UIImageView alloc] init];
		image_badge2.hidden = YES;

		UIProgressView* progress_refresh = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
		progress_refresh.frame = CGRectMake(18, 34, 200, 20);
		progress_refresh.progress = 0;

		[data setValue:label_badge forKey:@"badge-label"];
		[data setValue:image_badge forKey:@"badge-image"];
		[data setValue:label_badge2 forKey:@"badge2-label"];
		[data setValue:image_badge2 forKey:@"badge2-image"];
		[data setValue:progress_refresh forKey:@"refresh-progress"];

		//	release preset ui
		[label_badge release];
		[image_badge release];
		[label_badge2 release];
		[image_badge2 release];
		[progress_refresh release];

		backup_texts = nil;
		backup_details = nil;
		backup_images = nil;
		backup_image_urls = nil;
		backup_accessories = nil;
		backup_subviews = nil;
		backup_headers = nil;
		backup_footers = nil;
		search_bar = nil;

		text_label		= [[UILabel alloc] init];
		detail_label	= [[UILabel alloc] init];
		text_label.hidden		= YES;
		detail_label.hidden		= YES;
		text_label.backgroundColor		= [UIColor clearColor];
		detail_label.backgroundColor	= [UIColor clearColor];
		detail_label.font = [detail_label.font fontWithSize:14];

		//header_bg		= nil;
		//footer_bg		= nil;

		header_label					= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, table_header_height)];
		header_label.hidden = YES;

		footer_label					= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, table_footer_height)];
		footer_label.font				= [footer_label.font fontWithSize:12];
		footer_label.textAlignment		= UITextAlignmentCenter;
		footer_label.hidden = YES;

		cell_bg_color			= [UIColor whiteColor];
		cell_bg_color_interlace	= nil;
		cell_height			= k_ly_table_cell_height;
		cell_bg				= nil;
		cell_bg_top			= nil;
		cell_bg_bottom		= nil;
		cell_bg_middle		= nil;
		cell_bg				= nil;
		cell_bg_top			= nil;
		cell_bg_bottom		= nil;
		cell_bg_middle		= nil;
		cell_selection		= UITableViewCellSelectionStyleGray;
		cell_image_rect		= CGRectMake(0, 0, 64, 64);
		cell_image_mode		= UIViewContentModeScaleToFill;
		cell_image_place	= @"image";

		accessory_name	= nil;
		accessory_type	= UITableViewCellAccessoryNone;
		//separator_style = UITableViewCellSeparatorStyleSingleLine;

		switch (view.style)
		{
			case UITableViewStylePlain:
				header_label.textColor			= [UIColor whiteColor];
				//header_label.backgroundColor	= [[UIColor scrollViewTexturedBackgroundColor] colorWithAlphaComponent:0.9];
				header_label.backgroundColor	= [[UIColor perform_string:@"scrollViewTexturedBackgroundColor"] colorWithAlphaComponent:0.9];
				break;
			case UITableViewStyleGrouped:
				header_label.textAlignment		= UITextAlignmentCenter;
				header_label.textColor			= [UIColor blackColor];
				header_label.backgroundColor	= [UIColor clearColor];
				footer_label.textColor			= [UIColor blackColor];
				footer_label.backgroundColor	= [UIColor clearColor];
				break;
		}

		//	[self setTheme:@"white on black"];
	}
	return self;
}

- (void)setTheme:(NSString*)a_theme
{
	theme = a_theme;

	if ([theme isEqualToString:@"white on black"])
	{
		[self apply_theme_color:[UIColor whiteColor] on:[UIColor blackColor]];
	}
	else if ([theme isEqualToString:@"orange on black"])
	{
		[self apply_theme_color:[UIColor orangeColor] on:[UIColor blackColor]];
	}
	else if ([theme isEqualToString:@"white on red"])
	{
		[self apply_theme_white_on_red];
	}
}

//	theme of pacard list
- (void)apply_theme_transparent_interlace
{
	[self apply_theme_color:[UIColor blackColor] on:[UIColor clearColor]];
#if 1
	cell_bg = nil;
	cell_bg_color = [[UIColor colorWithWhite:0 alpha:0.01] retain];
	cell_bg_color_interlace = [[UIColor colorWithWhite:0 alpha:0.1] retain];

	//text_label.backgroundColor = [UIColor blueColor];
	//detail_label.backgroundColor = [UIColor redColor];
	header_label.hidden = NO;
	header_label.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
	header_label.numberOfLines = 2;

	detail_label.lineBreakMode = UILineBreakModeWordWrap;
	detail_label.numberOfLines = 2;
#if 1
	header_label.textColor = [UIColor whiteColor];
	header_label.backgroundColor = [UIColor colorNamed:@"table_header_interlace.png"];
	view.bounces = NO;
#else
	//header_label.backgroundColor = [UIColor clearColor];
	header_label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.25];
#endif

	view.separatorStyle = UITableViewCellSeparatorStyleNone;
	accessory_type = UITableViewCellAccessoryDisclosureIndicator;
#endif
	view.contentOffset = CGPointMake(0, 0);
	[view reloadData];
}

//	theme of pacard menu
- (void)apply_theme_white_on_red
{
	[self apply_theme_color:[UIColor whiteColor] on:[UIColor redColor]];

	view.separatorStyle = UITableViewCellSeparatorStyleNone;
	cell_bg_color = [UIColor clearColor];
	//text_label.backgroundColor = [UIColor clearColor];
	
	header_label.backgroundColor = [UIColor clearColor];

	text_label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
	cell_height = 50;
	cell_bg = @"bg_cell_red.png";
	cell_bg_selected = @"bg_cell_red_highlighted.png";

	view.contentOffset = CGPointMake(0, 0);
	[view reloadData];
}

- (void)apply_theme_metal01
{
	[self apply_theme_color:[UIColor blackColor] on:[UIColor clearColor]];
	//view.backgroundColor = [UIColor colorNamed:@"ly_theme_table_table01_bg.png"];
	cell_bg = @"ly_theme_table_metal01_cell.png";
	cell_bg_top = @"ly_theme_table_metal01_cell1.png";
	cell_bg_bottom = @"ly_theme_table_metal01_cell2.png";
	header_label.textColor = [UIColor whiteColor];

	view.contentOffset = CGPointMake(0, 0);
	[view reloadData];
}

//	common color theme
- (void)apply_theme_color:(UIColor*)a_color on:(UIColor*)bg_color
{
	UIColor* dark_color = [a_color colorWithAlphaComponent:0.7];

	cell_bg_color = bg_color;

	text_label.hidden = NO;
	text_label.textColor = a_color;

	detail_label.hidden = NO;
	detail_label.textColor = dark_color;

	header_label.hidden = NO;
	header_label.textColor = a_color;

	footer_label.hidden = NO;
	footer_label.textColor = dark_color;
	footer_label.backgroundColor = bg_color;

	view.backgroundColor = bg_color;
	view.separatorColor = a_color;

	detail_label.lineBreakMode = UILineBreakModeWordWrap;
	detail_label.numberOfLines = 0;

	switch (view.style)
	{
		case UITableViewStylePlain:
			//header_label.backgroundColor = [[UIColor scrollViewTexturedBackgroundColor] colorWithAlphaComponent:0.5];
			header_label.backgroundColor = [[UIColor perform_string:@"scrollViewTexturedBackgroundColor"] colorWithAlphaComponent:0.5];
			break;
		case UITableViewStyleGrouped:
			break;
	}

	if (is_pad())
	{
		[view setBackgroundView:nil];	//	TODO: "view.backgroundView?
		[view setBackgroundView:[[[UIView alloc] init] autorelease]];
		[view setBackgroundColor:bg_color];
	}

	view.contentOffset = CGPointMake(0, 0);
	[view reloadData];
}

#pragma mark table view general

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if ([[data v:@"state"] is:@"refresh"])
		return 1;
	else
		return texts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([[data v:@"state"] is:@"refresh"])
		return 1;
	else
		return [[texts objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray* array;
	UIView* additional_view = [self get_additional_view:indexPath];

	if (additional_view != nil)
	{
		array = [texts objectAtIndex:indexPath.section];
		if ((array.count != 1) && ((array.count - 1) == indexPath.row))
			return additional_view.frame.size.height + 2;
		else
			return additional_view.frame.size.height + 1;
	}
	return cell_height;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSDictionary*	dict;
	UIView*			additional_view;

	for (dict in additional_views)
	{
		additional_view = [dict objectForKey:@"view"];
		[UIView begin_animations:0.3];
		[additional_view set_x:(screen_width() - additional_view.frame.size.width) / 2];
		[UIView commitAnimations];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString*	MyIdentifier = @"id table";
	UITableViewCell*	cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	NSString*	text;
	NSString*	detail;
	NSString*	image;
	NSString*	image_url;
	NSString*	accessory;
	UIImage*	the_image;
	LYAsyncImageView*	image_view;
	UIView*				additional_view;
	NSArray*			subviews;
	NSArray*			gestures;

	additional_view = [self get_additional_view:indexPath];
	if (additional_view != nil)
	{
		[additional_view set_x:(screen_width() - additional_view.frame.size.width) / 2];
		[additional_view set_y:1];
		[additional_view autoresizing_add_width:NO height:NO];
		[additional_view autoresizing_flexible_left:NO right:NO top:NO bottom:YES];

		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.text = [texts object_at_path:indexPath];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		[cell addSubview:additional_view];
		//	NSLog(@"TABLE added cell %i / %i: %@", indexPath.section, indexPath.row, additional_view);
		return cell;
	}

	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:nil] autorelease];

		text		= [texts object_at_path:indexPath];
		detail		= [details object_at_path:indexPath];
		image		= [images object_at_path:indexPath];
		image_url	= [image_urls object_at_path:indexPath];
		accessory	= [accessories object_at_path:indexPath];
		subviews	= [[data v:@"cell-subviews"] objectForKey:indexPath];
		gestures	= [[data v:@"cell-gestures"] objectForKey:indexPath];

		the_image = [UIImage imageNamed:image];
		if (the_image == nil)
			the_image = [UIImage imageWithContentsOfFile:image];

		if ([[data v:@"state"] is:@"refresh"])
		{
			//	NSLog(@"cell: refreshing");
			cell.textLabel.text = [data v:@"refresh-text"];
			cell.detailTextLabel.text = @" ";
			[cell addSubview:[data v:@"refresh-progress"]];
			//	[cell.detailTextLabel addSubview:[data v:@"refresh-progress"]];
			cell.selectionStyle	= UITableViewCellSelectionStyleNone;
		}
		else
		{
			if ([text isEqual:[NSNull null]] == NO)
				cell.textLabel.text = text;
			if ([detail isEqual:[NSNull null]] == NO)
				cell.detailTextLabel.text = detail;
			if (the_image != nil)
			{
				//	NSLog(@"cell image %@: %@", image, the_image);
				if ([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)])
				{
					cell.imageView.image = [UIImage imageWithCGImage:the_image.CGImage scale:(the_image.size.height / (cell_height - k_ly_table_cell_image_gap)) orientation:UIImageOrientationUp];
					//	NSLog(@"used 4.0 scaling: %@, %f", cell.imageView.image, the_image.size.height / (cell_height - k_ly_table_cell_image_gap));
					cell.imageView.contentMode = UIViewContentModeCenter;
				}
				else
				{
					//	NSLog(@"4.0 scale not supported");
					cell.imageView.image = the_image;
				}
			}
			if (image_url != nil)
			{
				//cell.imageView.image = [UIImage imageNamed:@"ly_blank_64x64.png"];
				cell.imageView.image = [UIImage imageNamed:[data v:@"image-placeholder"]];
				image_view = [[LYAsyncImageView alloc] initWithFrame:cell_image_rect];
				image_view.contentMode = cell_image_mode;
				//[image_view autoresizing_add_width:YES height:YES];
				image_view.clipsToBounds = YES;
				[image_view load_url:image_url];
				if ([cell_image_place isEqualToString:@"image"])
					[cell.imageView addSubview:image_view];
				else if ([cell_image_place isEqualToString:@"cell"])
					[cell addSubview:image_view];
				else
					NSLog(@"TABLE warning: unknown cell image place");
				//NSLog(@"table image url: %@\n%@", image_url, image_view);
			}
#if 1
			if (([[data v:@"badge-image"] isHidden] == NO) &&
				([[data v:@"badge-label"] isHidden] == NO))
			{
				UIImageView* image_badge = [[UIImageView alloc] init];
				UILabel* label_badge = [[UILabel alloc] init];

				[image_badge copy_style:[data v:@"badge-image"]];
				[label_badge copy_style:[data v:@"badge-label"]];

				NSString* badge_string = [[data v:@"badge-array"] object_at_path:indexPath];
				//	NSLog(@"badge: %@", badge_string);
				if (badge_string != nil)
					label_badge.text = badge_string;
				else
					label_badge.text = [NSString stringWithFormat:@"%i", indexPath.row + 1];
				//	if (indexPath.row < 10)
				//		[label_badge reset_x:-1];

				[image_badge addSubview:label_badge];
				[cell addSubview:image_badge];
				[label_badge release];
				[image_badge release];
			}
			if (([[data v:@"badge2-image"] isHidden] == NO) &&
				([[data v:@"badge2-label"] isHidden] == NO))
			{
				UIImageView* image_badge2 = [[UIImageView alloc] init];
				UILabel* label_badge2 = [[UILabel alloc] init];

				[image_badge2 copy_style:[data v:@"badge2-image"]];
				[label_badge2 copy_style:[data v:@"badge2-label"]];

				NSString* badge2_string = [[data v:@"badge2-array"] object_at_path:indexPath];
				//	NSLog(@"badge2: %@", badge2_string);
				if (badge2_string != nil)
					label_badge2.text = badge2_string;
				else
					label_badge2.text = [NSString stringWithFormat:@"%i", indexPath.row + 1];
				//	if (indexPath.row < 10)
				//		[label_badge2 reset_x:-1];

				[image_badge2 addSubview:label_badge2];
				[cell addSubview:image_badge2];
				[label_badge2 release];
				[image_badge2 release];
			}
#endif

			if (accessory != nil)
			{
				if ([accessory is:@"default"])
					cell.accessoryType = accessory_type;
				if ([accessory is:@"checkmark"])
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
				else if ([accessory is:@"none"])
					cell.accessoryType = UITableViewCellAccessoryNone;
				else
				{
					CGSize accessory_size = CGSizeFromString([data v:@"accessory-size"]);
					//UIButton* button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, k_ly_table_accessory_size, k_ly_table_accessory_size)] autorelease];
					UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
					//button.frame = CGRectMake(0, 0, k_ly_table_accessory_size, k_ly_table_accessory_size);
					button.frame = CGRectMake(0, 0, accessory_size.width, accessory_size.height);
					[button setImage:[UIImage imageNamed:accessory] forState:UIControlStateNormal];
					NSString* accessory_highlighted = [[data v:@"accessory-highlighted"] object_at_path:indexPath];
					if ([accessory_highlighted is:@""] == NO)
						[button setImage:[UIImage imageNamed:accessory_highlighted] forState:UIControlStateHighlighted];
					[button addTarget:self action:@selector(action_accessory:event:) forControlEvents:UIControlEventTouchUpInside];
					cell.accessoryView = button;
				}
			}
			else
			{
				if (accessory_name != nil)
					cell.accessoryView = [[[UIImageView alloc] initWithImageNamed:accessory_name] autorelease];
				else
					cell.accessoryType = accessory_type;
			}
			cell.selectionStyle = cell_selection;

			if (subviews != nil)
				for (UIView* subview in subviews)
					[cell addSubview:subview];
			if (gestures != nil)
				for (UIGestureRecognizer* gesture in gestures)
					[cell addGestureRecognizer:gesture];
		}

		if (([[texts object_at_index:indexPath.section] count] == 1) && (cell_bg != nil))
		{
			cell.backgroundView = [[UIImageView alloc] initWithImageNamed:cell_bg];
			cell.selectedBackgroundView = [[UIImageView alloc] initWithImageNamed:cell_bg_selected];
		}
		else if ((indexPath.row == 0) && (cell_bg_top != nil))
		{
			cell.backgroundView = [[UIImageView alloc] initWithImageNamed:cell_bg_top];
			cell.selectedBackgroundView = [[UIImageView alloc] initWithImageNamed:cell_bg_top_selected];
		}
		else if ((indexPath.row == ([[texts object_at_index:indexPath.section] count] - 1)) && (cell_bg_bottom != nil))
		{
			cell.backgroundView = [[UIImageView alloc] initWithImageNamed:cell_bg_bottom];
			cell.selectedBackgroundView = [[UIImageView alloc] initWithImageNamed:cell_bg_bottom_selected];
		}
		else if (cell_bg_middle != nil)
		{
			cell.backgroundView = [[UIImageView alloc] initWithImageNamed:cell_bg_middle];
			cell.selectedBackgroundView = [[UIImageView alloc] initWithImageNamed:cell_bg_middle_selected];
		}
		else if (cell_bg != nil)
		{
			cell.backgroundView = [[UIImageView alloc] initWithImageNamed:cell_bg];
			cell.selectedBackgroundView = [[UIImageView alloc] initWithImageNamed:cell_bg_selected];
		}

#if 0	//	moved to cell will display
		if (text_label.hidden == NO)
			[cell.textLabel copy_style:text_label];
		else
			cell.textLabel.backgroundColor = [UIColor clearColor];

		if (detail_label.hidden == NO)
			[cell.detailTextLabel copy_style:detail_label];
		else
			cell.detailTextLabel.backgroundColor = [UIColor clearColor];
#endif

		cell.showsReorderControl = [[data v:@"move-enabled"] boolValue];	
		if ([delegate respondsToSelector:@selector(table_provider:append_cell:at_path:)])
			objc_msgSend(delegate, @selector(table_provider:append_cell:at_path:), self, cell, indexPath);
		//[delegate perform_string:@"provider:cell:" with:self with:indexPath];
	}

	return cell;
}

#if 1
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}
#endif

- (void)action_accessory:(UIButton*)button event:(UIEvent*)event
{
	NSIndexPath* indexPath = [self.view indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.view]];
	if (indexPath == nil)
		return;
	[self tableView:self.view accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self get_additional_view:indexPath] != nil)
		return;

	if ((cell_bg_color_interlace != nil) && ((indexPath.row % 2) == 1))
		cell.backgroundColor = cell_bg_color_interlace;
	else
		cell.backgroundColor = cell_bg_color;

	if (text_label.hidden == NO)
		[cell.textLabel copy_style:text_label];
	else
		cell.textLabel.backgroundColor = [UIColor clearColor];

	if (detail_label.hidden == NO)
		[cell.detailTextLabel copy_style:detail_label];
	else
		cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}

#pragma mark actions

- (void)tableView:(UITableView*)table didSelectRowAtIndexPath:(NSIndexPath*)a_path
{
	if ([[data v:@"state"] is:@"refresh"])
		return;

	NSIndexPath* path;
	if (backup_dict != nil)
		path = [backup_dict objectForKey:a_path];
	else
		path = a_path;

	if ([self get_additional_view:path] != nil)
		return;

	current_path = path;
	current_text = [texts object_at_path:path];
	[table deselectRowAtIndexPath:a_path animated:YES];
	[delegate perform_string:@"tableView:didSelectRowAtIndexPath:" with:table with:path];
}

- (void)tableView:(UITableView*)table accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)a_path
{
	if ([[data v:@"state"] is:@"refresh"])
		return;

	NSIndexPath* path;
	if (backup_dict != nil)
		path = [backup_dict objectForKey:a_path];
	else
		path = a_path;

	//	NSLog(@"accessory tapped: %@", path);
	[delegate perform_string:@"tableView:accessoryButtonTappedForRowWithIndexPath:" with:table with:path];
}

#pragma index

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
	NSMutableArray*	array = [NSMutableArray arrayWithObjects:nil];
	NSString*		s;

	if (indexes.count == 0)
		return nil;
	else if (index_length > 0)
	{
		for (s in indexes)
			if (s.length <= index_length)
				[array addObject:s];
			else
				[array addObject:[[s substringToIndex:index_length] stringByAppendingString:@".."]];
		return array;
	}

	return indexes;
}

//	it's ok to use table index's default feature
#if 0
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return 0;
}
#endif

#pragma mark header

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	NSString* s = [headers object_at_index:section];
	if (s == nil)
		return 0;
	if ([s isEqualToString:@""])
		return 0;
	if ([[texts objectAtIndex:section] count] == 0)
		return 0;

	if (header_label.hidden == NO)
		return header_label.frame.size.height;
	else
		return table_header_height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [headers object_at_index:section];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UILabel* label;

	if (header_label.hidden == NO)
	{
		label = [[UILabel alloc] init];
		[label copy_style:header_label];
		label.text = [headers object_at_index:section];
		return label;
	}

	return nil;
}

#pragma mark footer

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	NSString* s = [footers object_at_index:section];
	if (s == nil)
		return 0;
	if ([s isEqualToString:@""])
		return 0;
	if ([[texts objectAtIndex:section] count] == 0)
		return 0;

	if (footer_label.hidden == NO)
		return footer_label.frame.size.height;
	else
		return table_footer_height;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	NSString* s = [footers object_at_index:section];
	if (s == nil)
		return 0;
	if ([s isEqualToString:@""])
		return 0;
	if ([[texts objectAtIndex:section] count] == 0)
		return 0;

	return [footers object_at_index:section];
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UILabel* label;

	NSString* s = [footers object_at_index:section];
	if (s == nil)
		return 0;
	if ([s isEqualToString:@""])
		return 0;
	if ([[texts objectAtIndex:section] count] == 0)
		return 0;

	if (footer_label.hidden == NO)
	{
		label = [[UILabel alloc] init];
		[label copy_style:footer_label];
		label.text = [footers object_at_index:section];
		return label;
	}

	return nil;
}

#pragma mark editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	for (NSIndexPath* path in [data v:@"edit-exclude"])
		if ((indexPath.section == path.section) && (indexPath.row == path.row))
			return NO;
	return can_edit;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSMutableArray* array;

	//	NSLog(@"commit editing style: %@", tableView);
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		array = [texts object_at_index:indexPath.section];
		if (array != nil)
			[array removeObjectAtIndex:indexPath.row];

		array = [details object_at_index:indexPath.section];
		if (array != nil)
			[array removeObjectAtIndex:indexPath.row];

		array = [images object_at_index:indexPath.section];
		if (array != nil)
			[array removeObjectAtIndex:indexPath.row];

		array = [image_urls object_at_index:indexPath.section];
		if (array != nil)
			[array removeObjectAtIndex:indexPath.row];

		array = [accessories object_at_index:indexPath.section];
		if (array != nil)
			[array removeObjectAtIndex:indexPath.row];

		[view delete_path:indexPath animation:animation_delete];

		//	modify source - TODO: support section
		if ([data v:@"source-data"] != nil)
		{
			[data setObject:[[data v:@"source-data"] i:indexPath.row] forKey:@"source-deleted-object"];
			//	[data setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"source-deleted-row"];
			//	NSLog(@"removing %i from %@", indexPath.row, [data v:@"source-data"]);
			[[data v:@"source-data"] removeObjectAtIndex:indexPath.row];
			if ([data v:@"source-filename"] != nil)
				[[data v:@"source-data"] writeToFile:[data v:@"source-filename"] atomically:YES];
			else if ([delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
				objc_msgSend(delegate, @selector(tableView:commitEditingStyle:forRowAtIndexPath:), view, editingStyle, indexPath);
		}

		[view reloadData];
	}
}

#pragma mark move

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	for (NSIndexPath* path in [data v:@"edit-exclude"])
		if ((indexPath.section == path.section) && (indexPath.row == path.row))
			return NO;
	return [[data v:@"move-enabled"] boolValue];	
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)path_old toIndexPath:(NSIndexPath *)path_new
{
	if (texts != nil)
		[texts exchange_path:path_old with:path_new];
	if (details != nil)
		[details exchange_path:path_old with:path_new];
	if (images != nil)
		[images exchange_path:path_old with:path_new];
	if (image_urls != nil)
		[image_urls exchange_path:path_old with:path_new];
	if (accessories != nil)
		[accessories exchange_path:path_old with:path_new];

#if 1
	//	modify source
	if ([data v:@"source-data"] != nil)
	{
		[[data v:@"source-data"] exchangeObjectAtIndex:path_old.row withObjectAtIndex:path_new.row];
		if ([data v:@"source-filename"] != nil)
			[[data v:@"source-data"] writeToFile:[data v:@"source-filename"] atomically:YES];
		else if ([delegate respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)])
			objc_msgSend(delegate, @selector(tableView:moveRowAtIndexPath:toIndexPath:), view, path_old, path_new);
	}
#endif
	//	[self refresh_animated];
}

#pragma mark dealloc

- (void)dealloc
{
	if (search_bar != nil)
		[search_bar release];
	if (backup_dict != nil)
		[self filter_remove];

	[additional_views release];

	[texts release];
	[details release];
	[images release];
	[image_urls release];
	[indexes release];
	[headers release];
	[footers release];
	[accessories release];

	[text_label release];
	[detail_label release];

	[super dealloc];
}

- (BOOL)load_from:(NSString*)filename
{
	NSMutableArray* array;

	if ([filename file_exists])
	{
		array = [NSMutableArray arrayWithContentsOfFile:[filename filename_document]];
		[texts release];
		[details release];
		[images release];
		[indexes release];
		[headers release];
		[footers release];
		[image_urls release];
		[accessories release];
		texts	= [[NSMutableArray alloc] initWithArray:[array objectAtIndex:0]];
		details	= [[NSMutableArray alloc] initWithArray:[array objectAtIndex:1]];
		images	= [[NSMutableArray alloc] initWithArray:[array objectAtIndex:2]];
		indexes	= [[NSMutableArray alloc] initWithArray:[array objectAtIndex:3]];
		headers	= [[NSMutableArray alloc] initWithArray:[array objectAtIndex:4]];
		footers	= [[NSMutableArray alloc] initWithArray:[array objectAtIndex:5]];
		image_urls	= [[NSMutableArray alloc] initWithArray:[array objectAtIndex:6]];
		accessories	= [[NSMutableArray alloc] initWithArray:[array objectAtIndex:7]];
		return YES;
	}
	return NO;
}

- (void)save_to:(NSString*)filename
{
	NSMutableArray* array = [NSMutableArray arrayWithObjects:
		texts, details, images, indexes, headers, footers, image_urls, accessories, nil];
	[array writeToFile:[filename filename_document] atomically:YES];
}

- (void)add_view:(UIView*)a_view section:(NSInteger)section row:(NSInteger)row
{
#if 1
	NSDictionary*	dict = [NSDictionary dictionaryWithObjectsAndKeys:
		a_view, @"view",
		[NSNumber numberWithInteger:section], @"section",
		[NSNumber numberWithInteger:row], @"row",
		nil];
#endif
	[additional_views addObject:dict];
}

- (void)add_view:(UIView*)a_view new_section:(NSInteger)section text:(NSString*)text
{
	[texts insertObject:[NSMutableArray arrayWithObjects:text, nil] atIndex:section];
	[self add_view:a_view section:section row:0];
}

- (void)add_view:(UIView*)a_view section:(NSInteger)section new_row:(NSInteger)row text:(NSString*)text
{
	[[texts objectAtIndex:section] insertObject:text atIndex:row];
	[self add_view:a_view section:section row:row];
}

- (UIView*)get_additional_view:(NSIndexPath*)path
{
	NSDictionary*	dict;

	for (dict in additional_views)
	{
		//	NSLog(@"TABLE checking additional view: %@", additional_views);
		if (([[dict objectForKey:@"section"] integerValue] == path.section) &&
			([[dict objectForKey:@"row"] integerValue] == path.row))
		{
			return [dict objectForKey:@"view"];
		}
	}
	return nil;
}

- (NSString*)text_for_path:(NSIndexPath*)path
{
	return [[texts objectAtIndex:path.section] objectAtIndex:path.row];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	//	NSLog(@"scrolled to: %@", NSStringFromCGPoint(scrollView.contentOffset));
	[delegate perform_string:@"scrollViewDidScroll:" with:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	//	NSLog(@"SCROLL end decelerating");
	[delegate perform_string:@"scrollViewDidEndDecelerating:" with:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	//	NSLog(@"SCROLL will drag");
	//	if (scroll_drag_begin != -44)
	scroll_drag_begin = view.contentOffset.y;
	[delegate perform_string:@"scrollViewWillBeginDragging:" with:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if ((search_bar != nil) && (view.contentOffset.y < 0))
	{
		//	NSLog(@"drag from %f", scroll_drag_begin);
		if (scroll_drag_begin == -44)
		{
			//	NSLog(@"to 0");
			//	view.contentOffset = CGPointMake(0, 0);
			[self performSelector:@selector(reset_content_offset:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.1];
		}
		else
		{
			//	NSLog(@"to -44: %f", scroll_drag_begin);
			[UIView begin_animations:0.3];
			view.contentOffset = CGPointMake(0, -44);
			[UIView commitAnimations];
		}
	}

	//	NSLog(@"SCROLL end dragging");
	if ([delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
		[delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)reset_content_offset:(NSNumber*)number
{
	BOOL b = [number boolValue];
	if (b)
		[UIView begin_animations:0.3];
	view.contentOffset = CGPointMake(0, 0);
	if (b)
		[UIView commitAnimations];
}

#pragma mark extra

- (void)add_header_item:(char)c count:(int)count
{
	if (count > 0)
	{
		[headers addObject:[NSString stringWithFormat:@"%c", c]];
		[header_counts addObject:[NSNumber numberWithInteger:count]];
	}
}

- (void)apply_alphabet
{
	int		i, ii, count, index;
	int		total = [[texts objectAtIndex:0] count];
	char	c;
	NSString*		name;
	NSMutableArray*	alphabet_texts = [NSMutableArray array];

	//	NSLog(@"reset headers");
	[header_counts removeAllObjects];
	[headers removeAllObjects];
	index = 0;

	//	build header: add numbers & others
	count = 0;
	for (i = index; i < total; i++)
	{
		//base = [self get_name_index:i];
		//name = [data objectAtIndex:base];
		name = [[texts objectAtIndex:0] objectAtIndex:i];
		c = [[name uppercaseString] characterAtIndex:0];
		if ((c < 65) || (c > 90 ))
		{
			count++;
			//	NSLog(@"count %c: %i", c, count);
		}
		else
		{
			//	NSLog(@"%i<>%i count of %c: %i", c, [[name uppercaseString] characterAtIndex:0], c, count);
			index += count;
			[self add_header_item:35 count:count];
			count = 0;
			break;
		}
	}

	//	build header: add alphabet
	for (c = 65; c < 65 + 26; c++)
	{
		//	NSLog(@"processing %c", c);
		count = 0;
		for (i = index; i < total; i++)
		{
			//	base = [self get_name_index:i];
			//	base = 1 + i * 8;
			//	name = [data objectAtIndex:base];
			name = [[texts objectAtIndex:0] objectAtIndex:i];
			//	NSLog(@"comparing %i: %i and %i - %@", base, c, [[name uppercaseString] characterAtIndex:0], name);
			if (c != [[name uppercaseString] characterAtIndex:0])
			{
				//	NSLog(@"%i<>%i count of %c: %i", c, [[name uppercaseString] characterAtIndex:0], c, count);
				index += count;
				[self add_header_item:c count:count];
				count = 0;
				break;
			}
			else
			{
				count++;
				//	NSLog(@"count %c: %i", c, count);
			}
		}
		if (count > 0)
		{
			index += count;
			[self add_header_item:c count:count];
		}
	}
	//	if (count == 0)
	//		[self add_header_item:35 count:total - index];
	//	else
		[self add_header_item:90 count:total - index];

	//	rebuild table - TODO: currently texts only, and texts should be already sorted, with numbers in front
	index = 0;
	for (i = 0; i < header_counts.count; i++)
	{
		count = [[header_counts objectAtIndex:i] intValue];
		[alphabet_texts addObject:[NSMutableArray arrayWithObjects:nil]];
		for (ii = 0; ii < count; ii++)
		{
			[[alphabet_texts objectAtIndex:i] addObject:[[texts objectAtIndex:0] objectAtIndex:index]];
			index++;
		}
	}
	[texts setArray:alphabet_texts];

	//	rebuild indexes
	[indexes setArray:headers];
	//	NSLog(@"headers: %@\n%@", headers, header_counts);
}

- (void)filter_apply:(NSString*)filter
{
	if (backup_texts == nil)
		backup_texts = [[NSMutableArray alloc] initWithArray:texts];
	if (backup_details == nil)
		backup_details = [[NSMutableArray alloc] initWithArray:details];
	[[data v:@"filter-array"] removeAllObjects];
	for (int section = 0; section < backup_texts.count; section++)
	{
		NSArray* array = [backup_texts objectAtIndex:section];
		for (int row = 0; row < array.count; row++)
		{
			NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:section];
			if (([[[backup_texts object_at_path:path] lowercaseString] has_substring:[filter lowercaseString]]) ||
				([[[backup_details object_at_path:path] lowercaseString] has_substring:[filter lowercaseString]]))
			{
				[[data v:@"filter-array"] addObject:path];
			}
		}
	}
	[self filter_apply_animated:NO];
}

- (void)filter_apply
{
	[self filter_apply_animated:YES];
}

- (void)filter_apply_animated:(BOOL)animated
{
	int section, row;
	int backup_section	= 0;
	int backup_row		= 0;
	NSArray*		array;
	//NSIndexPath*	path;
	//NSString*		s;

	if (backup_texts == nil)
		backup_texts = [[NSMutableArray alloc] initWithArray:texts];
	[texts removeAllObjects];
	if (backup_details == nil)
		backup_details = [[NSMutableArray alloc] initWithArray:details];
	[details removeAllObjects];
	if (backup_images == nil)
		backup_images = [[NSMutableArray alloc] initWithArray:images];
	[images removeAllObjects];
	if (backup_image_urls == nil)
		backup_image_urls = [[NSMutableArray alloc] initWithArray:image_urls];
	[image_urls removeAllObjects];
	if (backup_accessories == nil)
		backup_accessories = [[NSMutableArray alloc] initWithArray:accessories];
	[accessories removeAllObjects];
	if (backup_subviews == nil)
		backup_subviews = [[NSMutableDictionary alloc] initWithDictionary:[data v:@"cell-subviews"]];
	[[data v:@"cell-subviews"] removeAllObjects];
	//	TODO: hide sections with no items in
	
	if (backup_dict == nil)
		backup_dict = [[NSMutableDictionary alloc] init];
	else
		[backup_dict removeAllObjects];
	
	for (section = 0; section < backup_texts.count; section++)
	{
		array = [backup_texts objectAtIndex:section];

		[texts addObject:[NSMutableArray array]];
		[details addObject:[NSMutableArray array]];
		[images addObject:[NSMutableArray array]];
		[image_urls addObject:[NSMutableArray array]];
		[accessories addObject:[NSMutableArray array]];

		for (row = 0; row < array.count; row++)
		{
			NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:section];
			NSIndexPath* backup_path = [NSIndexPath indexPathForRow:backup_row inSection:backup_section];

#if 0
			if (([[[backup_texts object_at_path:path] lowercaseString] has_substring:[filter lowercaseString]]) ||
				([[[backup_details object_at_path:path] lowercaseString] has_substring:[filter lowercaseString]]))
#endif
			if ([[data v:@"filter-array"] containsObject:path])
			{
				[backup_dict setObject:path forKey:backup_path];

				if ([backup_texts object_at_path:path] != nil)
					[[texts objectAtIndex:backup_section] addObject:[backup_texts object_at_path:path]];
				if ([backup_details object_at_path:path] != nil)
					[[details objectAtIndex:backup_section] addObject:[backup_details object_at_path:path]];
				if ([backup_images object_at_path:path] != nil)
					[[images objectAtIndex:backup_section] addObject:[backup_images object_at_path:path]];
				if ([backup_image_urls object_at_path:path] != nil)
					[[image_urls objectAtIndex:backup_section] addObject:[backup_image_urls object_at_path:path]];
				if ([backup_accessories object_at_path:path] != nil)
					[[accessories objectAtIndex:backup_section] addObject:[backup_accessories object_at_path:path]];
				if ([backup_subviews objectForKey:path] != nil)
				{
					[[data v:@"cell-subviews"] setObject:[backup_subviews objectForKey:path] 
					  forKey:[NSIndexPath indexPathForRow:backup_row inSection:backup_section]];
				}

				backup_row++;
			}
		}
		backup_section++;
	}
	//scroll_drag_begin = -44;
	//view.contentOffset = CGPointMake(0, 0);
	[self performSelector:@selector(reset_content_offset:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.31];
	if (animated)
		[self refresh_animated];
	else
		[view reloadData];
	//	NSLog(@"subviews: %@", [data v:@"cell-subviews"]);
	//	NSLog(@"mapping: %@", backup_dict);
}

- (void)filter_remove
{
	[texts setArray:backup_texts];
	[details setArray:backup_details];
	[images setArray:backup_images];
	[image_urls setArray:backup_image_urls];
	[accessories setArray:backup_accessories];
	[[data v:@"cell-subviews"] setDictionary:backup_subviews];

	backup_texts = [backup_texts release_nil];
	backup_details = [backup_details release_nil];
	backup_images = [backup_images release_nil];
	backup_image_urls = [backup_image_urls release_nil];
	backup_accessories = [backup_accessories release_nil];
	backup_subviews = [backup_subviews release_nil];

	backup_dict = [backup_dict release_nil];
#if 0
	[backup_headers release_nil];
	[backup_footers release_nil];
#endif
	//[view reloadData];
	[self refresh_animated];
}

#pragma mark search

- (void)enable_search
{
	search_bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -44, view.frame.size.width, 44)];
	search_bar.delegate = self;
	search_bar.placeholder = @"Keywords here...";
	search_bar.tintColor = [UIColor blackColor];
	search_bar.barStyle = UIBarStyleBlack;
	search_bar.showsCancelButton = YES;
	[view addSubview:search_bar];
	view.contentInset = UIEdgeInsetsMake(search_bar.frame.size.height, 0, 0, 0);
}

- (void)searchBar:(UISearchBar*)search textDidChange:(NSString*)text
{
	//	NSLog(@"filter: %@", text);
	[self filter_apply:text];
	self.view.contentOffset = CGPointMake(0, -44);
#if 0
	[[self.texts objectAtIndex:0] removeObjectAtIndex:1];
	//	[self action_local_refresh];

	[table_local beginUpdates];
	[table_local deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationMiddle];
	[table_local endUpdates];
#endif
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[view addSubview:button_mask];
}

- (void)action_search_resign
{
	[self searchBarSearchButtonClicked:search_bar];
	//	[button_mask removeFromSuperview];
}

- (void)searchBarCancelButtonClicked:(UISearchBar*)search
{
	search.text = @"";
	[self filter_remove];
	[UIView begin_animations:0.3];
	self.view.contentOffset = CGPointMake(0, 0);
	[UIView commitAnimations];
	[search resignFirstResponder];
	[button_mask removeFromSuperview];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)search
{
	//	NSLog(@"search button clicked");
	[search resignFirstResponder];
	self.view.contentOffset = CGPointMake(0, -44);
	[button_mask removeFromSuperview];
}

#pragma mark async refresh

- (void)refresh_begin
{
	//	search_bar.hidden = YES;
	[data setValue:view.tableHeaderView forKey:@"backup-header"];
	[data setValue:view.tableFooterView forKey:@"backup-footer"];
	view.tableHeaderView = nil;
	view.tableFooterView = nil;
	view.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[data setValue:@"refresh" forKey:@"state"];
	//[view reloadData];
	[self refresh_animated];
}

- (void)refresh_end
{
	//	search_bar.hidden = NO;
	view.tableHeaderView = [data v:@"backup-header"];
	view.tableFooterView = [data v:@"backup-footer"];
	view.contentInset = UIEdgeInsetsMake(search_bar.frame.size.height, 0, 0, 0);
	view.contentOffset = CGPointMake(0, 0);
	[data setValue:@"" forKey:@"state"];
	//[view reloadData];
	[self refresh_animated];
}

- (void)refresh_animated
{
	[view beginUpdates];
	[view deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	[view insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	//[view reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	[view endUpdates];
}

@end
