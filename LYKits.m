#import "LYKits.h"

static LYKits*	ly_shared_manager = nil;

@implementation LYKits

@synthesize version;

+ (id)shared
{
	@synchronized(self)
	{
		if (ly_shared_manager == nil)
			[[self alloc] init];
		return ly_shared_manager;
	}
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (ly_shared_manager == nil)
		{
			ly_shared_manager = [super allocWithZone:zone];
			return ly_shared_manager;
		}
		return nil;
	}
}
- (id)init
{
	self = [super init];
	if (self != nil)
		version = @"LYKits v0.1";
	return self;
}

+ (NSString*)version_string
{
	@synchronized(self)
	{
		return (NSString*)[[LYKits shared] version];		//	XXX why warning here?
	}
}

#pragma mark foundation

+ (BOOL)is_phone
{
	@synchronized(self)
	{
		return is_phone();
	}
}

+ (BOOL)is_pad
{
	@synchronized(self)
	{
		return is_pad();
	}
}

#pragma mark ui

+ (UIInterfaceOrientation)get_interface_orientation
{
	@synchronized(self)
	{
		return get_interface_orientation();
	}
}

+ (BOOL)is_interface_portrait
{
	@synchronized(self)
	{
		return is_interface_portrait();
	}
}

+ (BOOL)is_interface_landscape
{
	@synchronized(self)
	{
		return is_interface_portrait();
	}
}

+ (CGFloat)get_width:(CGFloat)width
{
	@synchronized(self)
	{
		return get_width(width);
	}
}

+ (CGFloat)get_height:(CGFloat)height
{
	@synchronized(self)
	{
		return get_height(height);
	}
}

+ (CGFloat)screen_width
{
	@synchronized(self)
	{
		return screen_width();
	}
}

+ (CGFloat)screen_height;
{
	@synchronized(self)
	{
		return screen_height();
	}
}

+ (CGFloat)screen_max
{
	@synchronized(self)
	{
		return screen_max();
	}
}

#ifdef LY_ENABLE_MUSICKIT
+ (NSInteger)media_count_artist:(NSString*)artist album:(NSString*)album title:(NSString*)title
{
	@synchronized(self)
	{
		NSMutableSet*	set = [NSMutableSet setWithCapacity:3];
		MPMediaQuery*	query;
		NSInteger		ret;

		if (album != nil)
			[set addObject:[MPMediaPropertyPredicate predicateWithValue:album forProperty:MPMediaItemPropertyAlbumTitle]];
		if (artist != nil)
			[set addObject:[MPMediaPropertyPredicate predicateWithValue:artist forProperty:MPMediaItemPropertyArtist]];
		if (title != nil)
			[set addObject:[MPMediaPropertyPredicate predicateWithValue:title forProperty:MPMediaItemPropertyTitle]];

		query = [[MPMediaQuery alloc] initWithFilterPredicates:set];
		ret = query.items.count;
		//	NSLog(@"media count: %@", query.items);
		[query release];

		return ret;
	}
}

+ (NSObject*)alloc_media_item_artist:(NSString*)artist album:(NSString*)album title:(NSString*)title
{
	@synchronized(self)
	{
		NSMutableSet*	set = [NSMutableSet setWithCapacity:3];
		MPMediaQuery*	query;
		NSObject*		ret;

		if (album != nil)
			[set addObject:[MPMediaPropertyPredicate predicateWithValue:album forProperty:MPMediaItemPropertyAlbumTitle]];
		if (artist != nil)
			[set addObject:[MPMediaPropertyPredicate predicateWithValue:artist forProperty:MPMediaItemPropertyArtist]];
		if (title != nil)
			[set addObject:[MPMediaPropertyPredicate predicateWithValue:title forProperty:MPMediaItemPropertyTitle]];

		query = [[MPMediaQuery alloc] initWithFilterPredicates:set];

		if (query.items.count == 0)
			ret = nil;
		else
			ret = [query.items objectAtIndex:0];
		//	NSLog(@"media item: %@", ret);
		[query release];

		return ret;
	}
}
#endif

