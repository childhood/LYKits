#import "MQMapView.h"
#if 0
@implementation MKMapView (MQMapView)

- (id)init
{
	self = [super init];

	if (self != nil)
	{
		self.delegate = self;
	}

	return self;
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if(![annotation isKindOfClass:[MQAnnotation class]])	 // Don't mess user location
        return nil;

    MKAnnotationView *annotationView = [aMapView dequeueReusableAnnotationViewWithIdentifier:@"spot"];
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

@end
#endif
