#import <Foundation/Foundation.h>

@interface NSDate (LYDate)
+ (NSDate*)date_from_string:(NSString*)string format:(NSString*)format;
- (BOOL)is_same_date:(NSDate*)date1;
- (BOOL)is_same_month:(NSDate*)date1;
@end
