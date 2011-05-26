#import <objc/message.h>
#import <UIKit/UIKit.h>
#import "LYPublic.h"

//	sample code
#if 0
	provider_menu = [[LYTableViewProvider alloc] initWithTableView:table_menu];
	provider_menu.delegate = self;
	provider_menu.style = UITableViewCellStyleValue1;
	[provider_menu.headers add_objects:@"Header 1", @"Header 2", nil];
	provider_menu.indexes = provider_menu.headers;
	[provider_menu.texts add_array:@"Plain", @"Grouped", nil];
	[provider_menu.texts add_array:@"Another Plain", @"Another Grouped", nil];
	[provider_menu.details add_array:@"Another Plain 1", @"Another Grouped 1", nil];
	[provider_menu.details add_array:@"Another Plain 2", @"Another Grouped 2", nil];
#endif

@interface LYTableViewProvider: NSObject <UITableViewDelegate, UITableViewDataSource>
{
	UITableView*					view;
	UIViewController*				controller;
	UITableViewCellStyle			style;
	NSString*						theme;
	id								delegate;
	NSIndexPath*					current_path;
	NSString*						current_text;
	NSString*						accessory_name;
	UITableViewCellAccessoryType	accessory_type;
	NSMutableArray*					accessories;
	UITableViewCellSelectionStyle	cell_selection;
	//UITableViewCellSeparatorStyle	separator_style;
	UITableViewRowAnimation			animation_delete;
	BOOL							can_edit;
	NSMutableArray*					additional_views;
	CGRect							cell_image_rect;
	UIViewContentMode				cell_image_mode;
	//NSString*						cell_image_place;

	NSMutableArray*		texts;
	UILabel*			text_label;

	NSMutableArray*		details;
	UILabel*			detail_label;

	NSMutableArray*		images;
	NSMutableArray*		image_urls;

	NSMutableArray*		indexes;
	NSInteger			index_length;
	NSMutableArray*		headers;
	NSMutableArray*		header_counts;
	UILabel*			header_label;
	//UIImageView*		header_bg;

	NSMutableArray*		footers;
	UILabel*			footer_label;
	//UIImageView*		footer_bg;

	CGFloat				cell_height;
	UIColor*			cell_bg_color;
	UIColor*			cell_bg_color_interlace;
	NSString*			cell_bg;
	NSString*			cell_bg_top;
	NSString*			cell_bg_bottom;
	NSString*			cell_bg_selected;
	NSString*			cell_bg_top_selected;
	NSString*			cell_bg_bottom_selected;

	CGFloat				table_header_height;
	CGFloat				table_footer_height;

	NSMutableArray*		tmp_texts;
	NSMutableArray*		tmp_details;
	NSMutableArray*		tmp_images;
	NSMutableArray*		tmp_image_urls;
	NSMutableArray*		tmp_accessories;
	NSMutableArray*		tmp_headers;
	NSMutableArray*		tmp_footers;
}
@property (nonatomic, retain) IBOutlet UITableView*			view;
@property (nonatomic, retain) IBOutlet UIViewController*	controller;
@property (nonatomic, retain) id							delegate;
@property (nonatomic) UITableViewCellStyle					style;
@property (nonatomic, retain) NSString*						theme;
@property (nonatomic) CGFloat								cell_height;
@property (nonatomic) UITableViewCellAccessoryType			accessory_type;
@property (nonatomic) UITableViewCellSelectionStyle			cell_selection;
@property (nonatomic, retain) NSMutableArray*				accessories;
@property (nonatomic) CGRect								cell_image_rect;
@property (nonatomic) UIViewContentMode						cell_image_mode;
@property (nonatomic, retain) NSString*						cell_image_place;
@property (nonatomic) UITableViewRowAnimation				animation_delete;
@property (nonatomic) BOOL									can_edit;
@property (nonatomic) NSInteger								index_length;
@property (nonatomic, retain) NSIndexPath*					current_path;
@property (nonatomic, retain) NSString*						current_text;

@property (nonatomic, retain) IBOutlet NSMutableArray*		texts;
@property (nonatomic, retain) IBOutlet NSMutableArray*		details;
@property (nonatomic, retain) IBOutlet NSMutableArray*		images;
@property (nonatomic, retain) IBOutlet NSMutableArray*		image_urls;
@property (nonatomic, retain) IBOutlet NSMutableArray*		indexes;
@property (nonatomic, retain) IBOutlet NSMutableArray*		headers;
@property (nonatomic, retain) IBOutlet NSMutableArray*		footers;

@property (nonatomic, retain) IBOutlet UILabel*				text_label;
@property (nonatomic, retain) IBOutlet UILabel*				detail_label;

//@property (nonatomic, retain) IBOutlet UIImageView*			header_bg;
//@property (nonatomic, retain) IBOutlet UIImageView*			footer_bg;
@property (nonatomic, retain) IBOutlet UILabel*				header_label;
@property (nonatomic, retain) IBOutlet UILabel*				footer_label;

@property (nonatomic, retain) IBOutlet UIColor*				cell_bg_color;
@property (nonatomic, retain) IBOutlet NSString*			cell_bg;
@property (nonatomic, retain) IBOutlet NSString*			cell_bg_top;
@property (nonatomic, retain) IBOutlet NSString*			cell_bg_bottom;
@property (nonatomic, retain) IBOutlet NSString*			cell_bg_selected;
@property (nonatomic, retain) IBOutlet NSString*			cell_bg_top_selected;
@property (nonatomic, retain) IBOutlet NSString*			cell_bg_bottom_selected;
@property (nonatomic, retain) IBOutlet UIColor*				cell_bg_color_interlace;
@property (nonatomic, retain) IBOutlet NSString*			accessory_name;

- (id)initWithStyle:(UITableViewStyle)table_style;
- (id)initWithTableView:(UITableView*)table_view;

- (void)apply_theme_color:(UIColor*)a_color on:(UIColor*)bg_color;
- (void)apply_theme_white_on_red;
- (void)apply_theme_transparent_interlace;
- (void)apply_theme_metal01;

- (BOOL)load_from:(NSString*)filename;
- (void)save_to:(NSString*)filename;

- (void)add_view:(UIView*)a_view new_section:(NSInteger)section text:(NSString*)text;
- (void)add_view:(UIView*)a_view section:(NSInteger)section new_row:(NSInteger)row text:(NSString*)text;
- (void)add_view:(UIView*)a_view section:(NSInteger)section row:(NSInteger)row;		//	replace old cell
- (UIView*)get_additional_view:(NSIndexPath*)path;

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
- (NSString*)text_for_path:(NSIndexPath*)path;

//	strings only, 1 section only
- (void)apply_alphabet;

//	filter is experimental and may have problem with additional view, etc.
- (void)filter_apply:(NSString*)filter;
- (void)filter_restore;

@end
