#import "LYAlertView.h"

@implementation UIAlertView (LYAlertView)

+ (void)alertWithTitle:(NSString*)title message:(NSString*)msg block:(LYBlockVoidInt)callback
{
	[UIAlertView alertWithTitle:title message:msg confirm:nil cancel:@"OK" block:callback];
}

+ (void)alertWithTitle:(NSString*)title message:(NSString*)msg 
			   confirm:(NSString*)confirm cancel:(NSString*)cancel block:(LYBlockVoidInt)callback
{
	@synchronized(self)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil 
											  cancelButtonTitle:cancel otherButtonTitles:confirm, nil];
		if (alert != nil)
		{
			alert.delegate = alert;
			[alert associate:@"block-callback" with:[callback copy]];
			[alert show];
			//[alert release];
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	LYBlockVoidInt callback = [self associated:@"block-callback"];
	callback(buttonIndex);
	[callback release];
	[alertView release];
}

@end
