#import "AppPhotoFrame.h"

@implementation AppPhotoFrame

@synthesize image_bg;
@synthesize image_3d;
@synthesize button_fullscreen;
@synthesize is_started;

- (void)load
{
	is_fullscreen = NO;
	is_started = NO;
	nav.navigationBarHidden = YES;
	segment_mode.selectedSegmentIndex = 1;
	[image_bg set_h:screen_height() - toolbar_control.frame.size.height];
	image_3d = [[MQ3DImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100)];
	[image_3d autoresizing_add_width:YES height:YES];
	//[image_3d set_image:[@"sasha06.png" filename_bundle]];
	[image_3d set_color:[UIColor colorWithWhite:0.4 alpha:1]];
	[image_3d set_mode:1];
	[self.view addSubview:image_3d];
	[self.view sendSubviewToBack:image_3d];
	[self.view sendSubviewToBack:image_bg];
}

- (IBAction)action_add_foreground
{
	UIImagePickerController*	picker = [[UIImagePickerController alloc] init];
	[picker get_image_nav:nav image:(UIImageView*)image_3d];
	is_started = YES;
}

- (IBAction)action_add_background
{
	UIImagePickerController*	picker = [[UIImagePickerController alloc] init];
	[picker get_image_nav:nav image:image_bg];
}

- (IBAction)action_change_mode
{
	[image_3d set_mode:segment_mode.selectedSegmentIndex];
	if (is_started == NO)
	{
		switch (segment_mode.selectedSegmentIndex)
		{
			case 0:
				[image_3d set_image:[@"sasha01.png" filename_bundle]];
				break;
			case 1:
				[image_3d set_image:[@"sasha06.png" filename_bundle]];
				break;
			case 2:
				[image_3d set_image:[@"sasha05.png" filename_bundle]];
				break;
			case 3:
				[image_3d set_image:[@"sasha07.png" filename_bundle]];
				break;
		}
	}
}

- (IBAction)action_toggle_fullscreen
{
	//	NSLog(@"height: %f", image_bg.frame.size.height);
	[UIView begin_animations:0.3];
	if (is_fullscreen)
	{
		is_fullscreen = NO;
		[image_bg set_y:-20];
		[image_bg set_h:screen_height() - toolbar_control.frame.size.height];
		[toolbar_control set_y:screen_height() - 20 - toolbar_control.frame.size.height];
	}
	else
	{
		is_fullscreen = YES;
		[image_bg set_y:-20];
		[image_bg set_h:screen_height()];
		[toolbar_control set_y:screen_height()];
	}
	[UIView commitAnimations];
	[[UIApplication sharedApplication] setStatusBarHidden:is_fullscreen withAnimation:UIStatusBarAnimationSlide];
	//	toolbar_control.hidden = is_fullscreen;
	//	[self.nav setToolbarHidden:is_fullscreen animated:YES];
}

- (IBAction)action_show_help
{
	[@"Help" show_alert_message:@"Tile your device to see the 3D effect. Use the \"BG\" button to choose an image as background.\n\nButton 1-4 indicate different gravity modes.\n\nIf you cannot see any 3D images, this function may not be compatible with your hardware."];
}

@end
