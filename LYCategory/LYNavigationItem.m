#import "LYNavigationItem.h"

@implementation UINavigationItem (LYNavigationItem)

- (void)setTitle_label:(NSString*)title
{
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [ly screen_width] - 120, 44)];
	label.text = title;
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont boldSystemFontOfSize:20];
	label.backgroundColor = [UIColor clearColor];

	self.titleView = label;
	[self associate:@"title-label" with:label];
	[label release];

	//	NSLog(@"DEBUG navigation item %@\n%@\n%@", title, self.titleView, self.leftBarButtonItem);
}

- (UILabel*)title_label
{
	UILabel* label = [self associated:@"title-label"];
	//	NSLog(@"title label: %@, %i", label.text, (int)label);
	return label;
}

@end
