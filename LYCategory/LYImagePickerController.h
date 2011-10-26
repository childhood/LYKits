#import "LYFoundation.h"
#import "LYUIKit.h"

@interface UIImagePickerController (LYImagePickerController)
/*
UINavigationController*		ly_nav;
UIImageView*				ly_image;
id							ly_pop;
id							ly_delegate;
*/

- (void)set_image:(UIImageView*)an_image;
- (void)set_delegate:(id)a_delegate;
- (void)get_image_nav:(UINavigationController*)nav image:(UIImageView*)view;
- (void)get_image_nav:(UINavigationController*)nav image:(UIImageView*)view delegate:(id)obj;
- (void)ly_dismiss;

@end
