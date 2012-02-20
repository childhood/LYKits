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

#ifdef LY_CATEGORY_ENABLE_CELL_TRANSITION
- (void)didTransitionToState:(UITableViewCellStateMask)state
{
	//	[super didTransitionToState:state];
	//	if (state == UITableViewCellStateShowingDeleteConfirmationMask || state == UITableViewCellStateDefaultMask)
	{
		for (UIView *subview in self.subviews)
		{
			//	UIView *view = (UIView*)[subview.subviews objectAtIndex:0];
			CGRect f = subview.frame;
			if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
				f.origin.x -= [[[ly data] v:@"cell-delete-fix-x"] floatValue];
			else if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellReorderControl"])
				f.origin.x -= [[[ly data] v:@"cell-move-fix-x"] floatValue];
			else if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"])
				f.origin.x += [[[ly data] v:@"cell-edit-fix-x"] floatValue];
			subview.frame = f;
		}
	}
}
#endif

@end
