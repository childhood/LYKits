#import "MQPublic.h"

#ifdef MQ_ENABLE_SDK_FACEBOOK
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
	facebook = [[MQFacebook alloc] initWithKey:@"d0c80f44634375221153d731c1602db7"];
	s = [s stringByReplacingOccurrencesOfString:@"\n" withString:@"\r"];
	[facebook post:s];
 *
 */

//	#define	MQ_ENABLE_FACEBOOK_DEBUG

@interface MQFacebook: NSObject <
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
#endif	//	of MQ_ENABLE_SDK_FACEBOOK
