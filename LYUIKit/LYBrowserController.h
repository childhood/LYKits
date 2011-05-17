#import <UIKit/UIKit.h>
#import "LYPublic.h"

@interface LYBrowserController: UIViewController
{
	IBOutlet UIWebView*			web_view;
	IBOutlet UIToolbar*			tool_bar;
	IBOutlet UISearchBar*		search_bar;
	IBOutlet UIBarButtonItem*	item_back;
	IBOutlet UIBarButtonItem*	item_forward;

	id					delegate;
	NSString*			current_url;
}
@property (nonatomic, retain) id				delegate;
@property (nonatomic, retain) UISearchBar*		search_bar;

- (IBAction)action_browser_back;
- (IBAction)action_browser_forward;
- (IBAction)action_browser_refresh;
- (IBAction)action_browser_stop;
- (IBAction)action_browser_done;
- (id)initWithString:(NSString*)url;
- (void)reset_button_status;
- (void)load_url;
- (void)hide_search_bar;
- (void)show_search_bar;
- (void)set_url:(NSString*)url;

@end

