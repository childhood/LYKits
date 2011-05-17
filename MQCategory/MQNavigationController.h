#import "MQPublic.h"

@interface UINavigationController (MQNavigationController)

- (void)push:(UIViewController*)controller transition:(UIViewAnimationTransition)transition;
- (void)pop_transition:(UIViewAnimationTransition)transition;

#ifdef MQ_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_LANDSCAPE
#endif

#ifdef MQ_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATE
//@interface UINavigationController (MQNavigationController)
//BOOL	rotatable;
//- (id)init;
//- (id)initWithFrame:(CGRect)rect;
//- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle;
//- (BOOL)rotatable;
//- (void)set_rotatable:(BOOL)b;
//@end
#endif
@end
