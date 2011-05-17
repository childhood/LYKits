//#import <Foundation/Foundation.h>
#import "LYPublic.h"

/*
 * example
 *
 	[LYLoading enable_label:nil];
 	[LYLoading set_theme:@"national motto"];
	[[LYLoading shared] setNav:mainNavigationController];
 *
 */

@interface LYLoadingViewController: LYSingletonViewController
{
	IBOutlet UILabel*		label_loading;
	UINavigationController*	nav;
	NSString*				theme;
}
@property (nonatomic, retain) UILabel*					label_loading;
@property (nonatomic, retain) UINavigationController*	nav;
@property (nonatomic, retain) NSString*					theme;
+ (id)shared;
+ (UIView*)view;
+ (UILabel*)label_loading;
+ (NSString*)theme;
+ (void)set_theme:(NSString*)a_theme;

+ (void)show;
+ (void)hide;
+ (void)start_loading_animation;

+ (void)enable_label:(NSString*)s;
//	+ (void)enable_national_motto;
@end

//	name warp
@interface LYLoading: LYLoadingViewController
@end
