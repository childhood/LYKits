#include "LYCategory.h"

@interface NSObject (LYObject)

//	safely perform a selector as string
- (id)perform_string:(NSString*)string;
- (id)perform_string:(NSString*)string with:(id)obj;
- (id)perform_string:(NSString*)string with:(id)obj1 with:(id)obj2;

//	safely perform a selector
- (id)perform_selector:(SEL)selector with:(id)obj1 with:(id)obj2;
- (id)perform_selector:(SEL)selector;
- (id)perform_selector:(SEL)selector with:(id)obj;

@end
