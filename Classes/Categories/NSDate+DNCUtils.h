//
//  NSDate+DNCUtils.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DNCUtils)

+ (NSDate*)dncDateWithMilitaryTimeSinceMidnight:(NSUInteger)militaryTime
                                    forTimeZone:(NSTimeZone*)timeZone;

- (NSDate*)dncToLocalTime;
- (NSDate*)dncToGlobalTime;

// Return the first day of the month for the month that 'date' falls in:
+ (NSDate*)firstDayOfMonthForDate:(NSDate*)date;
- (NSDate*)firstDayOfMonth;

// Return the last day of the month for the month that 'date' falls in:
+ (NSDate*)lastDayOfMonthForDate:(NSDate*)date;
- (NSDate*)lastDayOfMonth;

@end