+ (NSDictionary*)dict_itunes_country
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
		@"AR",
		@"Argentina",
		@"AU",
		@"Australia", 
		@"AT",
		@"Austria", 
		@"BE",
		@"Belgium", 
		@"BR",
		@"Brazil", 
		@"CA",
		@"Canada", 
		@"CL",
		@"Chile", 
		@"CN",
		@"China", 
		@"CO",
		@"Colombia", 
		@"CR",
		@"Costa Rica", 
		@"HR",
		@"Croatia", 
		@"CZ",
		@"Czech Republic", 
		@"DK",
		@"Denmark", 
		@"SV",
		@"El Salvador", 
		@"FI",
		@"Finland", 
		@"FR",
		@"France", 
		@"DE",
		@"Germany", 
		@"GR",
		@"Greece", 
		@"GT",
		@"Guatemala", 
		@"HK",
		@"Hong Kong", 
		@"HU",
		@"Hungary", 
		@"IN",
		@"India", 
		@"ID",
		@"Indonesia", 
		@"IE",
		@"Ireland", 
		@"IL",
		@"Israel", 
		@"IT",
		@"Italy", 
		@"JP",
		@"Japan", 
		@"KR",
		@"Korea, Republic Of", 
		@"KW",
		@"Kuwait", 
		@"LB",
		@"Lebanon", 
		@"LU",
		@"Luxembourg", 
		@"MY",
		@"Malaysia", 
		@"MX",
		@"Mexico", 
		@"NL",
		@"Netherlands", 
		@"NZ",
		@"New Zealand", 
		@"NO",
		@"Norway", 
		@"PK",
		@"Pakistan", 
		@"PA",
		@"Panama", 
		@"PE",
		@"Peru", 
		@"PH",
		@"Philippines", 
		@"PL",
		@"Poland", 
		@"PT",
		@"Portugal", 
		@"QA",
		@"Qatar", 
		@"RO",
		@"Romania", 
		@"RU",
		@"Russia", 
		@"SA",
		@"Saudi Arabia", 
		@"SG",
		@"Singapore", 
		@"SK",
		@"Slovakia", 
		@"SI",
		@"Slovenia", 
		@"ZA",
		@"South Africa", 
		@"ES",
		@"Spain", 
		@"LK",
		@"Sri Lanka", 
		@"SE",
		@"Sweden", 
		@"CH",
		@"Switzerland", 
		@"TW",
		@"Taiwan", 
		@"TH",
		@"Thailand", 
		@"TR",
		@"Turkey", 
		@"GB",
		@"United Kingdom", 
		@"US",
		@"United States", 
		@"AE",
		@"United Arab Emirates", 
		@"VE",
		@"Venezuela", 
		@"VN",
		@"Vietnam",
		nil];
}

+ (NSDictionary*)dict_itunes_genre
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
		@"ALL",
		@"All",
		@"20",
		@"Alternative",
		@"2",
		@"Blues",
		@"18",
		@"Hip Hop / Rap",
		@"14",
		@"Pop",
		@"21",
		@"Rock",
		nil];
}

+ (NSDictionary*)dict_itunes_limit
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
		@"10",
		@"Top 10",
		@"15",
		@"Top 15",
		@"20",
		@"Top 20",
		@"30",
		@"Top 30",
		@"50",
		@"Top 50",
		nil];
}

