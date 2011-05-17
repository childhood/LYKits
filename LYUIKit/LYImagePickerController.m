#import "LYImagePickerController.h"

@implementation LYImagePickerController

@synthesize background_titles;
@synthesize background_filenames;

- (id)init
{
	self = [super initWithNibName:@"LYImagePickerController" bundle:nil];
	if (self != nil)
	{
		if (is_pad())
			self.view.frame = CGRectMake(0, 0, screen_height(), screen_width() - 10);

		background_titles		= [[NSMutableArray alloc] initWithObjects:nil];
		background_filenames	= [[NSMutableArray alloc] initWithObjects:nil];

		picker = [[UIImagePickerController alloc] init];
		picker.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		{
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
			if ([picker respondsToSelector:@selector(cameraCaptureMode)])
				picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
			else
				NSLog(@"CAMERA set capture mode failed");
			if ([picker respondsToSelector:@selector(cameraFlashMode)])
				picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
			else
				NSLog(@"CAMERA set flash mode failed");
			[self.view addSubview:picker.view];
			[self.view sendSubviewToBack:picker.view];
		}
		[picker viewWillAppear:YES];
		[picker viewDidAppear:YES];
	}
	return self;
}

- (IBAction)action_flash_changed
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
	{
		[@"Camera Not Available" show_alert_message:@"Camera is not available on this device."];
		return;
	}

	switch (segment_flash.selectedSegmentIndex)
	{
		case 0:
			if ([UIImagePickerController respondsToSelector:@selector(isFlashAvailableForCameraDevice:)])
			{
				if ([UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear] == YES)
				{
					picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
					break;
				}
			}
			[@"Flash Not Available" show_alert_message:@"The LED flash is not available on this device."];
			break;
		case 1:
			if ([UIImagePickerController respondsToSelector:@selector(isFlashAvailableForCameraDevice:)])
			{
				if ([UIImagePickerController isFlashAvailableForCameraDevice:UIImagePickerControllerCameraDeviceRear] == YES)
				{
					picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
					break;
				}
			}
			[@"Flash Not Available" show_alert_message:@"The LED flash is not available on this device."];
			//	[segment_flash setEnabled:YES forSegmentAtIndex:0];
			//	[segment_flash setEnabled:NO forSegmentAtIndex:1];
			break;
		case 2:
			picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
			break;
	}
}

- (IBAction)action_camera_changed
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
	{
		[@"Camera Not Available" show_alert_message:@"Camera is not available on this device."];
		return;
	}

	switch (segment_camera.selectedSegmentIndex)
	{
		case 0:
			if ([UIImagePickerController respondsToSelector:@selector(isCameraDeviceAvailable:)])
			{
				if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
				{
					picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
					break;
				}
			}
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
				[@"Camera Not Available" show_alert_message:@"Rear camera is not available on this device."];
			break;
		case 1:
			if ([UIImagePickerController respondsToSelector:@selector(isCameraDeviceAvailable:)])
			{
				if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
				{
					picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
					break;
				}
			}
			[@"Camera Not Available" show_alert_message:@"Front camera is not available on this device."];
			//	[segment_camera setEnabled:YES forSegmentAtIndex:0];
			//	[segment_camera setEnabled:NO forSegmentAtIndex:1];
			break;
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if ((fromInterfaceOrientation == UIInterfaceOrientationPortrait) ||
		(fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
		picker.view.frame = CGRectMake(80, -80, 320, 480);
		picker.view.hidden = YES;
	}
	else
	{
		picker.view.frame = CGRectMake(0, 0, 320, 480);
		picker.view.hidden = NO;
	}
}

- (IBAction)action_select_source
{
	int				i;
	UIAlertView*	alert = [[UIAlertView alloc] 
		initWithTitle:@"Select Background"
			  message:@"Please select background from one of the sources."
			 delegate:self
	cancelButtonTitle:@"Cancel"
	otherButtonTitles:@"Album", @"Photo Library", nil];

	for (i = 0; i < background_titles.count; i++)
		[alert addButtonWithTitle:[background_titles objectAtIndex:i]];

	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0:
			break;
		case 1:
			break;
	}
}

- (void)add_background:(NSString*)title filename:(NSString*)filename
{
	[background_titles addObject:title];
	[background_filenames addObject:filename];
}

@end
