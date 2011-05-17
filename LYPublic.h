#import "LYCategory.h"
#import "LYFoundation.h"
#import "LYUIKit.h"
#import "LYAppKit.h"

void ly_upload_file(NSString* filename, NSString* arg_id, NSString* desc);

//	#define LY_ENABLE_CATEGORY_NAVIGATIONBAR_BACKGROUND
//	#define LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_LANDSCAPE
//	#define LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATE
//	#define LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATEPHONE
//	#define LY_ENABLE_CATEGORY_VIEWCONTROLLER_ROTATE	//	XXX: study needed
//	#define LY_ENABLE_SDK_FACEBOOK						//	XXX: replaced by SHK
//	#define LY_ENABLE_APP_STORE
//	#define LY_ENABLE_APP_ADS
//	#define LY_ENABLE_MUSICKIT
//	#define LY_ENABLE_MAPKIT
//	#define LY_ENABLE_SDK_ASIHTTP
//	#define LY_ENABLE_SDK_TOUCHJSON

#ifdef LY_ENABLE_MUSICKIT
#	import "LYMusicKit.h"
#endif
#ifdef LY_ENABLE_MAPKIT
	#import "LYMapKit.h"
#endif

#ifndef _g
#define _g(x)	NSLocalizedString(x, nil)
#endif

#ifndef _G
#define _G(x)	NSLocalizedString(x, nil)
#endif
