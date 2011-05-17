#import "LYBrowserController.h"

@implementation LYBrowserController

@synthesize search_bar;
@synthesize delegate;

- (id)init
{
	return [self initWithNibName:@"LYBrowserController" bundle:nil];
}

- (id)initWithString:(NSString*)url
{
	self = [self init];
	if (self != nil)
	{
		current_url = url;
	}
	return self;
}

- (void)viewDidLoad
{
	search_bar.text = current_url;
	[self reset_button_status];
	[self load_url];
}

- (void)set_url:(NSString*)url
{
	current_url = url;
	[self viewDidLoad];
}

#pragma mark actions

- (IBAction)action_browser_back
{
	[web_view goBack];
}
- (IBAction)action_browser_forward
{
	[web_view goForward];
}
- (IBAction)action_browser_refresh
{
	[web_view reload];
}
- (IBAction)action_browser_stop
{
	[web_view stopLoading];
}
//	TODO: protocol
- (IBAction)action_browser_done
{
	[delegate perform_string:@"browser_dismiss:" with:self];
}

#pragma mark web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self reset_button_status];
	[web_view apply_js_anchor];
	search_bar.text = web_view.request.URL.absoluteString;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"BROWSER failed: %@", error);
#if 0
	[@"Connection Failed" show_alert_message: [NSString stringWithFormat:
						 @"Failed to open %@:\n\n%@", search_bar.text, error.localizedDescription]];
#endif
}

//	- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//	- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self load_url];
	[searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (void)reset_button_status
{
	if (web_view.canGoBack)
		item_back.enabled = YES;
	else
		item_back.enabled = NO;

	if (web_view.canGoForward)
		item_forward.enabled = YES;
	else
		item_forward.enabled = NO;
}

- (void)load_url
{
	//	NSLog(@"loading %@", search_bar.text);
	if (search_bar != nil)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		if ([search_bar.text has_substring:@"://"] == NO)
			search_bar.text = [@"http://" stringByAppendingString:search_bar.text];
		[web_view load_web:search_bar.text];
	}
}

- (void)hide_search_bar
{
	web_view.frame = CGRectMake(0, 0, screen_width(), screen_height() - 20 - tool_bar.frame.size.height);
}

- (void)show_search_bar
{
	web_view.frame = CGRectMake(0, search_bar.frame.size.height, 
			screen_width(), screen_height() - 20 - tool_bar.frame.size.height - search_bar.frame.size.height);
}

@end


