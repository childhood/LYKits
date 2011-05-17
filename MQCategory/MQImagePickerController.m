#import "MQImagePickerController.h"

@implementation UIImagePickerController (MQImagePickerController)

- (void)set_mq_image:(UIImageView*)an_image
{
	mq_image = an_image;
}

- (void)set_mq_delegate:(id)a_delegate
{
	mq_delegate = a_delegate;
}

- (void)get_image_nav:(UINavigationController*)nav image:(UIImageView*)view
{
	[self get_image_nav:nav image:view delegate:nil];
}

- (void)get_image_nav:(UINavigationController*)nav image:(UIImageView*)view delegate:(id)obj
{
	mq_delegate = obj;

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
			mq_nav = nav;
		}
		else
		{
			id	popover_controller = [NSClassFromString(@"UIPopoverController") class];
			if ((popover_controller != nil) && (is_pad()))
				mq_pop = [[popover_controller alloc] initWithContentViewController:self];
			[mq_pop presentPopoverFromRect:nav.view.frame inView:nav.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	}

	mq_image = view;
}

- (void)imagePickerController:(UIImagePickerController *)a_picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage* image = [info valueForKey:@"UIImagePickerControllerEditedImage"];
	if (image == nil)
		image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
	[mq_image setImage:image];
	[self mq_dismiss];

	if (mq_delegate != nil)
		[mq_delegate performSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:) withObject:a_picker withObject:info];
	else
		[self release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)a_picker
{
	[self mq_dismiss];
	if (mq_delegate != nil)
		[mq_delegate performSelector:@selector(imagePickerControllerDidCancel:) withObject:a_picker];
	else
		[self release];
}

- (void)mq_dismiss
{
	if (is_phone())
	{
		[mq_nav dismissModalViewControllerAnimated:YES];
	}
	else
	{
		[mq_pop dismissPopoverAnimated:YES];
		[mq_pop release];
	}
}

@end