+ (NSDictionary*)dict_country_code2
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
		@"Andorra",
		@"AD",
		@"United Arab Emirates",
		@"AE",
		@"Afghanistan",
		@"AF",
		@"Antigua and Barbuda",
		@"AG",
		@"Anguilla",
		@"AI",
		@"Albania",
		@"AL",
		@"Armenia",
		@"AM",
		@"Netherlands Antilles",
		@"AN",
		@"Angola",
		@"AO",
		@"Antarctica",
		@"AQ",
		@"Argentina",
		@"AR",
		@"American Samoa",
		@"AS",
		@"Austria",
		@"AT",
		@"Australia",
		@"AU",
		@"Aruba",
		@"AW",
		@"Aland Islands",
		@"AX",
		@"Azerbaijan",
		@"AZ",
		@"Bosnia and Herzegovina",
		@"BA",
		@"Barbados",
		@"BB",
		@"Bangladesh",
		@"BD",
		@"Belgium",
		@"BE",
		@"Burkina Faso",
		@"BF",
		@"Bulgaria",
		@"BG",
		@"Bahrain",
		@"BH",
		@"Burundi",
		@"BI",
		@"Benin",
		@"BJ",
		@"Bermuda",
		@"BM",
		@"Brunei Darussalam",
		@"BN",
		@"Bolivia",
		@"BO",
		@"Brazil",
		@"BR",
		@"Bahamas",
		@"BS",
		@"Bhutan",
		@"BT",
		@"Bouvet Island",
		@"BV",
		@"Botswana",
		@"BW",
		@"Belarus",
		@"BY",
		@"Belize",
		@"BZ",
		@"Canada",
		@"CA",
		@"Cocos (Keeling) Islands",
		@"CC",
		@"Democratic Republic of the Congo",
		@"CD",
		@"Central African Republic",
		@"CF",
		@"Congo",
		@"CG",
		@"Switzerland",
		@"CH",
		@"Cote D'Ivoire (Ivory Coast)",
		@"CI",
		@"Cook Islands",
		@"CK",
		@"Chile",
		@"CL",
		@"Cameroon",
		@"CM",
		@"China",
		@"CN",
		@"Colombia",
		@"CO",
		@"Costa Rica",
		@"CR",
		@"Serbia and Montenegro",
		@"CS",
		@"Cuba",
		@"CU",
		@"Cape Verde",
		@"CV",
		@"Christmas Island",
		@"CX",
		@"Cyprus",
		@"CY",
		@"Czech Republic",
		@"CZ",
		@"Germany",
		@"DE",
		@"Djibouti",
		@"DJ",
		@"Denmark",
		@"DK",
		@"Dominica",
		@"DM",
		@"Dominican Republic",
		@"DO",
		@"Algeria",
		@"DZ",
		@"Ecuador",
		@"EC",
		@"Estonia",
		@"EE",
		@"Egypt",
		@"EG",
		@"Western Sahara",
		@"EH",
		@"Eritrea",
		@"ER",
		@"Spain",
		@"ES",
		@"Ethiopia",
		@"ET",
		@"Finland",
		@"FI",
		@"Fiji",
		@"FJ",
		@"Falkland Islands (Malvinas)",
		@"FK",
		@"Federated States of Micronesia",
		@"FM",
		@"Faroe Islands",
		@"FO",
		@"France",
		@"FR",
		@"France, Metropolitan",
		@"FX",
		@"Gabon",
		@"GA",
		@"Great Britain (UK)",
		@"GB",
		@"Grenada",
		@"GD",
		@"Georgia",
		@"GE",
		@"French Guiana",
		@"GF",
		@"Ghana",
		@"GH",
		@"Gibraltar",
		@"GI",
		@"Greenland",
		@"GL",
		@"Gambia",
		@"GM",
		@"Guinea",
		@"GN",
		@"Guadeloupe",
		@"GP",
		@"Equatorial Guinea",
		@"GQ",
		@"Greece",
		@"GR",
		@"S. Georgia and S. Sandwich Islands",
		@"GS",
		@"Guatemala",
		@"GT",
		@"Guam",
		@"GU",
		@"Guinea-Bissau",
		@"GW",
		@"Guyana",
		@"GY",
		@"Hong Kong",
		@"HK",
		@"Heard Island and McDonald Islands",
		@"HM",
		@"Honduras",
		@"HN",
		@"Croatia (Hrvatska)",
		@"HR",
		@"Haiti",
		@"HT",
		@"Hungary",
		@"HU",
		@"Indonesia",
		@"ID",
		@"Ireland",
		@"IE",
		@"Israel",
		@"IL",
		@"India",
		@"IN",
		@"British Indian Ocean Territory",
		@"IO",
		@"Iraq",
		@"IQ",
		@"Iran",
		@"IR",
		@"Iceland",
		@"IS",
		@"Italy",
		@"IT",
		@"Jamaica",
		@"JM",
		@"Jordan",
		@"JO",
		@"Japan",
		@"JP",
		@"Kenya",
		@"KE",
		@"Kyrgyzstan",
		@"KG",
		@"Cambodia",
		@"KH",
		@"Kiribati",
		@"KI",
		@"Comoros",
		@"KM",
		@"Saint Kitts and Nevis",
		@"KN",
		@"Korea (North)",
		@"KP",
		@"Korea (South)",
		@"KR",
		@"Kuwait",
		@"KW",
		@"Cayman Islands",
		@"KY",
		@"Kazakhstan",
		@"KZ",
		@"Laos",
		@"LA",
		@"Lebanon",
		@"LB",
		@"Saint Lucia",
		@"LC",
		@"Liechtenstein",
		@"LI",
		@"Sri Lanka",
		@"LK",
		@"Liberia",
		@"LR",
		@"Lesotho",
		@"LS",
		@"Lithuania",
		@"LT",
		@"Luxembourg",
		@"LU",
		@"Latvia",
		@"LV",
		@"Libya",
		@"LY",
		@"Morocco",
		@"MA",
		@"Monaco",
		@"MC",
		@"Moldova",
		@"MD",
		@"Madagascar",
		@"MG",
		@"Marshall Islands",
		@"MH",
		@"Macedonia",
		@"MK",
		@"Mali",
		@"ML",
		@"Myanmar",
		@"MM",
		@"Mongolia",
		@"MN",
		@"Macao",
		@"MO",
		@"Northern Mariana Islands",
		@"MP",
		@"Martinique",
		@"MQ",
		@"Mauritania",
		@"MR",
		@"Montserrat",
		@"MS",
		@"Malta",
		@"MT",
		@"Mauritius",
		@"MU",
		@"Maldives",
		@"MV",
		@"Malawi",
		@"MW",
		@"Mexico",
		@"MX",
		@"Malaysia",
		@"MY",
		@"Mozambique",
		@"MZ",
		@"Namibia",
		@"NA",
		@"New Caledonia",
		@"NC",
		@"Niger",
		@"NE",
		@"Norfolk Island",
		@"NF",
		@"Nigeria",
		@"NG",
		@"Nicaragua",
		@"NI",
		@"Netherlands",
		@"NL",
		@"Norway",
		@"NO",
		@"Nepal",
		@"NP",
		@"Nauru",
		@"NR",
		@"Niue",
		@"NU",
		@"New Zealand (Aotearoa)",
		@"NZ",
		@"Oman",
		@"OM",
		@"Panama",
		@"PA",
		@"Peru",
		@"PE",
		@"French Polynesia",
		@"PF",
		@"Papua New Guinea",
		@"PG",
		@"Philippines",
		@"PH",
		@"Pakistan",
		@"PK",
		@"Poland",
		@"PL",
		@"Saint Pierre and Miquelon",
		@"PM",
		@"Pitcairn",
		@"PN",
		@"Puerto Rico",
		@"PR",
		@"Palestinian Territory",
		@"PS",
		@"Portugal",
		@"PT",
		@"Palau",
		@"PW",
		@"Paraguay",
		@"PY",
		@"Qatar",
		@"QA",
		@"Reunion",
		@"RE",
		@"Romania",
		@"RO",
		@"Russian Federation",
		@"RU",
		@"Rwanda",
		@"RW",
		@"Saudi Arabia",
		@"SA",
		@"Solomon Islands",
		@"SB",
		@"Seychelles",
		@"SC",
		@"Sudan",
		@"SD",
		@"Sweden",
		@"SE",
		@"Singapore",
		@"SG",
		@"Saint Helena",
		@"SH",
		@"Slovenia",
		@"SI",
		@"Svalbard and Jan Mayen",
		@"SJ",
		@"Slovakia",
		@"SK",
		@"Sierra Leone",
		@"SL",
		@"San Marino",
		@"SM",
		@"Senegal",
		@"SN",
		@"Somalia",
		@"SO",
		@"Suriname",
		@"SR",
		@"Sao Tome and Principe",
		@"ST",
		@"USSR (former)",
		@"SU",
		@"El Salvador",
		@"SV",
		@"Syria",
		@"SY",
		@"Swaziland",
		@"SZ",
		@"Turks and Caicos Islands",
		@"TC",
		@"Chad",
		@"TD",
		@"French Southern Territories",
		@"TF",
		@"Togo",
		@"TG",
		@"Thailand",
		@"TH",
		@"Tajikistan",
		@"TJ",
		@"Tokelau",
		@"TK",
		@"Timor-Leste",
		@"TL",
		@"Turkmenistan",
		@"TM",
		@"Tunisia",
		@"TN",
		@"Tonga",
		@"TO",
		@"East Timor",
		@"TP",
		@"Turkey",
		@"TR",
		@"Trinidad and Tobago",
		@"TT",
		@"Tuvalu",
		@"TV",
		@"Taiwan",
		@"TW",
		@"Tanzania",
		@"TZ",
		@"Ukraine",
		@"UA",
		@"Uganda",
		@"UG",
		@"United Kingdom",
		@"UK",
		@"United States Minor Outlying Islands",
		@"UM",
		@"United States",
		@"US",
		@"Uruguay",
		@"UY",
		@"Uzbekistan",
		@"UZ",
		@"Vatican City State (Holy See)",
		@"VA",
		@"Saint Vincent and the Grenadines",
		@"VC",
		@"Venezuela",
		@"VE",
		@"Virgin Islands (British)",
		@"VG",
		@"Virgin Islands (U.S.)",
		@"VI",
		@"Viet Nam",
		@"VN",
		@"Vanuatu",
		@"VU",
		@"Wallis and Futuna",
		@"WF",
		@"Samoa",
		@"WS",
		@"Yemen",
		@"YE",
		@"Mayotte",
		@"YT",
		@"Yugoslavia (former)",
		@"YU",
		@"South Africa",
		@"ZA",
		@"Zambia",
		@"ZM",
		@"Zaire (former)",
		@"ZR",
		@"Zimbabwe",
		@"ZW",
#if 0
		BIZ   Business
		COM   Commercial
		EDU   US Educational
		GOV   US Government
		INT   International
		MIL   US Military
		NET   Network
		ORG   Nonprofit Organization
		PRO   Professional Services
		AERO   Aeronautic
		ARPA   Arpanet Technical Infrastructure
		COOP   Cooperative
		INFO   Info Domain
		NAME   Personal Name
		NATO   North Atlantic Treaty Organization
#endif
		nil];
}

@end