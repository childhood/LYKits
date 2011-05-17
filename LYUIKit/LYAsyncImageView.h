#import <UIKit/UIKit.h>
#import "LYCategory.h"

@interface LYAsyncImageView: UIImageView 
{
    NSURLConnection*	connection;
    NSMutableData*		data;
	NSString*			filename;
	BOOL				is_downloading;
}

- (void)load_url:(NSString *)theUrlString;

@end

//	TODO: combine these two classes
@interface LYAsyncButton: UIButton 
{
    NSURLConnection*	connection;
    NSMutableData*		data;
	NSString*			filename;
	BOOL				is_downloading;
}

- (void)load_url:(NSString *)theUrlString;

@end
