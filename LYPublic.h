typedef void(^LYBlockVoidVoid)(void);
typedef void(^LYBlockVoidBool)(BOOL b);
typedef void(^LYBlockVoidInt)(int i);
typedef void(^LYBlockVoidError)(NSError* error);
typedef void(^LYBlockVoidIntError)(int i, NSError* error);
typedef void(^LYBlockVoidArrayError)(NSArray* array, NSError* error);
typedef void(^LYBlockVoidDictError)(NSDictionary* dict, NSError* error);
typedef void(^LYBlockVoidString)(NSString* str);
typedef void(^LYBlockVoidStringError)(NSString* str, NSError* error);
typedef void(^LYBlockVoidObjError)(id obj, NSError* error);
typedef BOOL(^LYBlockBoolString)(NSString* str);
typedef BOOL(^LYBlockBoolArrayError)(NSArray* array, NSError* error);

//	disabled: use -fno-objc-arc instead
#ifdef TMP_LY_ENABLE_IOS5
#	define autorelease self
#	define release self
#	define retain self
#endif

#import "LYCategory.h"
#import "LYFoundation.h"
#import "LYUIKit.h"
#import "LYAppKit.h"

//	test
void ly_upload_file(NSString* filename, NSString* arg_id, NSString* desc);

//	#define LY_ENABLE_CATEGORY_NAVIGATIONBAR_BACKGROUND
//	#define LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_LANDSCAPE
//	#define LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATE
//	#define LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATEPHONE
//	#define LY_ENABLE_CATEGORY_VIEWCONTROLLER_ROTATE	//	XXX: don't use this
//
//	#define LY_ENABLE_IOS5								//	ARC & storyboard
//	#define LY_ENABLE_SDK_FACEBOOK						//	XXX: replaced by SHK
//	#define LY_ENABLE_APP_STORE
//	#define LY_ENABLE_APP_ADS
//	#define LY_ENABLE_APP_ZIP
//	#define LY_ENABLE_LIB_AIML
//	#define LY_ENABLE_MUSICKIT
//	#define LY_ENABLE_MAPKIT
//	#define LY_ENABLE_SERVICEKIT
//	#define LY_ENABLE_SDK_ASIHTTP
//	#define LY_ENABLE_SDK_TOUCHJSON
//	#define LY_ENABLE_SDK_AWS
//
//	#define LY_ENABLE_OPENAL

//	Optional modules:	supersound, map, music
//	SDK needed modules:	ads, store, gamecenter

#ifdef LY_ENABLE_MUSICKIT
#	import "LYMusicKit.h"
#endif
#ifdef LY_ENABLE_MAPKIT
	#import "LYMapKit.h"
#endif
#ifdef LY_ENABLE_SERVICEKIT
	#import "LYServiceKit.h"
#endif
#ifdef LY_ENABLE_LIB_AIML
@interface LYAiml: NSObject
{
	NSMutableDictionary*	data;
}
@property (retain, nonatomic) NSMutableDictionary*	data;

- (int)load;
- (NSString*)respond:(NSString*)s;

@end
#endif

#ifndef _g
#define _g(x)	NSLocalizedString(x, nil)
#endif

#ifndef _G
#define _G(x)	NSLocalizedString(x, nil)
#endif

//	name wrap

#define MQ3DImageView LY3DImageView
#define MQES1Renderer LYES1Renderer
#define MQAsyncImageView LYAsyncImageView
#define MQAsyncButton LYAsyncButton
#define MQBrowserController LYBrowserController
#define MQButtonMatrixController LYButtonMatrixController
#define MQImagePickerController LYImagePickerController
#define MQKeyboardMatrixController LYKeyboardMatrixController
#define MQLoadingViewController LYLoadingViewController
#define MQLoading LYLoading
#define MQMiniAppsController LYMiniAppsController
#define MQTiledPDFView LYTiledPDFView
#define MQPDFScrollView LYPDFScrollView
#define MQPDFViewController LYPDFViewController
#define MQScrollTabController LYScrollTabController
#define MQShareController LYShareController
#define MQTableViewProvider LYTableViewProvider
#define MQTextAlertView LYTextAlertView
#define MQMiniApps LYMiniApps
#define MQSpinImageView LYSpinImageView
#define MQMusicJukeboxController LYMusicJukeboxController
#define MQMusicJukeboxTableViewController LYMusicJukeboxTableViewController
#define MQAnnotation LYAnnotation
#define MQMapViewProvider LYMapViewProvider
#define MQAppController LYAppController
#define MQAppDelegate LYAppDelegate
#define MQCache LYCache
#define MQRandom LYRandom
#define MQSingletonClass LYSingletonClass
#define MQSingletonViewController LYSingletonViewController
#define MQStateMachine LYStateMachine
#define MQXMLParser LYXMLParser
#define MQAdsController LYAdsController
#define MQFacebook LYFacebook
#define MQFeedParser LYFeedParser
#define MQGCController LYGCController
#define MQModalAppController LYModalAppController
#define MQStoreController LYStoreController
