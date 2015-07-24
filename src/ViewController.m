#import "ViewController.h"
#import <EventKit/EventKit.h>
@interface ViewController ()

@end

@implementation ViewController


- (void)loadView {
    [self setupView];
    [super loadView];
}

- (void)setupView {
    self.store = [EKEventStore new];
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSLog(@"Access to calendar granted");
        } else {
            NSLog(@"No access to calendar");
        }
    }];

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *oneDayAgoComponents = [NSDateComponents new];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];

    NSDateComponents *oneYearFromNowComponents = [NSDateComponents new];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];

    NSPredicate *predicate = [_store predicateForEventsWithStartDate:oneDayAgo
                                                             endDate:oneYearFromNow
                                                           calendars:nil];

    NSArray *events = [_store eventsMatchingPredicate:predicate];

    for (NSInteger i = 0; i < events.count; i++) {
        NSLog(events.description);
    }

}


@end