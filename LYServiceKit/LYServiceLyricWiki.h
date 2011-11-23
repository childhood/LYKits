#import "LYServiceKit.h"

#ifdef LY_ENABLE_SDK_ASIHTTP
@interface LYServiceLyricWiki: NSObject
{
	NSMutableDictionary* data;
}
@property (nonatomic, retain) NSMutableDictionary*	data;

- (void)lyric_by_artist:(NSString*)artist song:(NSString*)song block:(LYBlockVoidStringError)callback;

@end
#endif
