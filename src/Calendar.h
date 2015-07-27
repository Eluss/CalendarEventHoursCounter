//
// Created by Eliasz Sawicki on 25/07/15.
//

#import <Foundation/Foundation.h>

@class EKCalendar;


@interface Calendar : NSObject
+ (id)sharedInstance;

- (NSArray *)availableCalendars;

- (NSArray *)eventsFromCalendar:(EKCalendar *)calendar fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (NSTimeInterval)durationOfEventsInCalendar:(EKCalendar *)calendar fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (NSInteger)workingDaysBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;
@end