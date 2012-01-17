#import "LYString.h"

@implementation NSString (LYString)

#pragma mark UI

- (id)init
{
#if 0
	//	NSLog(@"supersound inited: %i", supersound_inited);
	if (supersound_inited == NO)
	{
		supersound_inited = YES;
#ifdef LY_ENABLE_OPENAL
		se_init();
#endif
	}
#endif
	return [super init];
}

- (void)show_alert_title:(NSString*)title message:(NSString*)msg
{
	[self show_alert_title:title message:msg delegate:nil];
}

- (void)show_alert_title:(NSString*)title message:(NSString*)msg delegate:(id)an_obj
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
		delegate:an_obj cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)show_alert_message:(NSString*)msg
{
	[self show_alert_title:self message:msg];
}

- (void)show_alert_title:(NSString*)title
{
	[self show_alert_title:title message:self];
}

- (void)show_alert_message:(NSString*)msg delegate:(id)an_obj
{
	[self show_alert_title:self message:msg delegate:an_obj];
}

- (void)show_alert_title:(NSString*)title delegate:(id)an_obj
{
	[self show_alert_title:title message:self delegate:an_obj];
}

#pragma mark Application

- (BOOL)go_url
{
	NSString* s = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}

- (BOOL)can_go_url
{
	NSString* s = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:s]];
}

- (BOOL)at_least_version
{
	NSString *reqSysVer = self;		//@"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	return [currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending;
}

#pragma mark File

//	IMPORTANT: this function is for backward compatability - use filename_documents for real access to /Documents
- (NSString*)filename_document
{
	return [self filename_private];
}

- (NSString*)filename_documents
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) 
		objectAtIndex:0] stringByAppendingPathComponent:self];
}

- (NSString*)filename_library
{
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) 
		objectAtIndex:0] stringByAppendingPathComponent:self];
}

- (NSString*)filename_private
{
	NSString* private = [[@"" filename_library] stringByAppendingString:@"/doc-private"];
	[private create_dir_absolute];
	return [private stringByAppendingPathComponent:self];
}

- (NSString*)filename_bundle
{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:self];
}

- (BOOL)is_directory
{
	BOOL	b;

    NSFileManager *file_manager = [NSFileManager defaultManager];
	[file_manager fileExistsAtPath:[self filename_document] isDirectory:&b];

	return b;
}

- (BOOL)file_exists
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[self filename_document]];
}

- (BOOL)file_exists_documents
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[self filename_documents]];
}

- (BOOL)file_exists_bundle
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[self filename_bundle]];
}

- (BOOL)create_dir_absolute
{
	NSFileManager*	manager = [NSFileManager defaultManager];
	BOOL ret = [manager createDirectoryAtPath:self withIntermediateDirectories:YES attributes:nil error:nil];
	//	NSLog(@"create dir: %i", ret);
	return ret;
}

- (BOOL)create_dir
{
	return [[self filename_document] create_dir_absolute];
}

- (BOOL)file_remove
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSLog(@"about to remove: %@", [self filename_document]);
	return [fileManager removeItemAtPath:[self filename_document] error:nil];
}

- (BOOL)file_backup
{
	NSError* error;

	if ([[self filename_documents] file_exists])
		return NO;
	else
	{
		[[NSFileManager defaultManager] 
			//linkItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]
			  copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self]
					  toPath:[self filename_documents]
					   error:&error];
			//handler:nil];
		if (error != nil)
		{
			NSLog(@"ERROR backup: %@", error);	//.localizedDescription);
			return NO;
		}
		else
			return YES;
	}

	return NO;
}

//	TODO: merge methods
- (BOOL)file_backup_private
{
	NSError* error;

	if ([[self filename_documents] file_exists])
		return NO;
	else
	{
		[[NSFileManager defaultManager] 
			//linkItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]
			  copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self]
					  toPath:[self filename_private]
					   error:&error];
			//handler:nil];
		if (error != nil)
		{
			//	NSLog(@"ERROR backup: %@", error);	//.localizedDescription);
			return NO;
		}
		else
			return YES;
	}

	return NO;
}

- (BOOL)file_backup_to:(NSString*)dest
{
	return [[NSString stringWithFormat:@"%@/%@", dest, self] file_backup];
}

