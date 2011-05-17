#import "LYSingletonClass.h"
#import "LYRandom.h"
#import "LYXMLParser.h"
#import "LYCache.h"
#import "LYStateMachine.h"
#import "LYAppController.h"
#import "LYAppDelegate.h"

//	#define NSPointToString(p) [NSString stringWithFormat:@"<%.2f, ?, %.2f>", (p).x, (p).y]

BOOL is_phone(void);
BOOL is_pad(void);

void set_setting_bool(NSString* key, BOOL b);
void set_setting_integer(NSString* key, NSInteger i);
void set_setting_string(NSString* key, NSObject* obj);
BOOL setting_bool(NSString* key);
NSInteger setting_integer(NSString* key);
NSString* setting_string(NSString* key);

/*
 * LYSingletonClass
 * 		template of all the singleton classes like LYCache, LYRandom, etc.
 *
 * LYRandom
 * 		random colors, fonts, etc.
 *
 * LYXMLParser
 * 		a simple xml parser that converts an xml string into an array
 *
 * LYCache
 * 		downloading and caching contents of urls
 * 		can be used to passing objects between multiple classes
 *
 */
