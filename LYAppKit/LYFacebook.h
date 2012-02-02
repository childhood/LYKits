#import "LYPublic.h"

#ifdef LY_ENABLE_SDK_FACEBOOK
#	import "FBConnect.h"

/*
	// launch
	fb = [[LYFacebook alloc] init];

- (IBAction)action_facebook_login
{
	[fb authorize];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	if (fb) return [fb.facebook handleOpenURL:url]; else return NO;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	if (fb) return [fb.facebook handleOpenURL:url]; else return NO; 
}
*/

@interface LYFacebook: NSObject	<FBRequestDelegate, FBSessionDelegate, FBDialogDelegate>
{
	NSString* key;
}
@property (nonatomic, retain) NSMutableDictionary* data;
@property (nonatomic, retain) Facebook *facebook;
- (void)authorize;
- (void)request:(NSString*)a_key;

- (id)initWithKey:(NSString*)app_id;
- (void)post:(NSString*)s;
- (void)login;
- (void)logout;

@end
#endif	//	of LY_ENABLE_SDK_FACEBOOK

#if 0	//	disable old facebook code
#if 0
#	import "FBConnect/FBConnect.h"
#else
#	include "Facebook.h"
#	include "FBDialog.h"
#	include "FBLoginDialog.h"
#	include "FBRequest.h"
#	include "SBJSON.h"
#endif

/*
 * example
 *
	facebook = [[LYFacebook alloc] initWithKey:@"d0c80f44634375221153d731c1602db7"];
	s = [s stringByReplacingOccurrencesOfString:@"\n" withString:@"\r"];
	[facebook post:s];
 *
 */

//	#define	LY_ENABLE_FACEBOOK_DEBUG

@interface LYFacebook: NSObject <
	FBDialogDelegate,
	FBSessionDelegate,
	FBRequestDelegate
	>
{
	//FBSession*	facebook_session;
	Facebook*	facebook;
	BOOL		facebook_authorized;
	BOOL		facebook_has_permission;
	NSString*	message;
	NSString*	app_key;
	NSString*	title_failed;
	NSArray*	array_permissions;
}
@property (nonatomic, retain) NSString*		title_failed;

//	- (id)initWithApplication:(NSString*)app_id secret:(NSString*)secret;
- (id)initWithKey:(NSString*)app_id;
- (void)post:(NSString*)s;
- (void)login;
- (void)logout;

//	- (void)facebook_write_wall;
//	- (void)facebook_get_permission;
//	- (void)facebook_check_permission;

@end
#endif	//	disable old facebook code
