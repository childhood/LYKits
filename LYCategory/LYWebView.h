#import <UIKit/UIKit.h>

@interface UIWebView (LYWebView)

//	load content from string
- (void)load_file:(NSString*)s;
- (void)load_web:(NSString*)s;

//	remove the 'target="_blank"' attributes of <a> tags
- (void)apply_js_anchor;

@end
