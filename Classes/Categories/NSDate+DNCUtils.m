//
//  NSDate+DNCUtils
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import "NSDate+DNCUtils.h"

@implementation NSDate (DNCUtils)

+ (NSDate*)dncDateWithMilitaryTimeSinceMidnight:(NSUInteger)militaryTime
                                    forTimeZone:(NSTimeZone*)timeZone
{
    NSString*   dateFormat  = [NSDateFormatter dateFormatFromTemplate:@"hmm"
                                                              options:0
                                                               locale:NSLocale.currentLocale];
    
    NSDateFormatter*    dateFormatter = NSDateFormatter.alloc.init;
    [dateFormatter setDateFormat:dateFormat];
    
    NSDate* date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%lu", (unsigned long)militaryTime]];

    return date;
}

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
+ (NSDate*)firstDayOfMonthForDate:(NSDate*)date
{
    NSCalendar*         calendar    = [NSCalendar currentCalendar];
    NSDateComponents*   components  = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                  fromDate:date];
    components.day  = 1;
    return [calendar dateFromComponents:components];
}

- (NSDate*)firstDayOfMonth
{
    return [NSDate firstDayOfMonthForDate:self];
}

// Return the last day of the month for the month that 'date' falls in:
+ (NSDate*)lastDayOfMonthForDate:(NSDate*)date
{
    NSCalendar*         calendar    = [NSCalendar currentCalendar];
    NSDateComponents*   components  = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                  fromDate:date];
    components.month    += 1;
    components.day      = 0;
    return [calendar dateFromComponents:components];
}

- (NSDate*)lastDayOfMonth
{
    return [NSDate lastDayOfMonthForDate:self];
}

@end
