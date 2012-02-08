#import "LYKits.h"
#import "supersound.h"

@interface LYFlipImageView: UIImageView
@property (nonatomic, retain) NSMutableDictionary*	data;

- (void)set_sequence_numbers;
- (void)set_sequence_uppercase;
- (void)set_sequence_lowercase;
- (BOOL)flip_to:(NSString*)s;
- (void)reload;
- (void)reload:(NSNumber*)number;

@end

