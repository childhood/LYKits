#import "LYObject.h"
#import "LYString.h"
#import "LYArray.h"
#import "LYDictionary.h"
#import "LYMutableArray.h"
#import "LYColor.h"
#import "LYView.h"
#import "LYScrollView.h"
#import "LYLabel.h"
#import "LYTableView.h"
#import "LYImageView.h"
#import "LYWebView.h"
#import "LYButton.h"
#import "LYImage.h"
#import "LYDevice.h"
#import "LYControl.h"
#import "LYImagePickerController.h"
#import "LYDate.h"
#import "LYMutableDictionary.h"
#import "LYSwitch.h"
#import "LYNavigationItem.h"
#import "LYBarButtonItem.h"
#import "LYTableViewCell.h"

/*
 * enable the macros below to enable navigation background, rotation, etc.
 * see each header file for detailed documents (most of the message names are self-explained)
 */

//	#define LY_ENABLE_CATEGORY_NAVIGATIONBAR_BACKGROUND
//	#define LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATE
//	#define LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATEPHONE
//	#define LY_ENABLE_CATEGORY_VIEWCONTROLLER_ROTATE

#import "LYNavigationBar.h"
#import "LYViewController.h"
#import "LYNavigationController.h"

@protocol LYRotatableViewControllerDelegate
- (BOOL)respondsToSelector:(SEL)selector;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
@end

#pragma mark OTHERS


#if 0
@interface UITabBarController (LYTabBarController)
@end

@implementation UITabBarController (LYTabBarController)
#ifdef LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATE
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
		NSLog(@"tab should rotate: %i, %f, %f", rotatable, screen_width(), screen_height());
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		if (interfaceOrientation == UIInterfaceOrientationPortrait)
			return YES;
		else
#ifdef LY_ENABLE_CATEGORY_NAVIGATIONCONTROLLER_ROTATEPHONE
			return YES;
#else
			return NO;
#endif
	}
	else
		return YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	//	NSLog(@"nav did rotate: %i - %@, delegate %@", fromInterfaceOrientation, self.delegate, self.delegate);
	NSObject <LYRotatableViewControllerDelegate>*	the_delegate = (NSObject<LYRotatableViewControllerDelegate>*)self.delegate;
	if (the_delegate == nil)
		return;
	//	NSLog(@"delegate: %@", the_delegate);
	//	this is a workaround for the LYImagePickerController recursive delegate problem
	if ([the_delegate isKindOfClass:[UIImagePickerController class]])
		return;
	if ([the_delegate respondsToSelector:@selector(didRotateFromInterfaceOrientation:)])
		[the_delegate didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}
#endif
@end
#endif

//	TODO: this is not needed so far. Let it be here for a while...

#if 0
@interface UITableViewCell (LYTableViewCell)
- (void)copy_style:(UITableViewCell*)target;
@end

@implementation UITableViewCell (LYTableViewCell)

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


//	TODO: forget about this for now. need really nice code to do this.

#if 0
#import "FontLabel.h"
#import "FontManager.h"
#import "FontLabelStringDrawing.h"
#import "MyFont.h"

@class MyFont;

@interface UILabel (LYFontLabel)
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

@implementation UILabel (LYFontLabel)

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
