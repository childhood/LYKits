#import "MQObject.h"
#import "MQString.h"
#import "MQArray.h"
#import "MQMutableArray.h"
#import "MQColor.h"
#import "MQView.h"
#import "MQScrollView.h"
#import "MQLabel.h"
#import "MQTableView.h"
#import "MQImageView.h"
#import "MQWebView.h"
#import "MQButton.h"
#import "MQImage.h"
#import "MQDevice.h"
#import "MQControl.h"
#import "MQImagePickerController.h"

/*
 * enable the macros below to enable navigation background, rotation, etc.
 * see each header file for detailed documents (most of the message names are self-explained)
 */

//	#define MQ_ENABLE_CATEGORY_NAVIGATIONBAR_BACKGROUND
//	#define MQ_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATE
//	#define MQ_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATEPHONE
//	#define MQ_ENABLE_CATEGORY_VIEWCONTROLLER_ROTATE

#import "MQNavigationBar.h"
#import "MQViewController.h"
#import "MQNavigationController.h"

@protocol MQRotatableViewControllerDelegate
- (BOOL)respondsToSelector:(SEL)selector;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
@end

#pragma mark OTHERS

#pragma mark MQMutableDictionary

@interface NSMutableDictionary (MQMutableDictionary)
- (void)set_string:(NSString*)str key:(NSString*)key;
@end

@implementation NSMutableDictionary (MQMutableDictionary)
- (void)set_string:(NSString*)str key:(NSString*)key
{
	if (str != nil)
		if ([str isKindOfClass:[NSString class]])
		{
			[self setValue:str forKey:key];
			return;
		}
	[self setValue:@"" forKey:key];
}
@end

#pragma mark MQDate

@interface NSDate (MQDate)
- (BOOL)is_same_date:(NSDate*)date1;
- (BOOL)is_same_month:(NSDate*)date1;
@end

@implementation NSDate (MQDate)
- (BOOL)is_same_month:(NSDate*)date1
{
	NSCalendar* calendar = [NSCalendar currentCalendar];

	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
	NSDateComponents* comp2 = [calendar components:unitFlags fromDate:self];

	return [comp1 month] == [comp2 month] && [comp1 year] == [comp2 year];
}
- (BOOL)is_same_date:(NSDate*)date1
{
	NSCalendar* calendar = [NSCalendar currentCalendar];

	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
	NSDateComponents* comp2 = [calendar components:unitFlags fromDate:self];

	return [comp1 day] == [comp2 day] &&
		[comp1 month] == [comp2 month] &&
		[comp1 year]  == [comp2 year];
}
@end

//	TODO: this is not needed so far. Let it be here for a while...

#if 0
@interface UITableViewCell (MQTableViewCell)
- (void)copy_style:(UITableViewCell*)target;
@end

@implementation UITableViewCell (MQTableViewCell)

- (void)copy_style:(UITableViewCell*)target
{
	if (target.hidden == NO)
	{
		[super copy_style:target];
		self.backgroundView			= target.backgroundView;
		self.selectedBackgroundView	= target.selectedBackgroundView;
		self.accessoryType			= target.accessoryType		;
		self.accessoryView			= target.accessoryView;
		self.editingAccessoryType	= target.editingAccessoryType		;
		self.editingAccessoryView	= target.editingAccessoryView;
	}
}

@end
#endif


//	TODO: forget about this for now...

#if 0
#import "FontLabel.h"
#import "FontManager.h"
#import "FontLabelStringDrawing.h"
#import "MyFont.h"

@class MyFont;

@interface UILabel (MQFontLabel)
	void *reserved; // works around a bug in UILabel
	MyFont *_MyFont;
@property (nonatomic, setter=setCGFont:) CGFontRef cgFont __AVAILABILITY_INTERNAL_DEPRECATED;
@property (nonatomic, assign) CGFloat pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
@property (nonatomic, retain, setter=setMyFont:) MyFont *_MyFont;
// -initWithFrame:fontName:pointSize: uses FontManager to look up the font name
- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName pointSize:(CGFloat)pointSize;
- (id)initWithFrame:(CGRect)frame MyFont:(MyFont *)font;
- (id)initWithFrame:(CGRect)frame font:(CGFontRef)font pointSize:(CGFloat)pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
@end

@interface MyFont (MyFontPrivate)
@property (nonatomic, readonly) CGFloat ratio;
@end

