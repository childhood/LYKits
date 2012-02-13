#import "LYScrollView.h"

@implementation UIScrollView (LYScrollView)

/*
- (id)init
{
	[self associate:@"flag_keep_width" with:[NSNumber numberWithBool:NO]];
	return [super init];
}
*/

- (void)copy_style:(UIScrollView*)target
{
	if (target.hidden == NO)
	{
		[super copy_style:target];
		//	TODO: ...
	}
}

//	add labels vertically and resize self
- (void)add_labels:(NSArray*)array
{
	UILabel*	label;
	CGFloat		height;
	CGSize		size;

	for (label in array)
	{
		//	skip empty labels
		//	if ((label == nil) || (label == [NSNull null]))
		if (label == nil)
			continue;
		height += [self add_label:label height:height];
	}

	//	change content size
	size = self.contentSize;
	self.contentSize = CGSizeMake(size.width, height);
}

- (void)add_views:(NSArray*)array
{
	UIView*		view;
	CGFloat		height;
	CGSize		size;

#if 0
	for(UIView *subview in [view subviews])
		[subview removeFromSuperview];
#endif

	for (view in array)
	{
		if ([view isKindOfClass:[UILabel class]])
			height += [self add_label:(UILabel*)view height:height];
		else if ([view isKindOfClass:[UIImageView class]])
			height += [self add_image_view:(UIImageView*)view height:height];
		else if (view != nil)
			height += [self add_view:view height:height];
	}

	//	change content size
	size = self.contentSize;
	self.contentSize = CGSizeMake(size.width, height);
}

- (CGFloat)add_image_view:(UIImageView*)image_view height:(CGFloat)height
{
	if (image_view.image == nil)
		return 0;

	return [self add_view:image_view height:height];
}

- (CGFloat)add_view:(UIView*)view height:(CGFloat)height
{
	CGSize		size;
	CGPoint		point;
	CGRect		rect;
	CGFloat		ret;

	point = view.frame.origin;
	ret = point.y;

	//	get view size
	size = CGSizeMake(view.frame.size.width, view.frame.size.height);

	//	resize view
	rect = view.frame;
	view.frame = CGRectMake(rect.origin.x, ret + height, size.width, size.height);

	//	add view
	[self addSubview:view];
	//	[view release];	//	TODO: crush if textview is released
	//	NSLog(@"adding view: %@", view);

	return ret + size.height;
}

- (CGFloat)add_label:(UILabel*)label height:(CGFloat)height
{
	CGSize		size;
	CGPoint		point;
	CGRect		rect;
	CGFloat		ret, size_width;

	if (label.text.length == 0)
		return 0;

	point = label.frame.origin;
	ret = point.y;

	//	get label full size
	size = CGSizeMake(label.frame.size.width, 9999);
	size_width = size.width;
	size = [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:label.lineBreakMode];
	//	if (flag_keep_width == YES)
	//	size = CGSizeMake(size_width, size.height);

	//	resize label
	rect = label.frame;
	//label.frame = CGRectMake(rect.origin.x, ret + height, size.width, size.height);
	label.frame = CGRectMake(rect.origin.x, ret + height, rect.size.width, size.height);

	//	add label
	[self addSubview:label];
	[label release];	//	TODO: help releasing because the labels are always not needed anymore... but is it proper?

	return ret + size.height;
}

- (void)set_keep_width:(BOOL)b
{
	//	flag_keep_width = b;
}

- (void)pagecontrol_reload
{
	UIPageControl* page = [self associated:@"ly-page-control"];
	if (page != nil)
	{
		page.numberOfPages = self.contentInset.right / self.frame.size.width;
		page.currentPage = self.contentOffset.x / self.frame.size.width;
		page.hidesForSinglePage = NO;
		[page addTarget:self action:@selector(pagecontrol_changed:) forControlEvents:UIControlEventValueChanged];
#if 0
		NSLog(@"width %f", self.contentInset.right);
		NSLog(@"size %f", self.frame.size.width);
		NSLog(@"count %i", page.numberOfPages);
		NSLog(@"index %i", page.currentPage);
#endif
	}
}

- (void)pagecontrol_associate:(UIPageControl*)pagecontrol
{
	[self associate:@"ly-page-control" with:pagecontrol];
	[self pagecontrol_reload];
	self.delegate = (id<UIScrollViewDelegate>)self;
}

- (void)pagecontrol_changed:(UIPageControl*)page
{
	[UIView begin_animations:0.3];
	self.contentOffset = CGPointMake(self.frame.size.width * page.currentPage, 0);
	[UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self pagecontrol_reload];
}

@end
