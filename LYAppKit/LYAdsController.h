#import "ARRollerView.h"
#import "ARRollerProtocol.h"
#import "Mobclix.h"
#import "MobclixAds.h"
#import "LYPublic.h"

/*
 * TODO
 *
 * 	Add frameworks
 *	Other linker flags: add "-ObjC"
 *	Sample code - check LYStoreController.h
 *
 */

/*
   Foundation.framework
   UIKit.framework

   AddressBook.framework
   CoreGraphics.framework
   CoreLocation.framework
   QuartzCore.framework

   libsqlite3.dylib
   libxml2.dylib
   libz.dylib
   SystemConfiguration.framework

   libAdRollDevice.a
   libAdRollSimulator.a
*/

#define k_ads_asianboobs		0
#define k_ads_hotgirls			1
#define k_ads_modmyi			2

#define k_ads_mobclix_refresh	30.0

@interface LYAdsController: UIViewController <ARRollerDelegate, MobclixAdViewDelegate>
{
	int					app_id;
	AdWhirlView*		view_adwhirl;
	MobclixAdView*		view_mobclix_phone1;
	MobclixAdView*		view_mobclix_phone2;
	MobclixAdView*		view_mobclix_pad1;
	MobclixAdView*		view_mobclix_pad2;
	MobclixAdView*		view_mobclix_pad3;
	MobclixAdView*		view_mobclix_pad4;
	//MMABannerXLAdView*	bannerAdView;
	UIViewController*	controller_adwhirl;
	UIViewController*	controller_mobclix_phone1;
	UIViewController*	controller_mobclix_phone2;
	UIViewController*	controller_mobclix_pad1;
	UIViewController*	controller_mobclix_pad2;
	UIViewController*	controller_mobclix_pad3;
	UIViewController*	controller_mobclix_pad4;
	//UIViewController*	controller_mobclix;
	//CGRect				rect_adwhirl;
	CGRect				current_rect_mobclix;
	UIView*				superview_adwhirl;
	UIView*				superview_mobclix_phone1;
	UIView*				superview_mobclix_phone2;
	UIView*				superview_mobclix_pad1;
	UIView*				superview_mobclix_pad2;
	UIView*				superview_mobclix_pad3;
	UIView*				superview_mobclix_pad4;
	UIView*				superview_mobclix;
}
@property (nonatomic, retain) AdWhirlView*		view_adwhirl;
@property (nonatomic, retain) MobclixAdView*	view_mobclix_phone1;
@property (nonatomic, retain) MobclixAdView*	view_mobclix_phone2;
@property (nonatomic, retain) MobclixAdView*	view_mobclix_pad1;
@property (nonatomic, retain) MobclixAdView*	view_mobclix_pad2;
@property (nonatomic, retain) MobclixAdView*	view_mobclix_pad3;
@property (nonatomic, retain) MobclixAdView*	view_mobclix_pad4;
@property (nonatomic, retain) UIViewController*	controller_adwhirl;
@property (nonatomic, retain) UIViewController*	controller_mobclix_phone1;
@property (nonatomic, retain) UIViewController*	controller_mobclix_phone2;
@property (nonatomic, retain) UIViewController*	controller_mobclix_pad1;
@property (nonatomic, retain) UIViewController*	controller_mobclix_pad2;
@property (nonatomic, retain) UIViewController*	controller_mobclix_pad3;
@property (nonatomic, retain) UIViewController*	controller_mobclix_pad4;

- (id)initWithID:(int)app;
- (MobclixAdView*)init_mobclix:(NSString*)a_class frame:(CGRect)rect;
//	- (id)init_with_app:(int)app to:(UIView*)window adwhirl:(CGRect)rect_adwhirl mobclix:(CGRect)rect_mobclix;
//	- (id)init_with_app:(int)app to:(UIView*)window adwhirl:(CGRect)rect_adwhirl mobclix:(CGRect)rect_mobclix controller:(UIViewController*)controller;
- (void)hide_ads;
- (void)show_ads;
- (NSString*)get_mobclix_id;
- (void)enable_test;
- (void)set_alpha:(CGFloat)alpha;

@end

