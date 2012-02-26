#import "LYButton.h"

@implementation UIButton (LYButton)

#pragma mark binding

- (void)bind_setting:(NSString*)key target:(id)target action:(NSString*)action
{
	//	self.selected = [key setting_bool];
	[self associate:@"ly-setting-name" with:key];
	[self associate:@"ly-setting-target" with:target];
	[self associate:@"ly-setting-action" with:action];
	[self addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];
	[self reload_setting];
}

- (void)reload_setting
{
	self.selected = [[self associated:@"ly-setting-name"] setting_bool];
}

- (void)auto_resize
{
	CGSize size;
	self.titleLabel.textAlignment = UITextAlignmentCenter;
	self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	self.titleLabel.font = [self.titleLabel.font fontWithSize:[ly screen_width]];
	do {
		self.titleLabel.font = [self.titleLabel.font fontWithSize:self.titleLabel.font.pointSize - 1];
		size = [[self titleForState:UIControlStateNormal] sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width * 0.9, INT_MAX) lineBreakMode:self.titleLabel.lineBreakMode];
	}	while ((size.height > self.frame.size.height * 0.9) && (self.titleLabel.font.pointSize > 4));
}

#pragma mark state control

- (void)pressed
{
	self.selected = !self.selected;
	[[self associated:@"ly-setting-name"] setting_bool:self.selected];
	//	NSLog(@"toggle: %@ - %i", [self associated:@"ly-setting-name"], self.selected);
	[[self associated:@"ly-setting-target"] perform_string:[self associated:@"ly-setting-action"] with:self];
}

- (void)switch_state:(UIControlState)state1 state:(UIControlState)state2
{
	NSString*	title;
	UIColor*	title_color;
	UIColor*	title_shadow;
	UIImage*	image;
	UIImage*	image_bg;
	NSString*	title2;
	UIColor*	title_color2;
	UIColor*	title_shadow2;
	UIImage*	image2;
	UIImage*	image_bg2;
#if 0
	NSNumber*	flipped;

	flipped = [self associated:@"flipped"];
	if (flipped == nil)
		flipped = [NSNumber numberWithBOOL:NO];
	[self associate:@"flipped" with:flipped];
#endif

	title			= [self titleForState:state1];
	title_color		= [self titleColorForState:state1];
	title_shadow	= [self titleShadowColorForState:state1];
	image			= [self imageForState:state1];
	image_bg		= [self backgroundImageForState:state1];

	title2			= [self titleForState:state2];
	title_color2		= [self titleColorForState:state2];
	title_shadow2	= [self titleShadowColorForState:state2];
	image2			= [self imageForState:state2];
	image_bg2		= [self backgroundImageForState:state2];

	[self setTitle:title2 forState:state1];
	[self setTitleColor:title_color2 forState:state1];
	[self setTitleShadowColor:title_shadow2 forState:state1];
	[self setImage:image2 forState:state1];
	[self setBackgroundImage:image_bg2 forState:state1];

	[self setTitle:title forState:state2];
	[self setTitleColor:title_color forState:state2];
	[self setTitleShadowColor:title_shadow forState:state2];
	[self setImage:image forState:state2];
	[self setBackgroundImage:image_bg forState:state2];

	return;
}

- (void)switch_state
{
	self.selected = !self.selected;
	//[self switch_state:UIControlStateNormal state:UIControlStateHighlighted];
}

#pragma mark generic setters

- (void)set_title:(NSString*)title
{
	if (title != nil)
	{
		[self setTitle:title forState:UIControlStateNormal];
		[self setTitle:title forState:UIControlStateHighlighted];
		[self setTitle:title forState:UIControlStateSelected];
		[self setTitle:title forState:UIControlStateDisabled];
	}
}

- (void)set_image_named:(NSString*)filename
{
	if (filename != nil)
	{
		[self setImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
		[self setImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
	}
	else
	{
		[self setImage:nil forState:UIControlStateNormal];
		[self setImage:nil forState:UIControlStateHighlighted];
	}
}

- (void)set_background_named:(NSString*)filename
{
	//	UIImage* image = [UIImage imageNamed:filename];
	//	NSLog(@"filename: %@", filename);
	//	NSLog(@"image: %@", image);
	if (filename != nil)
	{
		[self setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
	}
	else
	{
		[self setBackgroundImage:nil forState:UIControlStateNormal];
		[self setBackgroundImage:nil forState:UIControlStateHighlighted];
	}
}

@end
