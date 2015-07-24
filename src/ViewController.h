#import <UIKit/UIKit.h>

@class EKEventStore;

@interface ViewController : UIViewController

@property(nonatomic, strong) EKEventStore *store;
@end
