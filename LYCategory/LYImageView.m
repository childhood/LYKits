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

@end
