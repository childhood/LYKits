#define k_ly_app_name		@"app_name"
#define k_ly_app_subview	@"app_subview"

#define k_ly_subview_class	@"subview_class"
#define k_ly_subview_arg	@"subview_arg"
#define k_ly_subview_frame	@"subview_frame"

#define k_ly_nav_bg					@"home_header.png"
#define k_ly_nav_button_right_bg	@"inner_back.png"
#define k_ly_fixed_tab_bg			@"footer_bg.png"

@protocol LYModalAppSubview
- (id)initWithArray:(NSArray*)array delegate:(id)delegate frame:(CGRect)frame;
@end

@interface LYModalAppController: UIViewController
{
	id				delegate;
	NSArray*		data;
	UIView*			current_view;
}
@property (nonatomic,retain) id			delegate;
@property (nonatomic,retain) NSArray*	data;
- (id)initWithArray:(NSArray*)array delegate:(id)app_delegate;
- (UIView*)get_view_named:(NSString*)name;

@end
