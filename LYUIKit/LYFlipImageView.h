#import "LYKits.h"
#import "supersound.h"

/*
 * example
 *

- (void)apply_flip:(LYFlipImageView*)an_image
{
	int i;
	[an_image.data key:@"mode" v:@"image"];
	NSMutableArray* array = [an_image.data v:@"sequence"];
	[array removeAllObjects];
	for (i = 0; i < 10; i++)
	{
		[array addObject:[NSString stringWithFormat:@"%i.png", 9 - i]];
	}
	[an_image reload];
}

*/

@interface LYFlipImageView: UIImageView
@property (nonatomic, retain) NSMutableDictionary*	data;

- (void)set_sequence_numbers;
- (void)set_sequence_uppercase;
- (void)set_sequence_lowercase;
- (BOOL)flip_to:(NSString*)s;
- (void)reload;
- (void)reload:(NSNumber*)number;

@end

