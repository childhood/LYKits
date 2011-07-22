#import <UIKit/UIKit.h>
#import "LYKits.h"

/*
 * 'Scroll tab' is a 'scroll bar' that contains series of buttons.
 */

@protocol LYScrollTabControllerDelegate;

@interface LYScrollTabController: UIViewController
{
	id <LYScrollTabControllerDelegate>	delegate;
	UIScrollView*						scroll_view;
	NSMutableArray*						buttons;
	NSInteger							count;
}
@property(nonatomic,retain)	UIScrollView*	scroll_view;
@property(nonatomic,retain)	NSMutableArray*	buttons;
@property(nonatomic,retain)	id				delegate;

//	interface
- (id)initWithFrame:(CGRect)frame delegate:(id)a_delegate;
- (void)reload_data;

//	internal
- (void)action_button_pressed:(id)sender;
- (void)reload_buttons;

@end

@protocol LYScrollTabControllerDelegate

//	data source; *IMPORTANT* release must be handled for "alloc_xxx" messages manually
- (NSInteger)scroll_tab_count:(LYScrollTabController*)controller_tab;
- (CGSize)scroll_tab_size:(LYScrollTabController*)controller_tab;
- (UIButton*)scroll_tab:(LYScrollTabController*)controller_tab alloc_button_for_index:(NSInteger)index;

//	event handler
- (void)scroll_tab:(LYScrollTabController*)controller_tab did_select_index:(NSInteger)index;

@end


/*
 * LYScrollTabBarController - based on LYScrollTabController, with similar interface as UITabBarController
 *
 * sample code
 *
	tab_main = [[LYScrollTabBarController alloc] init];
	tab_main.height = 60;
	[tab_main.data addObject:[NSDictionary dictionaryWithObjectsAndKeys:
		@"tab_start.png",
		@"bg-normal",
		@"Icon.png",
		@"bg-selected",
		nav_start,
		@"controller",
		nil]];
	tab_main.index = 0;
	[self.window addSubview:tab_main.view];
	[tab_main reload];
 *
 */

@interface LYScrollTabBarController: UIViewController <LYScrollTabControllerDelegate>
{
	LYScrollTabController*	scroll_tab;
	NSMutableArray*			data;
	NSUInteger				index;
	CGFloat					height;
	CGFloat					bottom_space;	//	used for ads, etc.
	id						delegate;
}
@property(nonatomic, retain)	id						delegate;
@property(nonatomic, retain)	LYScrollTabController*	scroll_tab;
@property(nonatomic, retain)	NSMutableArray*			data;
@property(nonatomic)			NSUInteger				index;
@property(nonatomic)			CGFloat					height;
@property(nonatomic)			CGFloat					bottom_space;

- (void)reload;
- (void)show:(CGFloat)duration;
- (void)hide:(CGFloat)duration;
- (void)show_end;
- (void)hide_end;

@end
