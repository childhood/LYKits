#import "LYWebView.h"

@implementation UIWebView (LYWebView)

- (void)load_file:(NSString*)s
{
	[self loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:s]]];
	//NSURLRequest*	request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.google.com"]];
	//[self loadRequest:request];
	//NSLog(@"loading %@\n%@", s, request.allHTTPHeaderFields);
}

- (void)load_web:(NSString*)s
{
	[self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:s]]];
}

- (void)apply_js_anchor
{
	NSString*	js = @"\
					 var d = document.getElementsByTagName('a');\
					 for (var i = 0; i < d.length; i++) {\
						 if (d[i].getAttribute('target') == '_blank') {\
							 d[i].removeAttribute('target');\
						 }\
					 }\
	";
	[self stringByEvaluatingJavaScriptFromString:js];
}

#if 0
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
	if (action == @selector(test))
		return YES;

	return NO;
}

- (void)test
{
	NSString *selection = [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
	NSLog(@"selected web: %@", selection);
}
#endif

@end
