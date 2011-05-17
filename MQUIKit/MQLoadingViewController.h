//#import <Foundation/Foundation.h>
#import "MQPublic.h"

/*
 * example
 *
 	[MQLoading enable_label:nil];
 	[MQLoading set_theme:@"national motto"];
	[[MQLoading shared] setNav:mainNavigationController];
 *
 */

@interface MQLoadingViewController: MQSingletonViewController
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
@interface MQLoading: MQLoadingViewController
@end
