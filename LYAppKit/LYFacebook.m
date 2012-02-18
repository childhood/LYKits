#import "LYFacebook.h"

#ifdef LY_ENABLE_SDK_FACEBOOK
@implementation LYFacebook

@synthesize data;
@synthesize delegate;
@synthesize facebook;

- (id)init
{
	self = [super init];
	if (self)
	{
		facebook = [[Facebook alloc] initWithAppId:@"137789882939322" andDelegate:self];
		delegate = nil;
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"])
		{
			facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
			facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
		}
		if ([facebook isSessionValid])
			[self request:@"me"];
		data = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[data release];
	[super dealloc];
}

- (void)request:(NSString*)a_key
{
	key = a_key;
	[facebook requestWithGraphPath:key andDelegate:self];
}

- (BOOL)authorize
{
	if (![facebook isSessionValid])
	{
		NSLog(@"FACEBOOK authorizing...");
		[facebook authorize:[NSArray arrayWithObjects:@"offline_access", @"publish_stream", @"user_about_me", @"user_photos", nil]];
		return YES;
	}
	else
		return NO;
}

- (id)initWithKey:(NSString*)app_id
{
	self = [super init];
	return self;
}

- (void)post:(NSString*)s
{
	//	TODO: dialog
#if 1
	//[facebook dialog:s andDelegate:self];
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:s, @"message", nil];
	[facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:nil];
#else
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:s, @"message", nil];
    [facebook dialog:@"apprequests" andParams:params andDelegate:self];
#endif
}

- (void)post_image:(UIImage*)image message:(NSString*)s
{
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
		image, @"source", 
		s, @"message",             
		nil];
	//	[facebook requestWithGraphPath:[NSString stringWithFormat:@"/me/photos?access_token=%@", self.facebook.accessToken]
	//						 andParams:params andHttpMethod:@"POST" andDelegate:self];
	[facebook requestWithGraphPath:@"/me/photos/" andParams:params andHttpMethod:@"POST" andDelegate:self];
}

- (void)login
{
}

- (void)logout
{
}

#pragma mark delegate session

- (void)fbDidLogin
{
	NSLog(@"FACEBOOK logged in");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	[facebook requestWithGraphPath:@"me" andDelegate:self];
	if (delegate != nil)
		[delegate perform_string:@"facebook_logged_in"];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	NSLog(@"FACEBOOK not logged in");
}

- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt
{
	NSLog(@"FACEBOOK token extended");
}

- (void)fbDidLogout
{
	NSLog(@"FACEBOOK logged out");
}

- (void)fbSessionInvalidated
{
}

#pragma mark delegate request

- (void)requestLoading:(FBRequest *)request
{
	NSLog(@"FACEBOOK loading: %@", request);
}

- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response
{
	NSLog(@"FACEBOOK request got response: %@", response);
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	NSLog(@"FACEBOOK request failed: %@", error);
}

- (void)request:(FBRequest*)request didLoad:(id)result
{
	NSLog(@"FACEBOOK request loaded: %@", key);
	if ((result != nil) && (key != nil))
		[data key:key v:result];
	else
		NSLog(@"WARNING got nil");
	if (delegate != nil)
		[delegate perform_string:@"facebook_request_loaded"];
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
	NSLog(@"FACEBOOK dialog error: %@", error);
	//NSLog(@"more info: %@", error.userInfo);
	//[facebook dialog:@"test2" andDelegate:self];
}

@end 
#endif	//	of LY_ENABLE_SDK_FACEBOOK


#if 0	//	disable old facebook code
@implementation LYFacebook

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
#endif	//	disable old facebook code
