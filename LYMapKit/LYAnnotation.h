#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>

@interface LYAnnotation: NSObject <MKAnnotation>
{
	CLLocationCoordinate2D  coordinate;
	NSString*               title;
	NSString*               subtitle;
}
@property (nonatomic, readonly) CLLocationCoordinate2D  coordinate;
@property (nonatomic, retain) NSString*                 title;
@property (nonatomic, retain) NSString*             	subtitle;

- (void)setCoordinate:(CLLocationCoordinate2D)a_coordinate;

@end

#if 0
@interface map_annotationAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow*	window;
	IBOutlet MKMapView*		map_view;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction)action_spot:(id)sender;

@end
#endif

