#import "LYCarouselProvider.h"

@implementation LYCarouselProvider

@synthesize data;
@synthesize view;

- (id)initWithCarousel:(iCarousel*)a_carousel
{
	self = [super init];
	if (self)
	{
		iCarousel* carousel;
		if (a_carousel)
			carousel = a_carousel;
		else
			carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, [ly screen_width], [ly screen_height])];

		carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		carousel.type = iCarouselTypeTimeMachine;
		carousel.delegate = self;
		carousel.dataSource = self;

		data = [[NSMutableDictionary alloc] init];
		view = carousel;

		[data key:@"carousel" v:carousel];
		[data key:@"views" v:[NSMutableArray array]];
		[data key:@"limit" v:[NSNumber numberWithInt:25]];
		[data key:@"width" v:[NSNumber numberWithFloat:210.0]];
		[data key:@"type" v:[NSNumber numberWithInt:(int)iCarouselTypeTimeMachine]];
		[data key:@"wrap" v:[NSNumber numberWithBool:YES]];
	}
	return self;
}

- (void)dealloc
{
	ly_release(data);
	ly_super_dealloc;
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
	return [[data v:@"views"] count];
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
	return [[data v:@"limit"] intValue];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	return [[data v:@"views"] i:index];
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//	TODO
	return 0;
}

#if 0
- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	UILabel *label = nil;
	
	//create new view if no view is available for recycling
	if (view == nil)
	{
		view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]] autorelease];
		label = [[[UILabel alloc] initWithFrame:view.bounds] autorelease];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [label.font fontWithSize:50.0f];
		[view addSubview:label];
	}
	else
	{
		label = [[view subviews] lastObject];
	}
	
    //set label
	label.text = (index == 0)? @"[": @"]";
	
	return view;
}
#endif

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
	return [[data v:@"width"] floatValue];
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
	return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * [[data v:@"width"] floatValue]);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForTransformOption:(iCarouselTranformOption)option withDefault:(CGFloat)value
{
#if 0
    switch (option)
    {
        case iCarouselTranformOptionArc:
        {
            return 2 * M_PI * arcSlider.value;
        }
        case iCarouselTranformOptionRadius:
        {
            return value * radiusSlider.value;
        }
        case iCarouselTranformOptionTilt:
        {
            return tiltSlider.value;
        }
        case iCarouselTranformOptionSpacing:
        {
            return spacingSlider.value;
        }
        default:
        {
            return value;
        }
    }
#else
	return value;
#endif
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
	return [[data v:@"wrap"] boolValue];
}


@end
