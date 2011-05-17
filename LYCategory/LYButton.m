#import "LYButton.h"

@implementation UIButton (LYButton)

#pragma mark state control

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
	[self switch_state:UIControlStateNormal state:UIControlStateHighlighted];
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
