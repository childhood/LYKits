#import "iCarousel.h"
#import "LYKits.h"

/*
 * example

	iCarousel*			carousel;
	LYCarouselProvider* carousel_provider;
	UIImageView* 		image1;
	UIImageView* 		image2;

	carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
	carousel_provider = [[LYCarouselProvider alloc] initWithCarousel:carousel];
	image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	image2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	image1.image = [UIImage imageNamed:@"bg-Love.png"];
	image2.image = [UIImage imageNamed:@"bg-Christmas.png"];
	[carousel_provider.data key:@"views" v:[NSArray arrayWithObjects:image1, image2, nil]];
	[carousel reloadData];

 */
@interface LYCarouselProvider: NSObject <iCarouselDelegate, iCarouselDataSource>

@property (nonatomic) NSMutableDictionary*	data;
@property (nonatomic) UIView*				view;

- (id)initWithCarousel:(iCarousel*)a_carousel;

@end
