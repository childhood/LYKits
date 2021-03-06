#import "LYImageView.h"

@implementation UIImageView (LYImageView)

- (id)initWithImageNamed:(NSString*)filename
{
	self = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
	return self;
}

- (void)copy_style:(UIImageView*)target
{
	if (target.hidden == NO)
	{
		[super copy_style:target];
		self.image					= target.image;
		self.highlightedImage		= target.highlightedImage;
	}
}

- (void)draw_frame_with_r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a width:(CGFloat)width
{
	CGRect inner_frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:inner_frame];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextClearRect(ctx, inner_frame);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineWidth(ctx, width);
    CGContextSetRGBStrokeColor(ctx, r, g, b, a);
	CGContextStrokeRectWithWidth(ctx, inner_frame, 1.0);

    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)draw_cross_with_r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a width:(CGFloat)width
{
	CGRect inner_frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:inner_frame];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
	//	CGContextClearRect(ctx, inner_frame);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineWidth(ctx, width);
    CGContextSetRGBStrokeColor(ctx, r, g, b, a);

    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, width, width);
    CGContextAddLineToPoint(ctx, inner_frame.size.width - width * 2, inner_frame.size.height - width * 2);
    CGContextMoveToPoint(ctx, width, inner_frame.size.height - width * 2);
    CGContextAddLineToPoint(ctx, inner_frame.size.width - width * 2, width);
    CGContextStrokePath(ctx);
    
	self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)draw_frame_black
{
	[self draw_frame_with_r:0 g:0 b:0 a:1 width:1];
}

- (void)draw_frame_white
{
	[self draw_frame_with_r:1 g:1 b:1 a:1 width:1];
}

- (void)draw_cross_black
{
	[self draw_cross_with_r:0 g:0 b:0 a:1 width:1];
}

- (void)draw_cross_white
{
	[self draw_cross_with_r:1 g:1 b:1 a:1 width:1];
}

- (void)clock_flip
{
	CGFloat f = [[[ly data] v:@"animation-clock-flip-duration"] floatValue];
	//	NSLog(@"animation %f", f);

	if ([self associated:@"ly-clock-flip-lock"] != nil)
		return;
	[self associate:@"ly-clock-flip-lock" with:@"locked"];

#if 1
	UIImage* image1;
	UIImage* image2;
	//image1 = [[self.image image_with_size:self.frame.size] retain];
	//image2 = [[self.highlightedImage image_with_size:self.frame.size] retain];
	image1 = ly_retain([self.image image_with_size:self.frame.size]);
	image2 = ly_retain([self.highlightedImage image_with_size:self.frame.size]);
	//[self.image release];
	//[self.highlightedImage release];
	//self.image = nil;
	//self.highlightedImage = nil;
	self.image = image1;
	self.highlightedImage = image2;
#endif
	//	[UIDevice log_memory_usage];

	UIImage* image_front_top;
	//UIImage* image_front_bottom;
	UIImage* image_back_top;
	UIImage* image_back_bottom;
	CGSize size;
	//CGFloat scale = [[UIScreen mainScreen] scale];

	size = CGSizeMake([self.image size].width, [self.image size].height/2);
	//size = CGSizeMake(self.frame.size.width, self.frame.size.height / 2);
	//UIGraphicsBeginImageContext(size);
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	[self.image drawAtPoint:CGPointMake(0.0, 0.0)];
	//image_front_top = [UIGraphicsGetImageFromCurrentImageContext() retain];			
	image_front_top = ly_retain(UIGraphicsGetImageFromCurrentImageContext());
	//[self.image drawAtPoint:CGPointMake(0.0, -[self.image size].height/2)];
	//image_front_bottom = [UIGraphicsGetImageFromCurrentImageContext() retain];			
	UIGraphicsEndImageContext();

	size = CGSizeMake([self.highlightedImage size].width, [self.highlightedImage size].height/2);
	//UIGraphicsBeginImageContext(size);
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	[self.highlightedImage drawAtPoint:CGPointMake(0.0, 0.0)];
	//image_back_top = [UIGraphicsGetImageFromCurrentImageContext() retain];			
	image_back_top = ly_retain(UIGraphicsGetImageFromCurrentImageContext());
	[self.highlightedImage drawAtPoint:CGPointMake(0.0, -[self.highlightedImage size].height/2)];
#if 0
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, size.height / 2);
	CGContextConcatCTM(context, flipVertical);  
