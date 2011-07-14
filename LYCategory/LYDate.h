#import <Foundation/Foundation.h>

/*
	//	use this instead of old methods, it handles different calendars
	[NSDateFormatter localizedStringFromDate:date_start 
								   dateStyle:NSDateFormatterLongStyle 
								   timeStyle:NSDateFormatterNoStyle];
*/

@interface NSDate (LYDate)
+ (NSDate*)date_from_string:(NSString*)string format:(NSString*)format;
+ (NSDate*)yesterday;
+ (NSDate*)tomorrow;
- (NSDate*)yesterday;
- (NSDate*)tomorrow;
- (BOOL)is_same_date:(NSDate*)date1;
- (BOOL)is_same_month:(NSDate*)date1;
@end
