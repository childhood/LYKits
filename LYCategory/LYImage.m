#import "LYImage.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

@implementation UIImage (LYImage)

- (UIImage*)apply_orientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch ((int)self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }

    switch ((int)self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)image_flip_vertically:(UIImage *)originalImage
{
	@synchronized(self)
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
}

+ (UIImage *)image_flip_horizontally:(UIImage *)originalImage
{
	@synchronized(self)
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

- (UIImage*)image_with_shadow
{
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, self.size.width + 10, self.size.height + 10, 
			CGImageGetBitsPerComponent(self.CGImage), 0, colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);

    CGContextSetShadowWithColor(shadowContext, CGSizeMake(5, -5), 5, [UIColor blackColor].CGColor);
    CGContextDrawImage(shadowContext, CGRectMake(0, 10, self.size.width, self.size.height), self.CGImage);

    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);

    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);

    return shadowedImage;
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

/*
	UIImage template, // the badge is drawn on this image
	string text, // this text is drawn in the badge
	PointF textCenter, // center of the badge relative to the template,
	float textHeight, // eight of the text
	string fontName // the badge font to use
*/
#if 0
- (UIImage*)badge_on:(UIImage*)template text:(NSString*)text at:(CGPoint*)textCenter height:(float)textHeight
{
	UIGraphicsBeginImageContext(CGSizeMake(30, 30));
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextTranslateCTM(context, 0f, 0f);
	CGContextScaleCTM(context, 0.75f, 0.75f);
	CGContextDrawImage(context, CGRectMake(0, 0, template.size.width, template.size.height), template.CGImage);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	CGContextTranslateCTM(context, 0f, -template.size.height);

	// set up text drawing parameters
	//	context.SelectFont(fontName, textHeight, CGTextEncoding.MacRoman);
	CGContextSetTextDrawingMode(context, kCGTextInvisible);

	// compute the width of the text.
	float startX = CGContextGetTextPosition(context);
	CGContextShowText(context, text );
	float textWidth = CGContextGetTextPosition(context) - startX;

	float radius = textHeight / 2.0f;
	float a = Convert.ToSingle(Math.PI / 2f);
	float b = Convert.ToSingle(3f * Math.PI / 2f);
	context.SetFillColorWithColor (UIColor.Red.CGColor);

	context.AddArc( textCenter.X - (textWidth / 2) + (radius/2), textCenter.Y, radius, a, b, false);
	context.AddArc( textCenter.X + (textWidth / 2) - (radius/2), textCenter.Y, radius, b, a, false);
	context.ClosePath();
	context.FillPath();
	context.SetBlendMode( CGBlendMode.Normal);
	context.SelectFont(fontName, textHeight, CGTextEncoding.MacRoman);
	context.SetTextDrawingMode(CGTextDrawingMode.Fill);
	context.SetFillColorWithColor (UIColor.White.CGColor);
	context.ShowTextAtPoint( textCenter.X - (textWidth / 2), textCenter.Y - ( textHeight/2) +2,text);
	return UIGraphics.GetImageFromCurrentImageContext();
}
#endif

- (UIImage*)image_filter:(NSString*)filter_name dict:(NSDictionary*)dict
{
	CIImage* input_image = [[CIImage alloc] initWithImage:self];
	[input_image autorelease];
	//CIContext* context = [CIContext contextWithOptions:nil];
	//return [UIImage imageWithCGImage:[context createCGImage:input_image fromRect:input_image.extent]];

	switch ((int)self.imageOrientation)
	{
		case UIImageOrientationUp:
			NSLog(@"up");
			break;
		case UIImageOrientationDown:
			NSLog(@"down");
			input_image = [input_image imageByApplyingTransform:CGAffineTransformMakeRotation(M_PI)];
			break;
		case UIImageOrientationLeft:
			NSLog(@"left");
			input_image = [input_image imageByApplyingTransform:CGAffineTransformMakeRotation(M_PI / 2)];
			break;
		case UIImageOrientationRight:
			NSLog(@"right");
			input_image = [input_image imageByApplyingTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
			break;
	}

	CIFilter* filter = [CIFilter filterWithName:filter_name];
	[filter setDefaults];
	[filter setValue:input_image forKey:@"inputImage"];
	for (NSString* key in dict)
		[filter setValue:[dict objectForKey:key] forKey:key];

	CIImage* output = [filter valueForKey:@"outputImage"];
	CIContext* context = [CIContext contextWithOptions:nil];
	CGImageRef ref = [context createCGImage:output fromRect:output.extent];
	UIImage* ret = [UIImage imageWithCGImage:ref];

	CGImageRelease(ref);

	return ret;
	//return [UIImage imageWithCIImage:output];
}

- (UIImage*)image_filter:(NSString*)filter_name key:(NSString*)key v:(id)value
{
	return [self image_filter:filter_name dict:[NSDictionary dictionaryWithObjectsAndKeys:value, key, nil]];
}

- (UIImage*)image_filter:(NSString*)filter_name key:(NSString*)key float:(CGFloat)f
{
	return [self image_filter:filter_name key:key v:[NSNumber numberWithFloat:f]];
}

- (UIImage*)image_filter:(NSString*)filter_name key:(NSString*)key image:(UIImage*)image
{
	CIImage* ci = [[CIImage alloc] initWithImage:image];
	UIImage* ret = [self image_filter:filter_name key:key v:ci];
	[ci release];
	return ret;
}

- (UIImage*)image_filter:(NSString*)filter_name key:(NSString*)key r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a
{
	return [self image_filter:filter_name key:key v:[CIColor colorWithRed:r green:g blue:b alpha:a]];
}

@end
