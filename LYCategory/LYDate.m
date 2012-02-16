#import "LYDate.h"

@implementation NSDate (LYDate)

+ (NSDate*)date_from_string:(NSString*)string format:(NSString*)format
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format];
	NSDate *date = [dateFormat dateFromString:string];
	[dateFormat release];
	return date;
}

+ (NSDate*)date_from_date:(NSDate*)date time:(NSDate*)time
{
	long long d = date.timeIntervalSince1970;
	long long t = time.timeIntervalSince1970;
	d /= 24 * 60 * 60;
	t %= 24 * 60 * 60;
	return [NSDate dateWithTimeIntervalSince1970: d * 24 * 60 * 60 + t];
}

+ (NSDate*)yesterday
{
	return [NSDate dateWithTimeIntervalSinceNow:-86400.0];
}

+ (NSDate*)tomorrow
{
	return [NSDate dateWithTimeIntervalSinceNow:86400.0];
}

- (NSDate*)yesterday
{
	return [NSDate dateWithTimeInterval:-86400.0 sinceDate:self];
}

- (NSDate*)tomorrow
{
	return [NSDate dateWithTimeInterval:86400.0 sinceDate:self];
}

//	last ...

- (NSDate*)last_week
{
	return [NSDate dateWithTimeInterval:-86400.0 * 7 sinceDate:self];
}

- (NSDate*)last_fortnight
{
	return [NSDate dateWithTimeInterval:-86400.0 * 14 sinceDate:self];
}

- (NSDate*)last_month
{
	NSDateComponents* comp = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:self];
	[comp setMonth:comp.month - 1];
	return [[NSCalendar currentCalendar] dateFromComponents:comp];
}

- (NSDate*)last_year
{
	NSDateComponents* comp = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:self];
	[comp setYear:comp.year - 1];
	return [[NSCalendar currentCalendar] dateFromComponents:comp];
}

//	next ...

- (NSDate*)next_week
{
	return [NSDate dateWithTimeInterval:86400.0 * 7 sinceDate:self];
}

- (NSDate*)next_fortnight
{
	return [NSDate dateWithTimeInterval:86400.0 * 14 sinceDate:self];
}

- (NSDate*)next_month
{
	NSDateComponents* comp = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:self];
	[comp setMonth:comp.month + 1];
	return [[NSCalendar currentCalendar] dateFromComponents:comp];
}

- (NSDate*)next_year
{
	NSDateComponents* comp = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:self];
	[comp setYear:comp.year + 1];
	return [[NSCalendar currentCalendar] dateFromComponents:comp];
}

- (NSDate*)in_next_year
{
	NSDateComponents* comp_self	= [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:self];
	NSDateComponents* comp_now	= [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
	[comp_self setYear:comp_now.year];
	if ([[[NSCalendar currentCalendar] dateFromComponents:comp_self] compare:
		 [[NSCalendar currentCalendar] dateFromComponents:comp_now]] == NSOrderedDescending)
		return [[NSCalendar currentCalendar] dateFromComponents:comp_self];
	else
	{
		[comp_self setYear:comp_now.year + 1];
		return [[NSCalendar currentCalendar] dateFromComponents:comp_self];
	}
}

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

//	CalculadorSS

+ (NSDate*)holiday_css:(int)year selector:(NSString*)s
{
	Class c = NSClassFromString(@"CalculadorSS");
	if (c)
	{
		//NSObject* obj = [[c alloc] initWithAnio:year];
		NSObject* obj = objc_msgSend([c alloc], @selector(initWithAnio:), year);
		//NSLog(@"easter of %i: %@", year, [obj perform_string:@"strDomingoResurreccion"]);
		NSDate* date = [obj perform_string:s];
		[obj release];
		return date;
	}
	return nil;
}

+ (NSDate*)holiday_easter:(int)year
{
	return [self holiday_css:year selector:@"domingoResurreccion"];
}

+ (NSDate*)holiday_ash_wednesday:(int)year
{
	return [self holiday_css:year selector:@"miercolesCeniza"];
}

+ (NSDate*)holiday_palm_sunday:(int)year
{
	return [self holiday_css:year selector:@"domingoRamos"];
}

+ (NSDate*)holiday_pentecost:(int)year
{
	return [self holiday_css:year selector:@"domingoPentecostes"];
}

+ (NSDate*)holiday_trinity:(int)year
{
	return [self holiday_css:year selector:@"domingoTrinidad"];
}

+ (NSDate*)holiday_corpus_christi_thu:(int)year
{
	return [self holiday_css:year selector:@"juevesCorpus"];
}

+ (NSDate*)holiday_corpus_christi_sun:(int)year
{
	return [self holiday_css:year selector:@"domingoCorpus"];
}

+ (NSDate*)next_holiday:(NSString*)s
{
	int year = [[@"yyyy" format_date:[NSDate date]] intValue];
	NSDate* this_year = objc_msgSend([NSDate class], 
			NSSelectorFromString([NSString stringWithFormat:@"holiday_%@:", s]), year);
	if ([this_year compare:[NSDate date]] == NSOrderedDescending)
		return this_year;
	else
		return objc_msgSend([NSDate class], 
			NSSelectorFromString([NSString stringWithFormat:@"holiday_%@:", s]), year + 1);

}

@end
