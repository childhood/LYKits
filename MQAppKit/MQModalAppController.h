#define k_mq_app_name		@"app_name"
#define k_mq_app_subview	@"app_subview"

#define k_mq_subview_class	@"subview_class"
#define k_mq_subview_arg	@"subview_arg"
#define k_mq_subview_frame	@"subview_frame"

#define k_mq_nav_bg					@"home_header.png"
#define k_mq_nav_button_right_bg	@"inner_back.png"
#define k_mq_fixed_tab_bg			@"footer_bg.png"

@protocol MQModalAppSubview
- (id)initWithArray:(NSArray*)array delegate:(id)delegate frame:(CGRect)frame;
@end

@interface MQModalAppController: UIViewController
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