@implementation UILabel (MQFontLabel)

//	@synthesize _MyFont;
- (MyFont*)_MyFont
{
	return _MyFont;
}

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName pointSize:(CGFloat)pointSize {
	return [self initWithFrame:frame MyFont:[[FontManager sharedManager] MyFontWithName:fontName pointSize:pointSize]];
}

- (id)initWithFrame:(CGRect)frame MyFont:(MyFont *)font {
	if (self = [super initWithFrame:frame]) {
		_MyFont = [font retain];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame font:(CGFontRef)font pointSize:(CGFloat)pointSize {
	return [self initWithFrame:frame MyFont:[MyFont fontWithCGFont:font size:pointSize]];
}

- (CGFontRef)cgFont {
	return self._MyFont.cgFont;
}

- (void)setCGFont:(CGFontRef)font {
	if (self._MyFont.cgFont != font) {
		self._MyFont = [MyFont fontWithCGFont:font size:self._MyFont.pointSize];
	}
}

- (CGFloat)pointSize {
	return self._MyFont.pointSize;
}

- (void)setPointSize:(CGFloat)pointSize {
	if (self._MyFont.pointSize != pointSize) {
		self._MyFont = [MyFont fontWithCGFont:self._MyFont.cgFont size:pointSize];
	}
}

- (void)drawTextInRect:(CGRect)rect {
	if (self._MyFont == NULL) {
		//[super drawTextInRect:rect];
		return;
	}
	
	self.backgroundColor = [UIColor clearColor];
	// this method is documented as setting the text color for us, but that doesn't appear to be the case
	[self.textColor setFill];
	
	MyFont *actualFont = self._MyFont;
	CGSize origSize = rect.size;
	if (self.numberOfLines == 1) {
		origSize.height = actualFont.leading;
		CGPoint point = CGPointMake(rect.origin.x,
									rect.origin.y + ((rect.size.height - actualFont.leading) / 2.0f));
		if (self.adjustsFontSizeToFitWidth && self.minimumFontSize < actualFont.pointSize) {
			CGSize size = [self.text sizeWithMyFont:actualFont];
			if (size.width > rect.size.width) {
				CGFloat desiredRatio = (origSize.width * actualFont.ratio) / size.width;
				CGFloat desiredPointSize = desiredRatio * actualFont.pointSize / actualFont.ratio;
				actualFont = [actualFont fontWithSize:MAX(MAX(desiredPointSize, self.minimumFontSize), 1.0f)];
				size = [self.text sizeWithMyFont:actualFont
							  constrainedToSize:CGSizeMake(origSize.width, actualFont.leading)
								  lineBreakMode:self.lineBreakMode];
			}
			if (!CGSizeEqualToSize(origSize, size)) {
				switch (self.baselineAdjustment) {
					case UIBaselineAdjustmentAlignCenters:
						point.y += (origSize.height - size.height) / 2.0f;
						break;
					case UIBaselineAdjustmentAlignBaselines:
						point.y += (self._MyFont.ascender - actualFont.ascender);
						break;
					case UIBaselineAdjustmentNone:
						break;
				}
			}
		}
		rect = (CGRect){point, CGSizeMake(origSize.width, actualFont.leading)};
		[self.text drawInRect:rect withMyFont:actualFont lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
	} else {
		if (self.numberOfLines > 0) origSize.height = MIN(origSize.height, self.numberOfLines * actualFont.leading);
		CGSize size = [self.text sizeWithMyFont:actualFont constrainedToSize:origSize lineBreakMode:self.lineBreakMode];
		CGPoint point = rect.origin;
		point.y += MAX(rect.size.height - size.height, 0.0f) / 2.0f;
		rect = (CGRect){point, CGSizeMake(rect.size.width, size.height)};
		[self.text drawInRect:rect withMyFont:actualFont lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
	}
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
	if (self._MyFont == NULL) {
		return [self textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
	}
	
	if (numberOfLines > 0) bounds.size.height = MIN(bounds.size.height, self._MyFont.leading * numberOfLines);
	bounds.size = [self.text sizeWithMyFont:self._MyFont constrainedToSize:bounds.size lineBreakMode:self.lineBreakMode];
	return bounds;
}

- (void)dealloc {
	[_MyFont release];
	[super dealloc];
}

@end
#endif
