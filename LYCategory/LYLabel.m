#import "LYLabel.h"

@implementation UILabel (LYLabel)

- (void)copy_style:(UILabel*)target
{
	if (target.hidden == NO)
	{
		[super copy_style:target];
		self.font		= target.font;
		self.textColor	= target.textColor;
		self.textAlignment	= target.textAlignment;
		self.lineBreakMode	= target.lineBreakMode;
		self.numberOfLines	= target.numberOfLines;
		self.shadowColor	= target.shadowColor;
		self.shadowOffset	= target.shadowOffset;
	}
}

@end
