#import <StoreKit/StoreKit.h>
#import "MQCategory.h"

/*
 * Example:
 *
- (void)init_store_ads
{
	controller_store = [[MQStoreController alloc] initWithString:@"tao.soft.miniapps.torchlight.unlock"];
	controller_store.delegate = self;
	if ([controller_store is_purchased] == NO)
	{
		controller_ads = [[MQAdsController alloc] initWithID:k_ads_modmyi];
		//	[controller_ads enable_test];

		if (is_phone())
		{
			[controller_ads.view_adwhirl set_position:CGPointMake(0, 20)];
			[controller_ads.view_mobclix_phone1 set_position:CGPointMake(0, 40 + 48)];
			[controller_ads.view_mobclix_phone2 set_position:CGPointMake(0, 40 + 48 + 20 + 50)];

			[controller_ads.view_adwhirl align_horizon_center];
			[controller_ads.view_mobclix_phone1 align_horizon_center];
			[controller_ads.view_mobclix_phone2 align_horizon_center];

			[nav_main.view addSubview:controller_ads.controller_mobclix_phone1.view];
			[nav_main.view addSubview:controller_ads.controller_mobclix_phone2.view];
			[nav_main.view addSubview:controller_ads.controller_adwhirl.view];
		}
		else
		{
			[controller_ads.view_adwhirl set_position:CGPointMake(0, 0)];
			[controller_ads.view_mobclix_pad1 set_position:CGPointMake(0, 48)];
			[controller_ads.view_mobclix_pad2 set_position:CGPointMake(0, 48 + 60)];
			[controller_ads.view_mobclix_pad4 set_position:CGPointMake(0, 48 + 60 + 250)];
			[controller_ads.view_mobclix_pad3 set_position:CGPointMake(0, 48 + 60 + 250 + 90)];

			[controller_ads.view_adwhirl align_horizon_center];
			[controller_ads.view_mobclix_pad1 align_horizon_center];
			[controller_ads.view_mobclix_pad2 align_horizon_center];
			[controller_ads.view_mobclix_pad3 align_horizon_center];
			[controller_ads.view_mobclix_pad4 align_horizon_center];

			[nav_main.view addSubview:controller_ads.controller_adwhirl.view];
			[nav_main.view addSubview:controller_ads.controller_mobclix_pad1.view];
			[nav_main.view addSubview:controller_ads.controller_mobclix_pad2.view];
			[nav_main.view addSubview:controller_ads.controller_mobclix_pad3.view];
			[nav_main.view addSubview:controller_ads.controller_mobclix_pad4.view];
		}
	}
}

- (void)store_payment_done
{
	[controller_ads hide_ads];
}

 */

@interface MQStoreController: UIViewController <UIActionSheetDelegate, 
	SKRequestDelegate, 
	SKProductsRequestDelegate, 
	SKPaymentTransactionObserver>
{
	NSString*					product_id;
	NSString*					setting_unlock;
	SKProductsRequest*			store_request;
	UIView*						main_view;
	UIAlertView*				alert_purchase;
	id							delegate;
}
@property (nonatomic, retain) id     delegate;

- (id)initWithString:(NSString*)pid;
- (id)init_with_id:(NSString*)an_id setting:(NSString*)a_setting view:(UIView*)a_view;
- (void)show_action_sheet:(NSString*)message;
- (void)payment_purchased;
- (BOOL)is_purchased;

@end
