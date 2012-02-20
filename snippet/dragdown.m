#import <UIKit/UIKit.h>

-(void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
	if (scrollView == table_event)
	{
		[view_new_top set_y:MIN(0, table_event.contentOffset.y)];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	//	NSLog(@"SCROLL end decelerating");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	//	NSLog(@"SCROLL will drag");
	if (scrollView == table_event)
	{
		//	if (scroll_drag_begin != -44)
		scroll_drag_begin = table_event.contentOffset.y;
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if ((scrollView == table_event) && (table_event.contentOffset.y < 44))
	{
		//	NSLog(@"drag from %f", scroll_drag_begin);
		if (scroll_drag_begin == 0)
		{
			//	NSLog(@"to 0");
			//	view.contentOffset = CGPointMake(0, 0);
			[self performSelector:@selector(reset_content_offset:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.1];
		}
		else
		{
			//	NSLog(@"to -44: %f", scroll_drag_begin);
			[UIView begin_animations:0.3];
			table_event.contentOffset = CGPointMake(0, 0);
			[UIView commitAnimations];
		}
	}
}