- (NSArray*)list_documents
{
	NSFileManager* manager = [NSFileManager defaultManager];
	return [manager contentsOfDirectoryAtPath:[@"" filename_documents] error:nil];
}

- (NSArray*)list_private
{
	NSFileManager* manager = [NSFileManager defaultManager];
	return [manager contentsOfDirectoryAtPath:[@"" filename_private] error:nil];
}

#ifdef LY_ENABLE_APP_ZIP
- (BOOL)unzip_to:(NSString*)dest
{
	BOOL ret = NO;

	ZipArchive *za = [[ZipArchive alloc] init];
	if ([za UnzipOpenFile:self])
	{
		ret = [za UnzipFileTo:[dest filename_document] overWrite:YES];
		[za UnzipCloseFile];
	}
	[za release];

	return ret;
}
- (NSArray*)zip_content_array
{
	NSArray* ret = nil;

	ZipArchive *za = [[ZipArchive alloc] init];
	if ([za UnzipOpenFile:self])
	{
		ret = [za getZipFileContents];
		[za UnzipCloseFile];
	}
	[za release];

	return ret;
}
#endif

#pragma mark URL

- (NSString*)url_to_filename
{
	NSString*	s = self;

	s = [s stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
	s = [s stringByReplacingOccurrencesOfString:@":" withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"&" withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"?" withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];

	return s;
}

- (NSString*)to_url
{
	return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)escape
{
	NSMutableString *escaped = [NSMutableString stringWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];   
	[escaped replaceOccurrencesOfString:@"$" withString:@"%24" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	return escaped;
}

- (BOOL)is_email
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 

	return [emailTest evaluateWithObject:self];
}

- (BOOL)is_english_name
{
	NSString *emailRegex = @"[A-Za-z '&-]+";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 

	return [emailTest evaluateWithObject:self];
}

#pragma mark String

- (BOOL)is:(NSString*)s
{
	return [self isEqualToString:s];
}

- (BOOL)has_substring:(NSString*)sub
{
	if (sub == nil)
		return NO;
	if (sub.length == 0)
		return YES;

	NSRange range = [self rangeOfString:sub];
	if ((range.location == NSNotFound) && (range.length == 0))
		return NO;

	return YES;
}

- (NSString*)string_without_leading_space
{
	int i;
	for (i = 0; i < self.length; i++)
		if ([self characterAtIndex:i] != ' ')
			break;
	return [self substringFromIndex:i];
}

- (NSString*)string_replace:(NSString*)substring with:(NSString*)replacement
{
	NSRange		range;
	NSString*	s = self;

	range = [s rangeOfString:substring];
	while (range.location != NSNotFound) 
	{
		s = [s stringByReplacingOccurrencesOfString:substring withString:replacement];
		range = [s rangeOfString:substring];
		//	NSLog(@"string without: %@", s);
	}

	return s;
}

- (NSString*)string_without:(NSString*)head to:(NSString*)tail
{
	return [self string_without:head to:tail except:[NSArray arrayWithObjects:nil]];
}

- (NSString*)string_without:(NSString*)head to:(NSString*)tail except:(NSArray*)exceptions
{
	int			i;
	BOOL		finding_head = YES;
	NSRange		range_source, range_dest;
	NSString*	s = [NSString stringWithString:self];
	NSString*	sub = @"";

	while (sub != nil)
	{
		sub = nil; 
		for (i = 0; i < s.length; i++)
		{
			range_source.location = i;
			if (finding_head)
			{
				range_source.length = head.length;
				if (range_source.length + i > s.length)
					break;
				if ([[s substringWithRange:range_source] isEqualToString:head])
				{
					//	NSLog(@"found head at: %i", i);
					range_dest.location = i;
					finding_head = NO;
				}
			}
			else
			{
				range_source.length = tail.length;
				if (range_source.length + i > s.length)
					break;
				if ([[s substringWithRange:range_source] isEqualToString:tail])
				{
					//	NSLog(@"found tail at: %i", i);
					range_dest.length = i - range_dest.location + tail.length;
					sub = [s substringWithRange:range_dest];
					finding_head = YES;
					if ([exceptions contains_string:sub] == NO)
						break;
					//	else
					//	NSLog(@"skipping %@", sub);
				}
			}
		}
		if (sub != nil)
		{
			if ([exceptions contains_string:sub])
				break;
			//	NSLog(@"found sub: %@", sub);
			s = [s stringByReplacingOccurrencesOfString:sub withString:@""];
		}
	}

	return s;
}

- (NSString*)string_between:(NSString*)head and:(NSString*)tail
{
	NSRange range_head = [self rangeOfString:head];
	NSRange range_tail = [self rangeOfString:tail];
	NSRange range;

	if (range_head.location == NSNotFound)
		return nil;
	if (range_tail.location == NSNotFound)
		return nil;

	range.location = range_head.location + range_head.length;
	range.length = range_tail.location - range.location;

	return [self substringWithRange:range];
}

+ (NSString*)string_from_int:(int)i
{
	return [NSString stringWithFormat:@"%i", i];
}

- (NSString*)s_int:(int)i
{
	if (i <= 1)
		return [NSString stringWithFormat:@"%i %@", i, self];
	else
		return [NSString stringWithFormat:@"%i %@s", i, self];
}

- (NSString*)s_int_with_no:(int)i
{
	if (i == 0)
		return [NSString stringWithFormat:@"no %@", self];
	else if (i <= 1)
		return [NSString stringWithFormat:@"%i %@", i, self];
	else
		return [NSString stringWithFormat:@"%i %@s", i, self];
}

- (NSString*)s_int_with_No:(int)i
{
	if (i == 0)
		return [NSString stringWithFormat:@"No %@", self];
	else if (i <= 1)
		return [NSString stringWithFormat:@"%i %@", i, self];
	else
		return [NSString stringWithFormat:@"%i %@s", i, self];
}

- (NSString*)append_line:(NSString*)str
{
	return [self append_line:str divider:@"\n"];
}

- (NSString*)append_line2:(NSString*)str
{
	return [self append_line:str divider:@"\n\n"];
}

- (NSString*)append_line:(NSString*)str divider:(NSString*)divider
{
	//	NSLog(@"appending: '%@'", str);
	if (str != nil)
		if ([str isKindOfClass:[NSString class]])
			if (str.length > 0)
			{
				if (self.length > 0)
					return [NSString stringWithFormat:@"%@%@%@", self, divider, str];
				else
					return str;
			}
	//	NSLog(@"return self: '%@'", self);
	return self;
}

#pragma mark Time & Date

- (NSString*)local_medium_date_from:(NSString*)format_old
{
	return [self local_date_from:format_old format_date:NSDateFormatterMediumStyle time:NSDateFormatterMediumStyle];
}

- (NSString*)local_long_date_from:(NSString*)format_old
{
	return [self local_date_from:format_old format_date:NSDateFormatterLongStyle time:NSDateFormatterLongStyle];
}

- (NSString*)local_full_date_from:(NSString*)format_old
{
	return [self local_date_from:format_old format_date:NSDateFormatterFullStyle time:NSDateFormatterFullStyle];
}

- (NSString*)local_date_from:(NSString*)format_old format_date:(NSDateFormatterStyle)date_format time:(NSDateFormatterStyle)time_format
{
	NSString* dateStr = self;

	//	Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format_old];
	NSDate *date = [dateFormat dateFromString:dateStr];  
	
	dateStr = [NSDateFormatter localizedStringFromDate:date dateStyle:date_format timeStyle:time_format];
	[dateFormat release];

	return dateStr;
}

- (NSString*)convert_date_from:(NSString*)format_old to:(NSString*)format_new
{
	NSString* dateStr = self;

	//	Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format_old];
	NSDate *date = [dateFormat dateFromString:dateStr];  
	
	//	Convert date object to desired output format
	[dateFormat setDateFormat:format_new];
	dateStr = [dateFormat stringFromDate:date];  
	[dateFormat release];

	return dateStr;
}

- (NSString*)local_date_from:(NSString*)format_old timezone:(NSTimeZone*)timezone_source format_date:(NSDateFormatterStyle)date_format time:(NSDateFormatterStyle)time_format
{
	NSString* dateStr = self;

	//	Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format_old];
	NSDate *date = [dateFormat dateFromString:dateStr];  

	//NSTimeZone* timezone_source = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSTimeZone* timezone_dest = [NSTimeZone systemTimeZone];
	NSInteger sourceGMTOffset = [timezone_source secondsFromGMTForDate:date];
	NSInteger destinationGMTOffset = [timezone_dest secondsFromGMTForDate:date];
	NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
	NSDate* date_dest = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:date] autorelease];

	//	Convert date object to desired output format
	dateStr = [NSDateFormatter localizedStringFromDate:date_dest dateStyle:date_format timeStyle:time_format];
	[dateFormat release];

	return dateStr;
}

