//
//  NSDate+DNCUtils
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import "NSDate+DNCUtils.h"

@implementation NSDate (DNCUtils)

- (NSDate*)dncToLocalTime
{
    NSTimeZone* tz      = [NSTimeZone localTimeZone];
    NSInteger   seconds = [tz secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

- (NSDate*)dncToGlobalTime
{
    NSTimeZone* tz      = [NSTimeZone localTimeZone];
    NSInteger   seconds = -[tz secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

// Return the first day of the month for the month that 'date' falls in:
- (NSDate*)firstDayOfMonthForDate:(NSDate*)date
{
    NSCalendar*         calendar    = [NSCalendar currentCalendar];
    NSDateComponents*   components  = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                  fromDate:date];
    components.day  = 1;
    return [calendar dateFromComponents:components];
}

// Return the last day of the month for the month that 'date' falls in:
- (NSDate*)lastDayOfMonthForDate:(NSDate*)date
{
    NSCalendar*         calendar    = [NSCalendar currentCalendar];
    NSDateComponents*   components  = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                  fromDate:date];
    components.month    += 1;
    components.day      = 0;
    return [calendar dateFromComponents:components];
}

@end
