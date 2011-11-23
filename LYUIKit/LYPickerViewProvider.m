#import "LYPickerViewProvider.h"


@implementation LYPickerViewProvider

@synthesize titles;
@synthesize delegate;

- (id)initWithPicker:(UIPickerView*)picker
{
	self = [super init];
	if (self != nil)
	{
		delegate = nil;
		picker.delegate = self;
		picker.dataSource = self;
		titles = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[titles release];
	[super dealloc];
}

#pragma mark delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (delegate != nil)
		objc_msgSend(delegate, @selector(pickerView:didSelectRow:inComponent:), self, self, row, component);
}

#pragma mark data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return titles.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [[titles objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [[titles objectAtIndex:component] objectAtIndex:row];
}

@end
