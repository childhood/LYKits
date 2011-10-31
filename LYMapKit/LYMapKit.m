#import "LYMapKit.h"

//	testing classes here

#if 1
@implementation LYPlaceManager

@synthesize location_manager;
@synthesize reverse_geocoder;
@synthesize placemark;
@synthesize mode;
@synthesize delegate;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		mode = @"once";			//	once, move (distance), always (interval)
		location_manager = [[CLLocationManager alloc] init];
		location_manager.delegate = self;
		[location_manager startUpdatingLocation];
	}
	return self;
}

- (void)dealloc
{
	if ([mode is:@"once"])
		[placemark release];
	[super dealloc];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)new fromLocation:(CLLocation*)old
{
	if ([mode is:@"once"])
	{
		//	NSLog(@"location: %@", manager);
		reverse_geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:new.coordinate];
		//reverse_geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:[ly location_of_city:@"Auckland"]];
		reverse_geocoder.delegate = self;
		[reverse_geocoder start];
		[location_manager stopUpdatingLocation];
		//[location_manager release];
	}
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
	if (delegate != nil)
		[delegate perform_string:@"locationManager:didFailWithError:" with:manager with:error];
}

- (void)reverseGeocoder:(MKReverseGeocoder*)geocoder didFindPlacemark:(MKPlacemark*)a_placemark
{
	if ([mode is:@"once"])
	{
		//	NSLog(@"place: %@", a_placemark.country);
		placemark = a_placemark;
		if (delegate != nil)
			[delegate perform_string:@"reverseGeocoder:didFindPlacemark:" with:geocoder with:a_placemark];
		//[reverse_geocoder release];
	}
}

- (void)reverseGeocoder:(MKReverseGeocoder*)geocoder didFailWithError:(NSError*)error
{
	NSLog(@"GEOCODER error: %@", error);
	if (delegate != nil)
		[delegate perform_string:@"reverseGeocoder:didFailWithError:" with:geocoder with:error];
}

@end
#endif
