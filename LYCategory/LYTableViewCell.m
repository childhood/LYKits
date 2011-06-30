#import "LYTableViewCell.h"

@implementation UITableViewCell (LYTableViewCell)

- (void)copy_style:(UITableViewCell*)target
{
	if (target.hidden == NO)
	{
		[super copy_style:target];
		self.backgroundView			= target.backgroundView;
		self.selectedBackgroundView	= target.selectedBackgroundView;
		self.accessoryType			= target.accessoryType		;
		self.accessoryView			= target.accessoryView;
		self.editingAccessoryType	= target.editingAccessoryType		;
		self.editingAccessoryView	= target.editingAccessoryView;
	}
}

- (void)didTransitionToState:(UITableViewCellStateMask)state
{
	//	[super didTransitionToState:state];
	if (state == UITableViewCellStateShowingDeleteConfirmationMask || state == UITableViewCellStateDefaultMask)
	{
		for (UIView *subview in self.subviews)
		{
			if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
			{
				UIView *deleteButtonView = (UIView *)[subview.subviews objectAtIndex:0];
				CGRect f = deleteButtonView.frame;
				f.origin.x -= 10;
				deleteButtonView.frame = f;
			}
		}
	}
}

@end
