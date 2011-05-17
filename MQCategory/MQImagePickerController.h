#import "MQFoundation.h"
#import "MQUIKit.h"

@interface UIImagePickerController (MQImagePickerController)
UINavigationController*		mq_nav;
UIImageView*				mq_image;
id							mq_pop;
id							mq_delegate;

- (void)set_mq_image:(UIImageView*)an_image;
- (void)set_mq_delegate:(id)a_delegate;
- (void)get_image_nav:(UINavigationController*)nav image:(UIImageView*)view;
- (void)get_image_nav:(UINavigationController*)nav image:(UIImageView*)view delegate:(id)obj;
- (void)mq_dismiss;

@end