- (NSString*)convert_date_from:(NSString*)format_old to:(NSString*)format_new timezone:(NSTimeZone*)timezone_source
{
	NSString* dateStr = self;

	//	Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format_old];
	NSDate *date = [dateFormat dateFromString:dateStr];  

	//NSTimeZone* timezone_source = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSTimeZone* timezone_dest = [NSTimeZone systemTimeZone];
	NSInteger sourceGMTOffset = [timezone_source secondsFromGMTForDate:date];
	NSInteger destinationGMTOffset = [timezone_dest secondsFromGMTForDate:date];
	NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
	NSDate* date_dest = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:date] autorelease];

	//	Convert date object to desired output format
	[dateFormat setDateFormat:format_new];
	dateStr = [dateFormat stringFromDate:date_dest];  
	[dateFormat release];

	return dateStr;
}

- (NSString*)format_date:(NSDate*)date
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	NSString* ret;

	[dateFormat setDateFormat:self];
	ret = [dateFormat stringFromDate:date];  
	[dateFormat release];

	return ret;
}

#pragma mark sound

- (void)play_caf
{
#ifdef LY_ENABLE_OPENAL
	se_play_caf(self);
#endif
}

#pragma mark settings

- (BOOL)setting_bool
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:self];
}

- (NSInteger)setting_integer
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:self];
}

