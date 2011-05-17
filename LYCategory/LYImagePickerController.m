#import "LYImagePickerController.h"

@implementation UIImagePickerController (LYImagePickerController)

- (void)set_ly_image:(UIImageView*)an_image
{
	ly_image = an_image;
}

- (void)set_ly_delegate:(id)a_delegate
{
	ly_delegate = a_delegate;
}

- (void)get_image_nav:(UINavigationController*)nav image:(UIImageView*)view
{
	[self get_image_nav:nav image:view delegate:nil];
}

- (void)get_image_nav:(UINavigationController*)nav image:(UIImageView*)view delegate:(id)obj
{
	ly_delegate = obj;

	//	self.allowsEditing = YES;
	self.delegate = (UIImagePickerController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)self;

	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO)
	{
		[@"Sorry, photo library is not supported on this device." show_alert_title:@"Library Not Available"];
	}
	else
	{
		//self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		if (is_phone())
		{
			[nav presentModalViewController:self animated:YES];
			ly_nav = nav;
		}
		else
		{
			id	popover_controller = [NSClassFromString(@"UIPopoverController") class];
			if ((popover_controller != nil) && (is_pad()))
				ly_pop = [[popover_controller alloc] initWithContentViewController:self];
			[ly_pop presentPopoverFromRect:nav.view.frame inView:nav.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	}

	ly_image = view;
}

- (void)imagePickerController:(UIImagePickerController *)a_picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage* image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
	if (image == nil)
		image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
	[ly_image setImage:image];
	[self ly_dismiss];

	if (ly_delegate != nil)
		[ly_delegate performSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:) withObject:a_picker withObject:info];
	else
		[self release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)a_picker
{
	[self ly_dismiss];
	if (ly_delegate != nil)
		[ly_delegate performSelector:@selector(imagePickerControllerDidCancel:) withObject:a_picker];
	else
		[self release];
}

- (void)ly_dismiss
{
	if (is_phone())
	{
		[ly_nav dismissModalViewControllerAnimated:YES];
	}
	else
	{
		[ly_pop dismissPopoverAnimated:YES];
		[ly_pop release];
	}
}

@end
