#import "LYPublic.h"

@interface UIViewController (LYViewController)
- (id)initWithView:(UIView*)a_view;
#ifdef LY_ENABLE_CATEGORY_VIEWCONTROLLER_ROTATE
BOOL	rotatable;
id		delegate;
//id <LYRotatableViewControllerDelegate>	delegate;
- (void)set_delegate:(id)an_obj;
- (void)set_rotatable:(BOOL)b;
- (BOOL)rotatable;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
#endif
@end
