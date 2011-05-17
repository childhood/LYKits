#import "LYMiniAppsController.h"

@implementation LYMiniAppsController

@synthesize nav;
@synthesize image_fullscreen;
@synthesize button_fullscreen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
		browser = [[LYBrowserController alloc] initWithString:@"http://superarts.org"];
		browser.delegate = self;
    }
    return self;
}

- (void)dealloc
{
	[browser release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#if 0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#endif

- (void)show_flashlight:(UIColor*)color
{
	status_bar_hidden = [[UIApplication sharedApplication] isStatusBarHidden];

	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(-100, -100, 2148, 2148)];
	button.backgroundColor = color;
	button.alpha = 0.01;
	//[button addTarget:[LYMiniApps shared] action:@selector(hide_view:) forControlEvents:UIControlEventTouchDown];
	[button addTarget:self action:@selector(hide_view:) forControlEvents:UIControlEventTouchDown];
	[[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)] addSubview:button];
	//	if (status_bar_hidden == NO)
	//		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

	[UIView begin_animations:0.3];
	button.alpha = 1;
	[UIView commitAnimations];
}

- (void)show_image:(NSString*)filename
{
	[self present_image:[[UIImage alloc] initWithContentsOfFile:[filename filename_bundle]]];
}

- (void)present_image:(UIImage*)image
{
	if (nav == nil)
	{
		NSLog(@"MINIAPPS invalid nav");
		return;
	}

	if (image == nil)
	{
		NSLog(@"MINIAPPS invalid image");
		return;
	}

	self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[nav presentModalViewController:self animated:YES];
	image_fullscreen.image = image;
	[self.view addSubview:view_fullscreen];
	//[image_fullscreen.image release];
	//image_fullscreen.image = image;

#if 0
	UIViewController* controller = [[UIViewController alloc] init];
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen_width(), screen_height())];

	status_bar_hidden = [[UIApplication sharedApplication] isStatusBarHidden];
	if (status_bar_hidden == NO)
		[button reset_height:-20];
	controller.view = button;
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	button.backgroundColor = [UIColor clearColor];
	[button autoresizing_add_width:YES height:YES];
	[button set_background_named:filename];
	//[button set_image_named:filename];
	[button addTarget:[LYMiniApps shared] action:@selector(hide_controller:) forControlEvents:UIControlEventTouchDown];
	if (nav == nil)
		[[[[UIApplication sharedApplication] delegate] performSelector:@selector(window)] addSubview:button];
	else
		[nav presentModalViewController:controller animated:YES];
#endif
}

- (void)hide_view:(UIView*)view
{
	if (status_bar_hidden == NO)
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	[UIView begin_animations:0.3];
	view.alpha = 0.01;
	[UIView commitAnimations];

	[self performSelector:@selector(remove_release:) withObject:view afterDelay:0.3];
}

- (void)hide_controller:(UIView*)view
{
	//	if (status_bar_hidden == NO)
	//		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	[nav dismissModalViewControllerAnimated:YES];
	[[view view_controller] release];
	[view release];
}

- (void)remove_release:(UIView*)view
{
	[view removeFromSuperview];
	[view release];
}

- (IBAction)action_dismiss_fullscreen
{
	NSLog(@"app dismiss");
	[image_fullscreen.image release];
	[nav dismissModalViewControllerAnimated:YES];
}

#pragma mark browser

- (void)show_browser:(NSString*)url
{
	[browser set_url:url];
	if (is_phone())
	{
		browser.view.frame = CGRectMake(0, 20, screen_width(), screen_height() - 20);
		[browser.view set_y:screen_height()];
		[browser.view set_y:20 animation:0.3];
		[nav.view addSubview:browser.view];
	}
	else
	{
		browser.modalPresentationStyle = UIModalPresentationFormSheet;
		browser.modalPresentationStyle = UIModalPresentationPageSheet;
		[nav presentModalViewController:browser animated:YES];
	}
}

- (void)browser_dismiss:(id)sender
{
	if (is_phone())
	{
		[browser.view set_y:screen_height() animation:0.3];
		[self performSelector:@selector(browser_remove) withObject:nil afterDelay:0.3];
	}
	else
		[nav dismissModalViewControllerAnimated:YES];
}

- (void)browser_remove
{
	[browser.view removeFromSuperview];
}

#pragma mark mail

- (void)show_mail_to:(NSArray*)recipients title:(NSString*)title body:(NSString*)body
{
	MFMailComposeViewController* controller_mail = [[MFMailComposeViewController alloc] init];
	controller_mail.mailComposeDelegate = self;
	[controller_mail setToRecipients:recipients];
	[controller_mail setSubject:title];
	[controller_mail setMessageBody:body isHTML:NO];
	[nav presentModalViewController:controller_mail animated:YES];
}

#if 1
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	//	NSLog(@"mail result: %@", error);
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			[@"Mail Error" show_alert_message:@"Please check your mail and internet settings, and try again later."];
			break;
		default:
			break;
	}
	[nav dismissModalViewControllerAnimated:YES];
	[controller release];
}
#endif

#if 0
- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
	[nav dismissModalViewControllerAnimated:YES];
	[controller release];
}
#endif

@end
