//
// Created by Eliasz Sawicki on 25/07/15.
//

#import "Calendar.h"
#import "NSDate+DateTools.h"
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
    NSDate *endDate = [toDate dateByAddingDays:1];
    NSPredicate *predicate = [_eventStore predicateForEventsWithStartDate:fromDate
                                                                  endDate:endDate
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

- (NSInteger)workingDaysBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *components;
    NSTimeInterval timeBetweenDates = [endDate timeIntervalSinceDate:startDate];
    NSInteger daysBetween = (NSInteger) (timeBetweenDates / (60 * 60 * 24));

    components = [calendar components:NSWeekdayCalendarUnit fromDate:startDate];
    NSInteger firstWeekday = [components weekday];
    NSLog(@"first weekday %d", firstWeekday);
    NSInteger workingDays = 0;
    for (NSInteger i = 0; i <= daysBetween; i++) {
        firstWeekday = firstWeekday % 8;
        if (firstWeekday == 0) {
            firstWeekday = 1;
        }
        if (firstWeekday != 1 && firstWeekday != 7) {
            workingDays++;
        }
        firstWeekday++;
    }

    return workingDays;
}

@end