- (NSString*)setting_string
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:self];
}

- (id)setting_obj
{
	return [NSKeyedUnarchiver unarchiveObjectWithData:[self setting_object]];
}

- (id)setting_object
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:self];
}

- (void)setting_bool:(BOOL)b
{
	[[NSUserDefaults standardUserDefaults] setBool:b forKey:self];
}

- (void)setting_integer:(NSInteger)i
{
	[[NSUserDefaults standardUserDefaults] setInteger:i forKey:self];
}

- (void)setting_string:(NSString*)s
{
	[[NSUserDefaults standardUserDefaults] setObject:s forKey:self];
}

- (void)setting_obj:(UIColor*)color
{
	[self setting_object:[NSKeyedArchiver archivedDataWithRootObject:color]];
}

- (void)setting_object:(id)obj
{
	[[NSUserDefaults standardUserDefaults] setObject:obj forKey:self];
}

//	setting + ui

- (void)setting_set_switch:(UISwitch*)a_switch
{
	a_switch.on = [self setting_bool];
}

- (void)setting_get_switch:(UISwitch*)a_switch
{
	[self setting_bool:a_switch.on];
}

#pragma mark calendar

- (NSString*)buddhist_to_christian
{
	int year = [[self substringToIndex:4] intValue];
	year -= 543;
	return [NSString stringWithFormat:@"%i%@", year, [self substringFromIndex:4]];
}

- (NSString*)japanese_to_christian
{
	int year = [[self substringToIndex:4] intValue];
	year += 1988;
	return [NSString stringWithFormat:@"%i%@", year, [self substringFromIndex:4]];
}

#ifdef LY_ENABLE_SDK_ASIHTTP
- (NSString*)blob_post_dictionary:(NSDictionary*)dict
{
	[LYLoading show_label:@"Uploading..."];
	NSString* s = [NSString stringWithContentsOfURL:[NSURL URLWithString:self] encoding:NSUTF8StringEncoding error:nil];
	[LYLoading hide];
	return [s http_post_dictionary:dict];
}

- (NSString*)http_post_dictionary:(NSDictionary*)dict
{
	[LYLoading show_label:@"Uploading..."];
	NSURL *url = [NSURL URLWithString:self];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	for (NSString* key in dict)
	{
		id obj = [dict valueForKey:key];
		if (obj == nil)
			[request setPostValue:@"" forKey:key];
		//	else if ([key isEqualToString:@"file"])
		//		[request setFile:obj forKey:key];
		else if ([obj isKindOfClass:[NSString class]])
			[request setPostValue:obj forKey:key];
		else if ([obj isKindOfClass:[NSData class]])
			[request setData:obj forKey:key];
		else if ([obj isKindOfClass:[NSDictionary class]])		//	blob upload
			[request setData:[obj valueForKey:@"data"]
				withFileName:[obj valueForKey:@"filename"] 
			  andContentType:[obj valueForKey:@"type"] 
					  forKey:key];
		else
			[request setPostValue:@"WARNING: UNKNOWN DATA TYPE" forKey:key];
		//	NSLog(@"request %@: %@", key, obj);
	}
	[request startSynchronous];
#if 1
	NSError *error = [request error];
	if (error != nil)
	{
		NSLog(@"ASI error: %@", error.localizedDescription);
	}
#endif
	[LYLoading hide];
	return [request responseString];
}
#endif

