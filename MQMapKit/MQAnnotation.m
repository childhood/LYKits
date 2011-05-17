#import "MQAnnotation.h"

@implementation MQAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (void)setCoordinate:(CLLocationCoordinate2D)a_coordinate
{
	coordinate = a_coordinate;
}

@end

#if 0

@implementation MQMapViewProvider

- (void)init
{
	CLLocationCoordinate2D pos;
	pos.latitude = 0;
	pos.longitude = 0;

	MQAnnotation* annotation = [[MQAnnotation alloc] init];
	annotation.coordinate = pos;
	annotation.title = @"TITLE";
	annotation.subtitle = @"Subtitle here.";
	[map_view addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(![annotation isKindOfClass:[MQAnnotation class]])	 // Don't mess user location
        return nil;

    MKAnnotationView *annotationView = [map_view dequeueReusableAnnotationViewWithIdentifier:@"spot"];
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"spot"];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [(UIButton *)annotationView.rightCalloutAccessoryView addTarget:self action:@selector(action_spot:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.centerOffset = CGPointMake(7,-15);
        annotationView.calloutOffset = CGPointMake(-8,0);
    }

    // Setup annotation view
    annotationView.image = [UIImage imageNamed:@"pin_yellow.png"];

    return annotationView;
}

- (IBAction)action_spot:(id)sender
{
	NSLog(@"action spot: %@", sender);
}

@end

#endif
