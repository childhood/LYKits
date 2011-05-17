#import "LYSingletonClass.h"
#import "LYCategory.h"

@interface LYRandom: LYSingletonClass
{
    //NSString*		property;
}
//@property (nonatomic, retain) NSString*		property;
+ (id)manager;

//	graphic
+ (CGPoint)random_point:(CGSize)win_size;

//	string
+ (NSUInteger)get_hash:(NSString*)string;
+ (NSUInteger)get_hash:(NSString*)string with_correction:(NSUInteger)correction;
+ (NSUInteger)random_max:(NSUInteger)max key:(NSString*)key;
+ (NSString*)unique_string;

//	font
+ (NSString*)font_family;
+ (NSString*)font_family_for_key:(NSString*)key;
+ (NSString*)font_family_with_random:(NSUInteger)r;
+ (NSString*)font_name;
+ (NSString*)font_name_for_key:(NSString*)key;
+ (NSString*)font_name_with_random:(NSUInteger)r family:(NSString*)family;;

//	color
+ (UIColor*)dark_color;
+ (UIColor*)dark_color_for_key:(NSString*)key;
+ (UIColor*)bright_color;
+ (UIColor*)bright_color_for_key:(NSString*)key;
+ (UIColor*)color_with_random_r:(NSUInteger)red g:(NSUInteger)green b:(NSUInteger)blue from:(NSUInteger)min to:(NSUInteger)max;

//	file
+ (NSString*)contents_of_file:(NSString*)filename separator:(NSString*)separator;
+ (NSString*)national_motto;

@end

