#import "MQShareController.h"

@implementation MQShareController

@synthesize navigation_controller;
@synthesize title;
@synthesize message;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		title = @"";
		message = @"";
		controller_email = [[MFMailComposeViewController alloc] init];
		controller_email.mailComposeDelegate = self;
#ifdef MQ_ENABLE_SDK_FACEBOOK
		//	if (is_phone())
			controller_facebook = [[MQFacebook alloc] initWithKey:@"f66ded19648d950e531e8e9fee6fffb1"];
#endif
	}
	return self;
}

- (void)facebook_login
{
#ifdef MQ_ENABLE_SDK_FACEBOOK
	[controller_facebook login];
#endif
}

- (void)facebook_logout
{
#ifdef MQ_ENABLE_SDK_FACEBOOK
	[controller_facebook logout];
#endif
}

- (void)dealloc
{
	NSLog(@"SHARE finalize");
	[controller_email release];
#ifdef MQ_ENABLE_SDK_FACEBOOK
	//	if (is_phone())
		[controller_facebook release];
#endif
	//	[controller_sms release];
	[super dealloc];
}

- (void)show
{
	UIAlertView*	alert = [[UIAlertView alloc] 
	//	initWithTitle:@"Share"
	//		  message:[NSString stringWithFormat:@"The following contents will be shared:\n___________________________\n\n%@", message]
		initWithTitle:title	//	@"Contents Sharing"
			  message:@""	//	@"Contents Sharing Service"	//	message
			 delegate:self
	cancelButtonTitle:@"Cancel"
	otherButtonTitles:@"Copy to Clipboard", @"Email", @"SMS", nil];
#ifdef MQ_ENABLE_SDK_FACEBOOK
	//	if (is_phone())
		[alert addButtonWithTitle:@"Facebook"];
#endif

	[alert show];
	[alert release];
}

//	- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	Class a_class;

	//	NSLog(@"share index: %i", buttonIndex);
	switch (buttonIndex)
	{
		case 0:
			break;
		case 1:
			[UIPasteboard generalPasteboard].string = message;
			break;
		case 2:
			[controller_email setSubject:title];
			[controller_email setMessageBody:message isHTML:NO];
			if (controller_email != nil)
				[navigation_controller presentModalViewController:controller_email animated:YES];
			break;
		case 3:
			a_class = NSClassFromString(@"MFMessageComposeViewController");
			if (a_class != nil)
			{
				controller_sms = [[a_class alloc] init];
				//	if ([MFMessageComposeViewController canSendText] == NO)
				if ([a_class perform_string:@"canSendText"] == NO)
				{
					//	NSLog(@"SHARE sms not available");
					[controller_sms release];
					controller_sms = nil;
				}
				else
				{
					[controller_sms perform_string:@"setMessageComposeDelegate:" with:self];
					[controller_sms perform_string:@"setBody:" with:message];
					[navigation_controller presentModalViewController:controller_sms animated:YES];
				}
			}
			else
				[@"SMS Not Available" show_alert_message:@"Sorry, SMS is not available in this version of iOS."];
			break;
		case 4:
			//	[@"test" show_alert_message:@""];
#ifdef MQ_ENABLE_SDK_FACEBOOK
			[alertView dismissWithClickedButtonIndex:0 animated:NO];
			[controller_facebook post:message];
			//	[self performSelector:@selector(facebook_post_message) withObject:nil afterDelay:1];
#endif
			break;
	}
}

- (void)facebook_post_message
{
#ifdef MQ_ENABLE_SDK_FACEBOOK
	[controller_facebook post:message];
#endif
}

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
			break;
		default:
			break;
	}
	[navigation_controller dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[navigation_controller dismissModalViewControllerAnimated:YES];
	[controller release];
}

@end
