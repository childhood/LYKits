#import <UIKit/UIKit.h>

@interface LYSingletonClass: NSObject
@end

@interface LYSingletonViewController: UIViewController
@end

#pragma mark Singleton Example

@interface MySingletonClass: LYSingletonClass
{
    NSString*		property;
}
@property (nonatomic, retain) NSString*		property;
+ (id)shared;
@end
