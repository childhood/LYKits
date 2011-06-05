#import "LYImage.h"

@implementation UIImage (LYImage)

+ (UIImage *)image_flip_vertically:(UIImage *)originalImage
{
	UIImageView *tempImageView = [[UIImageView alloc] initWithImage:originalImage];

	UIGraphicsBeginImageContext(tempImageView.frame.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, tempImageView.frame.size.height);
	CGContextConcatCTM(context, flipVertical);  

	[tempImageView.layer renderInContext:context];

	UIImage *flipedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[tempImageView release];

	return flipedImage;
}

+ (UIImage *)image_flip_horizontally:(UIImage *)originalImage
{
	UIImageView *tempImageView = [[UIImageView alloc] initWithImage:originalImage];

	UIGraphicsBeginImageContext(tempImageView.frame.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGAffineTransform flipVertical = CGAffineTransformMake(-1, 0, 0, 1, tempImageView.frame.size.width, 0);
	CGContextConcatCTM(context, flipVertical);  

	[tempImageView.layer renderInContext:context];

	UIImage *flipedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[tempImageView release];

	return flipedImage;
}

- (UIImage*)image_with_size_aspect:(CGSize)newSize
{
	CGFloat	w	= self.size.width;
	CGFloat	h	= self.size.height;
	CGFloat	ww	= newSize.width;
	CGFloat	hh	= newSize.height;

	if (w > h)
	{
		h = h * hh / w;
		w = ww;
	}
	else
	{
		w = w * ww / h;
		h = hh;
	}
	//	NSLog(@"new image size: %f, %f", w, h);
	UIGraphicsBeginImageContext(newSize);
	[[UIImage image_flip_horizontally:self] drawInRect:CGRectMake((ww - w) / 2, (hh - h) / 2, w, h)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();
	//	NSLog(@"new image: %@", newImage);

	return newImage;
}

- (UIImage*)image_with_size_aspect_fill:(CGSize)newSize
{
	CGFloat	w	= self.size.width;
	CGFloat	h	= self.size.height;
	CGFloat	ww	= newSize.width;
	CGFloat	hh	= newSize.height;

	if (w < h)
	{
		h = h * hh / w;
		w = ww;
	}
	else
	{
		w = w * ww / h;
		h = hh;
	}
	//	NSLog(@"new image size: %f, %f", w, h);
	UIGraphicsBeginImageContext(newSize);
	[self drawInRect:CGRectMake((ww - w) / 2, (hh - h) / 2, w, h)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();
	//	NSLog(@"new image: %@", newImage);

	return newImage;
}

- (UIImage*)image_with_size:(CGSize)newSize
{
	UIGraphicsBeginImageContext(newSize);
	[self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();
	return newImage;
}

- (UIImage*)image_overlay_center:(UIImage*)another_image
{
	CGRect rect = CGRectMake((self.size.width - another_image.size.width) / 2, 
			(self.size.height - another_image.size.height) / 2, 
			another_image.size.width,
			another_image.size.height);
	return [self image_overlay:another_image rect:rect mode:kCGBlendModeNormal alpha:1];
}

- (UIImage*)image_overlay:(UIImage*)another_image rect:(CGRect)a_rect mode:(CGBlendMode)mode alpha:(CGFloat)alpha
{
	UIGraphicsBeginImageContext(self.size);  

	CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);

	[self drawInRect:rect];  
	[another_image drawInRect:a_rect blendMode:mode alpha:alpha];

	UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();  
	UIGraphicsEndImageContext();  

	return ret;
}

- (UIImage*)image_blur_at:(CGPoint)point
{
	CGRect             bnds = CGRectZero;
	UIImage*           copy = nil;
	CGContextRef       ctxt = nil;
	CGImageRef         imag = self.CGImage;
	CGRect             rect = CGRectZero;
	CGAffineTransform  tran = CGAffineTransformIdentity;
	int                indx = 0;
	CGFloat	radius = 100;

	rect.size.width  = CGImageGetWidth(imag);
	rect.size.height = CGImageGetHeight(imag);

	bnds = rect;

	UIGraphicsBeginImageContext(bnds.size);
	ctxt = UIGraphicsGetCurrentContext();

	// Cut out a sample out the image
	CGRect fillRect = CGRectMake(point.x - radius, point.y - radius, radius * 2, radius * 2);
	CGImageRef sampleImageRef = CGImageCreateWithImageInRect(self.CGImage, fillRect);

	// Flip the image right side up & draw
	CGContextSaveGState(ctxt);

	CGContextScaleCTM(ctxt, 1.0, -1.0);
	CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
	CGContextConcatCTM(ctxt, tran);

	CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);

	// Restore the context so that the coordinate system is restored
	CGContextRestoreGState(ctxt);

	// Cut out a sample image and redraw it over the source rect
	// several times, shifting the opacity and the positioning slightly
	// to produce a blurred effect
	for (indx = 0; indx < 5; indx++) {
		CGRect myRect = CGRectOffset(fillRect, 0.0 * indx, 0.0 * indx);
		CGContextSetAlpha(ctxt, 0.2 * indx);
		CGContextScaleCTM(ctxt, 1.0, -1.0);
		CGContextDrawImage(ctxt, myRect, sampleImageRef);
	}

	copy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return copy;
}

@end
