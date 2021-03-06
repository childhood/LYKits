#import "LYNavigationController.h"

@implementation UINavigationController (LYNavigationController)
- (void)push:(UIViewController*)controller transition:(UIViewAnimationTransition)transition
{
	[UIView beginAnimations:nil context:NULL];
	[self pushViewController:controller animated:NO];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationBeginsFromCurrentState:YES];        
	[UIView setAnimationTransition:transition forView:self.view cache:NO];
	[UIView commitAnimations];
}
- (void)pop_transition:(UIViewAnimationTransition)transition
{
	[UIView beginAnimations:nil context:NULL];
	[self popViewControllerAnimated:NO];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationBeginsFromCurrentState:YES];        
	[UIView setAnimationTransition:transition forView:self.view cache:NO];
	[UIView commitAnimations];
}
#ifdef LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_LANDSCAPE
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
#endif

#ifdef LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATE
//@implementation UINavigationController (LYNavigationController)
/*
- (id)init
{
	NSLog(@"init nav");
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	rotatable = YES;
	self = [super init];
	return self;
}
- (id)initWithFrame:(CGRect)rect
{
	self = [super initWithFrame:rect];
	if (self != nil)
	{
		NSLog(@"init nav frame");
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		rotatable = YES;
	}
	return self;
}
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	self = [super initWithNibName:nibName bundle:nibBundle];
	if (self != nil)
	{
		NSLog(@"init nav nib");
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		rotatable = YES;
	}
	return self;
}
- (BOOL)rotatable
{
	return rotatable;
}
- (void)set_rotatable:(BOOL)b
{
	rotatable = b;
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	//NSLog(@"NAV should rotate: %i, %f, %f", interfaceOrientation, screen_width(), screen_height());
	//return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
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
}
//@end
#endif
@end
