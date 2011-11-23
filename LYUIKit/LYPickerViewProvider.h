#import "LYKits.h"

@interface LYPickerViewProvider: NSObject <UIPickerViewDelegate, UIPickerViewDataSource>
{
	NSMutableArray*		titles;
	NSObject*			delegate;
}
@property (nonatomic, retain) NSMutableArray*	titles;
@property (nonatomic, retain) NSObject*			delegate;

- (id)initWithPicker:(UIPickerView*)picker;
//	- (id)initWithTitles:(NSArray*)titles;

@end