#endif
	//image_back_bottom = [UIGraphicsGetImageFromCurrentImageContext() retain];			
	image_back_bottom = ly_retain(UIGraphicsGetImageFromCurrentImageContext());
	UIGraphicsEndImageContext();

	UIImageView* view_top = [[UIImageView alloc] initWithImage:image_back_top];
	[self addSubview:view_top];
	[self associate:@"ly-clock-flip-top" with:view_top];

	UIImageView* view_animation = [[UIImageView alloc] initWithImage:image_front_top];
	[view_animation set_y:size.height / 2];
	[self addSubview:view_animation];
	[self associate:@"ly-clock-flip-animation" with:view_animation];

	UIImageView* view_animation2 = [[UIImageView alloc] initWithImage:[UIImage image_flip_vertically:image_back_bottom]];
	//[image_back_bottom release];
	ly_release(image_back_bottom);
	[view_animation2 set_y:size.height / 2];
	[self associate:@"ly-clock-flip-animation2" with:view_animation2];

#if 1
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = 0.001;
	//view_animation.layer.sublayerTransform = transform;
	view_animation.layer.anchorPoint = CGPointMake(0.5, 1.0);
	//view_animation.layer.transform = CATransform3DMakeRotation(0.7, 1.0, 0.0, 0.0);
	CABasicAnimation *topAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
	topAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeRotation(0, 1, 0, 0), transform)];
	topAnim.duration = f / 2;
	topAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeRotation(-M_PI_2, 1, 0, 0), transform)];
	topAnim.delegate = self;
	topAnim.removedOnCompletion = NO;
	topAnim.fillMode = kCAFillModeForwards;
	[view_animation.layer addAnimation:topAnim forKey:@"topAnim"];
	[self performSelector:@selector(clock_flip_half) withObject:nil afterDelay:f / 2];
	[self performSelector:@selector(clock_flip_end) withObject:nil afterDelay:f];
#endif
}

- (void)clock_flip_half
{
	CGFloat f = [[[ly data] v:@"animation-clock-flip-duration"] floatValue];
	UIImageView* view_animation1 = [self associated:@"ly-clock-flip-animation"];
	[view_animation1 removeFromSuperview];
	//[view_animation1.image release];
	ly_release(view_animation1.image);
	//[view_animation1 release];
	ly_release(view_animation1);

	UIImageView* view_animation = [self associated:@"ly-clock-flip-animation2"];
	[self addSubview:view_animation];

	CATransform3D transform = CATransform3DIdentity;
	float zDistance = 1000;
	transform.m34 = 1.0 / -zDistance;	
	//view_animation.layer.sublayerTransform = transform;
	view_animation.layer.anchorPoint = CGPointMake(0.5, 1.0);
	//view_animation.layer.transform = CATransform3DMakeRotation(0.7, 1.0, 0.0, 0.0);
	CABasicAnimation *topAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
	topAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeRotation(-M_PI_2, 1, 0, 0), transform)];
	topAnim.duration = f / 2;
	topAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeRotation(-M_PI_2 * 2, 1, 0, 0), transform)];
	topAnim.delegate = self;
	topAnim.removedOnCompletion = NO;
	topAnim.fillMode = kCAFillModeForwards;
	[view_animation.layer addAnimation:topAnim forKey:@"topAnim"];
}

- (void)clock_flip_end
{
	UIImageView* view_top = [self associated:@"ly-clock-flip-top"];
	[view_top removeFromSuperview];
	//[view_top.image release];
	ly_release(view_top.image);
	//[view_top release];
	ly_release(view_top);

	UIImageView* view_animation = [self associated:@"ly-clock-flip-animation2"];
	[view_animation removeFromSuperview];
	//[view_animation.image release];
	//[view_animation release];
	ly_release(view_animation);

	UIImage* image = self.highlightedImage;
	self.highlightedImage = self.image;
	self.image = image;

	[self associate:@"ly-clock-flip-lock" with:nil];
}

@end