#ifdef LY_ENABLE_SDK_TOUCHJSON
- (NSDictionary*)dictionary_json
{
	NSData*			data;
	NSError*		error;
	NSDictionary*	ret;
#if 1
	NSRange			range;
	NSString*		s;

	if (self == nil)
		return nil;

	range = [self rangeOfString:@"{"];
	if (range.location == NSNotFound)
		return nil;

	s = [self substringFromIndex:range.location];
	data = [s dataUsingEncoding:NSUTF32BigEndianStringEncoding];
#else
	data = [[self string_without_leading_space] dataUsingEncoding:NSUTF32BigEndianStringEncoding];
#endif
	ret = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:&error];
	//	NSLog(@"json error: %@", error);
	return ret;
}
- (NSArray*)array_json
{
	NSData*		data;
	//data = [self dataUsingEncoding:NSUTF8StringEncoding];
	data = [self dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	return [[CJSONDeserializer deserializer] deserializeAsArray:data error:nil];
}
- (id)obj_json
{
	NSData*		data;
	data = [self dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	return [[CJSONDeserializer deserializer] deserialize:data error:nil];
}
#endif

- (NSString*)switch:(NSString*)s1 with:(NSString*)s2
{
	NSString* s = self;
	if ([s has_substring:s1] && [s has_substring:s2])
	{
		//	NSLog(@"%@, %@, %@", s1, s2, s);
		s = [s stringByReplacingOccurrencesOfString:s1 withString:@"ly-separator-string-switch-001"];
		s = [s stringByReplacingOccurrencesOfString:s2 withString:@"ly-separator-string-switch-002"];
		s = [s stringByReplacingOccurrencesOfString:@"ly-separator-string-switch-001" withString:s2];
		s = [s stringByReplacingOccurrencesOfString:@"ly-separator-string-switch-002" withString:s1];
		//	NSLog(@"%@, %@, %@", s1, s2, s);
	}
	return s;
}

- (NSString*)_ly_k1
{
	NSString* s = self;
	s = [s switch:@"3" with:@"8"];
	//s = [s switch:@"7" with:@"4"];
	s = [s switch:@"+" with:@"-"];
	s = [s switch:@"1" with:@"l"];
	s = [s switch:@"O" with:@"0"];
	s = [s switch:@"z" with:@"2"];
	s = [s switch:@"s" with:@"5"];
	s = [s switch:@"x" with:@"X"];
	s = [s switch:@"9" with:@"6"];
	s = [s switch:@"a" with:@"b"];
	s = [s switch:@"A" with:@"B"];
	s = [s switch:@"c" with:@"d"];
	s = [s switch:@"e" with:@"f"];
	s = [s switch:@"E" with:@"F"];
	s = [s switch:@"g" with:@"h"];
	s = [s switch:@"G" with:@"H"];
	s = [s switch:@"i" with:@"y"];
	s = [s switch:@"I" with:@"Y"];
	s = [s switch:@"j" with:@"w"];
	s = [s switch:@"J" with:@"W"];
	s = [s switch:@"m" with:@"n"];
	s = [s switch:@"M" with:@"N"];
	s = [s switch:@"o" with:@"p"];
	s = [s switch:@"S" with:@"P"];
	s = [s switch:@"q" with:@"r"];
	s = [s switch:@"Q" with:@"R"];
	s = [s switch:@"t" with:@"v"];
	s = [s switch:@"T" with:@"V"];
	return s;
}

@end

/*
NSString* str_escape_utf8(NSString* s)
{
	return (NSString*)CFURLCreateStringByAddingPercentEscapes(
				NULL,
				(CFStringRef)s,
				NULL,
				(CFStringRef)@"!*'();:@&=+$,/?%#[]",
				kCFStringEncodingUTF8);
}
*/
