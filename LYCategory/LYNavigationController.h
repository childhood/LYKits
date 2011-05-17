#import "LYPublic.h"

@interface UINavigationController (LYNavigationController)

- (void)push:(UIViewController*)controller transition:(UIViewAnimationTransition)transition;
- (void)pop_transition:(UIViewAnimationTransition)transition;

#ifdef LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_LANDSCAPE
#endif

#ifdef LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATE
//@interface UINavigationController (LYNavigationController)
//BOOL	rotatable;
//- (id)init;
//- (id)initWithFrame:(CGRect)rect;
//- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle;
//- (BOOL)rotatable;
//- (void)set_rotatable:(BOOL)b;
//@end
#endif
@end
