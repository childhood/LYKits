#import "MQColor.h"

@implementation UIColor (MQColor)

+ (UIColor*)colorNamed:(NSString*)filename
{
	return [UIColor colorWithPatternImage:[UIImage imageNamed:filename]];
}

- (UIColor*)invert
{
	CGFloat r = [self get_red];
	CGFloat g = [self get_green];
	CGFloat b = [self get_blue];
	CGFloat a = [self get_alpha];
	//	NSLog(@"%f, %f, %f, %f", r, g, b, a);
	return [UIColor colorWithRed:1.0 - r green:1.0 - g blue:1.0 - b alpha:a];
}

- (UIColor*)dark_color:(CGFloat)l
{
	CGFloat r = [self get_red];
	CGFloat g = [self get_green];
	CGFloat b = [self get_blue];
	CGFloat a = [self get_alpha];
	//return [UIColor blackColor];
	return [[UIColor colorWithRed:r/l green:g/l blue:b/l alpha:a] retain];
}

- (UIColor*)light_color:(CGFloat)l
{
	CGFloat r = [self get_red];
	CGFloat g = [self get_green];
	CGFloat b = [self get_blue];
	CGFloat a = [self get_alpha];
	//return [UIColor whiteColor];
	return [[UIColor colorWithRed:r+(1.0-r)/l green:g+(1.0-g)/l blue:b+(1.0-b)/l alpha:a] retain];
}

- (CGFloat)get_component:(NSInteger)index
{
	CGFloat	r, g, b, a;
	int		numComponents = CGColorGetNumberOfComponents(self.CGColor);
	const	CGFloat *components = CGColorGetComponents(self.CGColor);

	if (numComponents == 4)
	{
		r = components[0];
		g = components[1];
		b = components[2];
		a = components[3];
	}
	else if (numComponents == 2)
	{
		r = components[0];
		g = components[0];
		b = components[0];
		a = components[1];
	}
	else
		return -1;

	switch (index)
	{
		case 0:
			return r;
		case 1:
			return g;
		case 2:
			return b;
		case 3:
			return a;
	}

	return -1;
}

- (CGFloat)get_red
{
	return [self get_component:0];
}

- (CGFloat)get_green
{
	return [self get_component:1];
}

- (CGFloat)get_blue
{
	return [self get_component:2];
}

- (CGFloat)get_alpha
{
	return [self get_component:3];
}

@end
