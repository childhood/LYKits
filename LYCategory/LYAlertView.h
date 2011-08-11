#import "LYFoundation.h"
#import "LYCategory.h"

//typedef void(^LYBlockAlertConfirm)(BOOL confirmed);

@interface UIAlertView (LYAlertView)

+ (void)alertWithTitle:(NSString*)title message:(NSString*)msg 
			   confirm:(NSString*)confirm cancel:(NSString*)cancel block:(LYBlockVoidInt)callback;
+ (void)alertWithTitle:(NSString*)title message:(NSString*)msg block:(LYBlockVoidInt)callback;

@end
