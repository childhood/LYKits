#import <Foundation/Foundation.h>
#import "LYObject.h"

/*
	//	use this instead of old methods, it handles different calendars
	[NSDateFormatter localizedStringFromDate:date_start 
								   dateStyle:NSDateFormatterLongStyle 
								   timeStyle:NSDateFormatterNoStyle];
*/

@interface NSDate (LYDate)
+ (NSDate*)date_from_string:(NSString*)string format:(NSString*)format;
+ (NSDate*)date_from_date:(NSDate*)date time:(NSDate*)time;
//	in "2011-02-01", ["1980-01-01" in_next_year] returns "2012-01-01"
- (NSDate*)in_next_year;
+ (NSDate*)yesterday;
+ (NSDate*)tomorrow;
- (NSDate*)yesterday;
- (NSDate*)tomorrow;
- (NSDate*)last_week;
- (NSDate*)last_fortnight;
- (NSDate*)last_month;
- (NSDate*)last_year;
- (NSDate*)next_week;
- (NSDate*)next_fortnight;
- (NSDate*)next_month;
- (NSDate*)next_year;
- (BOOL)is_same_date:(NSDate*)date1;
- (BOOL)is_same_month:(NSDate*)date1;

+ (NSDate*)holiday_easter:(int)year;
+ (NSDate*)holiday_ash_wednesday:(int)year;
+ (NSDate*)holiday_palm_sunday:(int)year;
+ (NSDate*)holiday_pentecost:(int)year;
+ (NSDate*)holiday_trinity:(int)year;
+ (NSDate*)holiday_corpus_christi_thu:(int)year;
+ (NSDate*)holiday_corpus_christi_sun:(int)year;
+ (NSDate*)next_holiday:(NSString*)s;	//	[NSDate next_holiday:@"easter"];

@end
