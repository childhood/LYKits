#import "LYViewController.h"

@implementation UIViewController (LYViewController)

- (id)initWithView:(UIView*)a_view
{
	self = [super init];
	if (self != nil)
	{
		self.view = a_view;
	}
	return self;
}

#ifdef LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_LANDSCAPE
/*
-(UIDeviceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationLandscapeRight;
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
#endif

#ifdef LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATE
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	//	NSLog(@"should rotate: %i, %f, %f", rotatable, screen_width(), screen_height());
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		if (interfaceOrientation == UIInterfaceOrientationPortrait)
			return YES;
		else
#ifdef LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATEPHONE
			return YES;
#else
			return NO;
#endif
	}
	else
		return YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
#if 0
	//	NSLog(@"nav did rotate: %i - %@, delegate %@", fromInterfaceOrientation, self.delegate, self.delegate);
	NSObject <LYRotatableViewControllerDelegate>*	the_delegate = (NSObject<LYRotatableViewControllerDelegate>*)self.delegate;
	if (the_delegate == nil)
		return;
	//	NSLog(@"delegate: %@", the_delegate);
	//	this is a workaround for the LYImagePickerController recursive delegate problem
	if ([the_delegate isKindOfClass:[UIImagePickerController class]])
		return;
	if ([the_delegate respondsToSelector:@selector(didRotateFromInterfaceOrientation:)])
		[the_delegate didRotateFromInterfaceOrientation:fromInterfaceOrientation];
#endif
}
#endif	//	TODO: cleanup

#ifdef LY_ENABLE_CATEGORY_VIEWCONTROLLER_ROTATE
- (id)init
{
	//NSLog(@"initializing view controller..");
	delegate = nil;
	rotatable = YES;
	self = [super init];
	return self;
}
- (void)set_delegate:(id)an_obj
{
	delegate = an_obj;
}
- (BOOL)rotatable
{
	return rotatable;
}
- (void)set_rotatable:(BOOL)b
{
	rotatable = b;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	NSLog(@"view controller %@: should rotate: %i", self, rotatable);
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		if (interfaceOrientation == UIInterfaceOrientationPortrait)
			return YES;
		else
#ifdef LY_ENABLE_CATEGORY_VIEWCONTROLLER_ROTATEPHONE
			return YES;
#else
			return NO;
#endif
	}
	else
		return YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if (delegate == nil)
		return;
	if ([delegate respondsToSelector:@selector(didRotateFromInterfaceOrientation:)])
		[delegate didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}
#endif
@end


@implementation LYRightViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
@end
