//
// Created by Eliasz Sawicki on 25/07/15.
//

#import "Calendar.h"
#import <EventKit/EventKit.h>


@implementation Calendar {

    EKEventStore *_eventStore;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _eventStore = [EKEventStore new];
        [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSLog(@"Access to calendar granted");
            } else {
                NSLog(@"No access to calendar");
            }
        }];
    }
    return self;
}


- (NSArray *)availableCalendars {
    NSArray *calendars = [_eventStore calendarsForEntityType:EKEntityTypeEvent];
    return calendars;
}

- (NSArray *)eventsFromCalendar:(EKCalendar *)calendar fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSPredicate *predicate = [_eventStore predicateForEventsWithStartDate:fromDate
                                                                  endDate:toDate
                                                                calendars:@[calendar]];

    NSArray *events = [_eventStore eventsMatchingPredicate:predicate];

    return events;
}

- (NSTimeInterval)durationOfEventsInCalendar:(EKCalendar *)calendar fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSArray *events = [self eventsFromCalendar:calendar fromDate:fromDate toDate:toDate];
    NSTimeInterval sum = 0;

    for (EKEvent *event in events) {
        NSDate *startDate = event.startDate;
        NSDate *endDate = event.endDate;
        NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];

        sum += timeInterval;
    }

    return sum;
}

@end