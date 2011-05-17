#import <UIKit/UIKit.h>
#import "MQCategory.h"

@interface MQAsyncImageView: UIImageView 
{
    NSURLConnection*	connection;
    NSMutableData*		data;
	NSString*			filename;
	BOOL				is_downloading;
}

- (void)load_url:(NSString *)theUrlString;

@end

//	TODO: combine these two classes
@interface MQAsyncButton: UIButton 
{
    NSURLConnection*	connection;
    NSMutableData*		data;
	NSString*			filename;
	BOOL				is_downloading;
}

- (void)load_url:(NSString *)theUrlString;

@end
