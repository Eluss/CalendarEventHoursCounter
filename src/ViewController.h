#import <UIKit/UIKit.h>

@class EKEventStore;

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, strong) EKEventStore *store;
@end
