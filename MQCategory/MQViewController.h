#import "MQPublic.h"

@interface UIViewController (MQViewController)
- (id)initWithView:(UIView*)a_view;
#ifdef MQ_ENABLE_CATEGORY_VIEWCONTROLLER_ROTATE
BOOL	rotatable;
id		delegate;
//id <MQRotatableViewControllerDelegate>	delegate;
- (void)set_delegate:(id)an_obj;
- (void)set_rotatable:(BOOL)b;
- (BOOL)rotatable;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
#endif
@end
