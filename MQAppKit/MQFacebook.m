#import "MQFacebook.h"
#ifdef MQ_ENABLE_SDK_FACEBOOK

@implementation MQFacebook

@synthesize title_failed;

- (id)initWithKey:(NSString*)app_id
{
	self = [super init];
	if (self != nil)
	{
		app_key = app_id;

		facebook = [[Facebook alloc] init];
		array_permissions = [[NSArray alloc] initWithObjects:@"read_stream", @"offline_access",nil];

		facebook_has_permission = NO;
		facebook_authorized = YES;
		title_failed = @"Facebook Connection Failed";
	}
	return self;
}

- (void)login
{
	[facebook authorize:app_key permissions:array_permissions delegate:self];
}

- (void)logout
{
	[facebook logout:self];
}

/*
- (id)initWithApplication:(NSString*)app_id secret:(NSString*)secret
{
	self = [super init];
	if (self != nil)
	{
		//	facebook_session = [[FBSession sessionForApplication:app_id secret:secret delegate:self] retain];
		facebook = [[Facebook alloc] init];
		array_permissions = [[NSArray alloc] initWithObjects:@"read_stream", @"offline_access",nil];
		[facebook authorize:@"f66ded19648d950e531e8e9fee6fffb1" permissions:array_permissions delegate:self];

		facebook_has_permission = NO;
		title_failed = @"Facebook Connection Failed";
	}
	return self;
}
*/

- (void)dealloc
{
	[facebook release];
	[array_permissions release];
	[super dealloc];
}

- (void)post:(NSString*)s
{
	//	message = [s retain];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
		app_key, @"api_key",
		s, @"message",
		@"Share on Facebook", @"user_message_prompt",
		nil];

	if (facebook_authorized == NO)
	{
		facebook_authorized = YES;
		[self login];
	}

	[facebook dialog:@"stream.publish"
		   andParams:params
		 andDelegate:self];
#if 0
	if (facebook_session.isConnected) 
	{
		if ((facebook_session.sessionKey == nil) || ([facebook_session.sessionKey compare:@""] == NSOrderedSame))
		{
			//	[self init_facebook];
			FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:facebook_session] autorelease];
			[dialog show];
			[facebook_session resume];
		}
		else
		{
			//	[self init_facebook];
			FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:facebook_session] autorelease];
			[dialog show];
			return;
		}
		//	[self init_facebook];
	}
	else
	{
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:facebook_session] autorelease];
		[dialog show];
	}
#endif
}

#pragma mark facebook delegate

#if 0
- (void)session:(FBSession*)session didLogin:(FBUID)uid
{
	NSLog(@"FACEBOOK User with id %lld logged in.", uid);
	//	session = _sesssion;
	
	if (facebook_has_permission == YES)
	{
		[self facebook_write_wall];
		return;
	}
	else
	{
		[self facebook_check_permission];
	}
}

- (void)request:(FBRequest*)request didLoad:(id)result
{
	NSLog(@"FACEBOOK request did load: %@", result);
	if ([(NSString*)result isEqualToString:@"1"])
	{
		facebook_has_permission = YES;
		[self facebook_write_wall];
	}
	else
	{
		//	[@"Facebook Connection Failed" show_alert_message:@"Cannot connect to Facebook. Please try again later."];
		facebook_has_permission = NO;
		[self facebook_get_permission];
	}
	//	[message release];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	NSString *msg = [error localizedDescription];

	NSLog(@"FACEBOOK Request did fail: %@", msg);
	[title_failed show_alert_message:msg];
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error 
{
	NSString *msg = [error localizedDescription];

	NSLog(@"FACEBOOK Dialog did fail: %@", msg);
	[@"Failed" show_alert_message:msg];
}

- (void)dialogDidSucceed:(FBDialog *)dialog
{
	if ([dialog isMemberOfClass:[FBLoginDialog class]])
	{
		if ([facebook_session resume] == YES)
		{
			NSLog(@"FACEBOOK [FBLoginDialog::dialogDidSucceed] just did succeed");
		}
	}
	else if ([dialog isMemberOfClass:[FBPermissionDialog class]])
	{
		[@"Success" show_alert_message:@"The message has been published to your facebook successfully."];
		NSLog(@"FACEBOOK [FBPermissionDialog::dialogDidSucceed] update user status");
		//	[self facebook_check_permission];
	}
	else
	{
		NSLog(@"FACEBOOK dialog succeeded");
	}
}

#pragma mark facebook actions

- (void)facebook_write_wall
{
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
	[[FBRequest requestWithDelegate:self] call:@"facebook.stream.publish" params:params];
}

-(void)facebook_check_permission
{
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: @"status_update", @"ext_perm", nil];
	[[FBRequest requestWithDelegate:self] call:@"facebook.users.hasAppPermission" params:params];
}

- (void)facebook_get_permission
{
	FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.session = facebook_session;
	dialog.permission = @"publish_stream";
	[dialog show];
}
#endif

- (void)fbDidLogin
{
	NSLog(@"FACEBOOK logged in");
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	NSLog(@"FACEBOOK not logged in");
}

- (void)dialogDidComplete:(FBDialog*)dialog
{
	NSLog(@"FACEBOOK dialog completed");
	//	[@"Success" show_alert_message:@"The message has been published to your facebook successfully."];
}

- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
	NSLog(@"FACEBOOK request got response");
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	NSLog(@"FACEBOOK request failed");
}

- (void)request:(FBRequest*)request didLoad:(id)result
{
	NSLog(@"FACEBOOK request loaded");
}

@end
#endif	//	of MQ_ENABLE_SDK_FACEBOOK
