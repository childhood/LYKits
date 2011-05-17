#import "LYAppKit.h"
#import "LYFoundation.h"

@implementation LYModalAppController

@synthesize delegate;
@synthesize data;

- (id)initWithArray:(NSArray*)array delegate:(id)app_delegate
{
	self = [super init];
	if (self != nil)
	{
		data = [[NSArray alloc] initWithArray:array];
		delegate = app_delegate;
	}
	return self;
}

- (void)dealloc
{
	[data release];
	if (current_view != nil)
		[current_view release];
	[super dealloc];
}

- (UIView*)get_view_named:(NSString*)name
{
	int				i, ii;
	NSString*		item_name;
	//NSArray*		array;
	NSDictionary*	dict;
	NSArray*		array_subviews;
	//NSArray*		array_subview;
	NSDictionary*	dict_subview;
	Class			subview_class;
	NSArray*		subview_arg;
	NSString*		subview_rect;
	UIView<LYModalAppSubview>*	subview;

	if (current_view != nil)
		[current_view release];
	//	TODO: hardware resolution

	current_view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, screen_width(), screen_height() - 20)];
	current_view.backgroundColor = [UIColor whiteColor];
	[current_view autoresizing_add_width:YES height:YES];

	for (i = 0; i < data.count; i++)
	{
		dict		= [data objectAtIndex:i];
		item_name	= [dict objectForKey:k_ly_app_name];
		//	NSLog(@"item_name:%@",item_name);
		if ([item_name isEqualToString:name])
		{
			array_subviews = [dict objectForKey:k_ly_app_subview];
			for (ii = 0; ii < array_subviews.count; ii++)
			{
				dict_subview	= [array_subviews objectAtIndex:ii];
				subview_class	= [dict_subview objectForKey:k_ly_subview_class];
				subview_arg		= [dict_subview objectForKey:k_ly_subview_arg];
				subview_rect	= [dict_subview objectForKey:k_ly_subview_frame];

				if (subview_rect != nil)
				{
					subview = [[subview_class alloc] initWithArray:subview_arg delegate:delegate frame:CGRectFromString(subview_rect)];
				}
				else
					subview = [[subview_class alloc] initWithArray:subview_arg delegate:delegate];

				[current_view addSubview:subview];
				[subview release];
			}
		}
	}
	
	

	return current_view;
}
	

@end
