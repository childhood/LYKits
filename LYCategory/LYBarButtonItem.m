#import "LYBarButtonItem.h"

@implementation UIBarButtonItem (LYBarButtonItem)

- (void)setButton:(NSString*)filename
{
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
	[button setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
	self.customView = button;
	[self associate:@"custom-button" with:button];
	[button release];
	//	NSLog(@"DEBUG navigation item %@\n%@\n%@", title, self.titleView, self.leftBarButtonItem);
}

- (UIButton*)button
{
	UIButton* button = [self associated:@"custom-button"];
	//	NSLog(@"title label: %@, %i", label.text, (int)label);
	return button;
}

@end
