#import "MQStoreController.h"

@implementation MQStoreController

@synthesize delegate;

- (id)initWithString:(NSString*)pid
{
	return [self init_with_id:pid setting:pid view:nil];
}

- (BOOL)is_purchased
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:product_id];
}

- (id)init_with_id:(NSString*)an_id setting:(NSString*)a_setting view:(UIView*)a_view
{
	self = [super init];

	product_id		= an_id;
	setting_unlock	= a_setting;
	main_view		= a_view;

	if ([SKPaymentQueue canMakePayments])
	{
		NSLog(@"STORE available");
		if ([[NSUserDefaults standardUserDefaults] boolForKey:setting_unlock] == NO)
		{
			store_request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:product_id]];
			store_request.delegate = self;
			[store_request start];
			NSLog(@"STORE request sent");
		}
		else
		{
			NSLog(@"STORE item already purchased");
		}
	}
	else
	{
		NSLog(@"STORE *NOT* available");
	}

	return self;
}

/*
 * store delegates
 */
- (void)requestDidFinish:(SKRequest *)request
{
	NSLog(@"storekit request finish");
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"storekit got error: %i - %@", error.code, error.localizedDescription);
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	int i;

	NSLog(@"storekit got response:\nPRODUCTS %@\nINVALID %@", 
			response.products.description, response.invalidProductIdentifiers.description);

	for (i = 0; i < response.products.count; i++)
	{
#if 0
		NSLog(@"%i title: %@", i, [[response.products objectAtIndex:i] localizedTitle]);
		NSLog(@"%i desc: %@", i, [[response.products objectAtIndex:i] localizedDescription]);
		NSLog(@"%i id: %@", i, [[response.products objectAtIndex:i] productIdentifier]);
		NSLog(@"%i price: %.02f", i, [[[response.products objectAtIndex:i] price] floatValue]);
		NSLog(@"%i price: %@", i, [[[response.products objectAtIndex:i] price] descriptionWithLocale:
				[[response.products objectAtIndex:i] priceLocale]]);
		NSLog(@"%i locale: %@", i, [[[response.products objectAtIndex:i] priceLocale] description]);
#endif
	}

	if (response.products.count > 0)
	{
		//	[self show_action_sheet:[NSString stringWithFormat:@"Thanks for downloading this app!\n\nBy choosing \"OK\" and finish the purchasing, you can get rid of the banner ads as well as this startup prompt once and for all. Would you like to support us in this way?\n\nThanks in advance!"]];
		[self show_action_sheet:[NSString stringWithFormat:@"%@\n\n%@", [[response.products objectAtIndex:0] localizedTitle], [[response.products objectAtIndex:0] localizedDescription]]];
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
	NSLog(@"TRANSACTION removed: %@", transactions.description);
}

- (void)paymentQueue:(SKPaymentQueue *)queuerestoreCompletedTransactionsFailedWithError:(NSError *)error
{
	NSLog(@"TRANSACTION got error: %i", error.code);
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	NSLog(@"TRANSACTION updated %i: %@", transactions.count, transactions.description);

	for (SKPaymentTransaction *transaction in transactions)
	{
		//	NSLog(@"state: %i", transaction.transactionState);
		//	NSLog(@"id: %i", transaction.transactionIdentifier);
				//	transaction.error.localizedFailureReason,
				//	transaction.error.localizedRecoverySuggestion);

		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased: 
				NSLog(@"TRANSACTION purchased - settings saved");
				[self payment_purchased];
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored: 
				NSLog(@"TRANSACTION restored - settings saved");
				[self payment_purchased];
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				break;
			case SKPaymentTransactionStatePurchasing:
				NSLog(@"TRANSACTION purchasing");
				//	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
				break;
			case SKPaymentTransactionStateFailed: 
				NSLog(@"TRANSACTION failed: %i, %@", transaction.error.code, transaction.error.localizedDescription);
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				break;
			default:
				NSLog(@"OTHER TRANSACTION STATE");
		}
	}
}

- (void)payment_purchased
{
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:setting_unlock];
	//show_view_alert(@"Thanks for your support!", @"The banner ads and the prompt upon startup will be removed when you restart this app.\n\nEnjoy yourself!");
	[@"Thanks for your support!" show_alert_message:@"Please restart this app to apply the changes. If you're running iOS 4.x or later, you need to double-press the home button, and close this app from the background apps list.\n\nEnjoy yourself!"];
	if (delegate != nil)
		[delegate perform_string:@"store_payment_done"];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
	NSLog(@"TRANSACTION completed");
}

- (void)show_action_sheet:(NSString*)message
{
	alert_purchase = [[UIAlertView alloc] initWithTitle:@"Thank You"
												message:message
											   delegate:self
									  cancelButtonTitle:@"OK"
									 otherButtonTitles:@"No Thanks", nil];
	[alert_purchase show];
#if 0
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:message
															 delegate:self 
													cancelButtonTitle:@"No Thanks" 
											   destructiveButtonTitle:@"OK" 
													otherButtonTitles:nil];

	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	//	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	//	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showInView:main_view];
	[actionSheet release];
#endif
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView == alert_purchase)
	{
		[self actionSheet:nil clickedButtonAtIndex:buttonIndex];		
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	SKPayment* payment;

	NSLog(@"ACTIONSHEET click: %i", buttonIndex);

	switch (buttonIndex)
	{
		case 0:
			[[SKPaymentQueue defaultQueue] addTransactionObserver:self];

			payment = [SKPayment paymentWithProductIdentifier:product_id]; 
			[[SKPaymentQueue defaultQueue] addPayment:payment];
			NSLog(@"PAYMENT sent to queue...");
			break;
	}
}

@end
