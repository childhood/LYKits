#import "MQCategory.h"
#import "MQFoundation.h"
#import "MQUIKit.h"
#import "MQAppKit.h"

void mq_upload_file(NSString* filename, NSString* arg_id, NSString* desc);

//	#define MQ_ENABLE_CATEGORY_NAVIGATIONBAR_BACKGROUND
//	#define MQ_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_LANDSCAPE
//	#define MQ_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATE
//	#define MQ_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATEPHONE
//	#define MQ_ENABLE_CATEGORY_VIEWCONTROLLER_ROTATE	//	XXX: study needed
//	#define MQ_ENABLE_SDK_FACEBOOK						//	XXX: replaced by SHK
//	#define MQ_ENABLE_APP_STORE
//	#define MQ_ENABLE_APP_ADS
//	#define MQ_ENABLE_MUSICKIT
//	#define MQ_ENABLE_MAPKIT
//	#define MQ_ENABLE_SDK_ASIHTTP
//	#define MQ_ENABLE_SDK_TOUCHJSON

#ifdef MQ_ENABLE_MUSICKIT
#	import "MQMusicKit.h"
#endif
#ifdef MQ_ENABLE_MAPKIT
	#import "MQMapKit.h"
#endif

#ifndef _g
#define _g(x)	NSLocalizedString(x, nil)
#endif

#ifndef _G
#define _G(x)	NSLocalizedString(x, nil)
#endif
