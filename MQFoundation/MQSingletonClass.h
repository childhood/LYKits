#import <UIKit/UIKit.h>

@interface MQSingletonClass: NSObject
@end

@interface MQSingletonViewController: UIViewController
@end

#pragma mark Singleton Example

@interface MySingletonClass: MQSingletonClass
{
    NSString*		property;
}
@property (nonatomic, retain) NSString*		property;
+ (id)shared;
@end
