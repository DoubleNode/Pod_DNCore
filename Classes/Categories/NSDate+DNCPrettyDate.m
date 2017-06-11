//
//  NSDate+DNCPrettyDate.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import "NSDate+DNCPrettyDate.h"

@implementation NSDate (DNCPrettyDate)

- (NSString*)shortPrettyDate
{
    NSString*   prettyTimestamp;

    float   delta = [self timeIntervalSinceNow] * -1;
    if (delta < 60)
    {
        prettyTimestamp = NSLocalizedString(@"just now", nil);
        //prettyTimestamp = [NSString stringWithFormat:@"%d seconds ago", (int)delta];
    }
    else if (delta < 120)
    {
        prettyTimestamp = NSLocalizedString(@"1 min ago", nil);
    }
    else if (delta < 3600)
    {
        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"%d mins ago", nil), (int)floor(delta / 60.0f)];
    }
    else if (delta < 7200)
    {
        prettyTimestamp = NSLocalizedString(@"1 hr ago", nil);
    }
    else if (delta < 86400)
    {
        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"%d hrs ago", nil), (int)floor(delta / 3600.0f)];
    }
    else if (delta < (86400 * 2))
    {
        prettyTimestamp = NSLocalizedString(@"1 day ago", nil);
    }
    else if (delta < (86400 * 7))
    {
        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"%d days ago", nil), (int)floor(delta / 86400.0f)];
    }
    else if (delta < (86400 * 14))
    {
        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"1 wk ago", nil)];
    }
    else if (delta < (86400 * 35))
    {
        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"%d wks ago", nil), (int)floor(delta / (86400.0f * 7))];
    }
    else
    {
        NSDateFormatter*    formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];

        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"on %@", nil), [formatter stringFromDate:self]];
    }

    return prettyTimestamp;
}

- (NSString*)prettyDate
{
    NSString*   prettyTimestamp;
    
    float   delta = [self timeIntervalSinceNow] * -1;
    if (delta < 60)
    {
        prettyTimestamp = NSLocalizedString(@"just now", nil);
        //prettyTimestamp = [NSString stringWithFormat:@"%d seconds ago", (int)delta];
    }
    else if (delta < 120)
    {
        prettyTimestamp = NSLocalizedString(@"one minute ago", nil);
    }
    else if (delta < 3600)
    {
        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"%d minutes ago", nil), (int)floor(delta / 60.0f)];
    }
    else if (delta < 7200)
    {
        prettyTimestamp = NSLocalizedString(@"one hour ago", nil);
    }
    else if (delta < 86400)
    {
        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"%d hours ago", nil), (int)floor(delta / 3600.0f)];
    }
    else if (delta < (86400 * 2))
    {
        prettyTimestamp = NSLocalizedString(@"one day ago", nil);
    }
    else if (delta < (86400 * 7))
    {
        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"%d days ago", nil), (int)floor(delta / 86400.0f)];
    }
    else if (delta < (86400 * 14))
    {
        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"one week ago", nil)];
    }
    else if (delta < (86400 * 35))
    {
        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"%d weeks ago", nil), (int)floor(delta / (86400.0f * 7))];
    }
    else
    {
        NSDateFormatter*    formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        prettyTimestamp = [NSString stringWithFormat:NSLocalizedString(@"on %@", nil), [formatter stringFromDate:self]];
    }
    
    return prettyTimestamp;
}

- (NSString*)dateRange:(NSDate*)end
       withMonthFormat:(NSString*)monthFormatStr
          andDayFormat:(NSString*)dayFormatStr
         andYearFormat:(NSString*)yearFormatStr
{
    NSString*   dyFormatStr     = [NSString stringWithFormat:@"%@%@%@", dayFormatStr, ((dayFormatStr.length && yearFormatStr.length) ? @", " : @""), yearFormatStr];
    NSString*   mdFormatStr     = [NSString stringWithFormat:@"%@%@%@", monthFormatStr, ((monthFormatStr.length && dayFormatStr.length) ? @" " : @""), dayFormatStr];
    NSString*   mdyFormatStr    = [NSString stringWithFormat:@"%@%@%@%@%@", monthFormatStr, ((monthFormatStr.length && (dayFormatStr.length || yearFormatStr.length)) ? @" " : @""), dayFormatStr, ((dayFormatStr.length && yearFormatStr.length) ? @", " : @""), yearFormatStr];

    if ([end isEqualToDate:self])
    {
        NSString*   dateFormat      = [NSDateFormatter dateFormatFromTemplate:mdyFormatStr
                                                                      options:0
                                                                       locale:NSLocale.currentLocale];
        
        NSDateFormatter*    dateFormatter = NSDateFormatter.alloc.init;
        [dateFormatter setDateFormat:dateFormat];
        
        return [dateFormatter stringFromDate:self];
    }
    
    NSString*    monthFormat    = [NSDateFormatter dateFormatFromTemplate:@"MMM"
                                                                  options:0
                                                                   locale:NSLocale.currentLocale];
    NSDateFormatter*    monthFormatter = NSDateFormatter.alloc.init;
    [monthFormatter setDateFormat:monthFormat];
    
    NSString*   startFormat     = [NSDateFormatter dateFormatFromTemplate:mdFormatStr
                                                                  options:0
                                                                   locale:NSLocale.currentLocale];
    
    NSString*   endFormat;
    NSString*   separatorStr;
    
    NSString*   startMonthStr   = [monthFormatter stringFromDate:self];
    NSString*   endMonthStr     = [monthFormatter stringFromDate:end];
    
    if ([startMonthStr isEqualToString:endMonthStr])
    {
        separatorStr    = @"-";
        endFormat       = [NSDateFormatter dateFormatFromTemplate:dyFormatStr
                                                          options:0
                                                           locale:NSLocale.currentLocale];
    }
    else
    {
        separatorStr    = @" - ";
        endFormat       = [NSDateFormatter dateFormatFromTemplate:mdyFormatStr
                                                          options:0
                                                           locale:NSLocale.currentLocale];
    }
    
    NSDateFormatter*    startFormatter  = NSDateFormatter.alloc.init;   [startFormatter setDateFormat:startFormat];
    NSDateFormatter*    endFormatter    = NSDateFormatter.alloc.init;   [endFormatter setDateFormat:endFormat];
    
    NSString*   startStr    = [startFormatter stringFromDate:self];
    NSString*   endStr      = [endFormatter stringFromDate:end];
    
    return [NSString stringWithFormat:@"%@%@%@", startStr, separatorStr, endStr];
}

- (BOOL)isSameYearAsNow
{
    unsigned        units      = NSCalendarUnitYear;
    NSCalendar*     calendar   = [NSCalendar.alloc initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents*   selfComponents  = [calendar components:units
                                                      fromDate:self];
    NSDateComponents*   nowComponents   = [calendar components:units
                                                      fromDate:NSDate.date];
    
    return (selfComponents.year == nowComponents.year);
}

- (NSString*)smartDateRange:(NSDate*)end
{
    if (self.isSameYearAsNow)
    {
        return [self simpleDateRange:end];
    }
    
    return [self fullDateRange:end];
}

- (NSString*)simpleDateRange:(NSDate*)end
{
    return [self dateRange:end
           withMonthFormat:@"MMM"
              andDayFormat:@"d"
             andYearFormat:@""];
}

- (NSString*)fullDateRange:(NSDate*)end
{
    return [self dateRange:end
           withMonthFormat:@"MMM"
              andDayFormat:@"d"
             andYearFormat:@"yyyy"];
}

- (NSString*)smartDate
{
    if (self.isSameYearAsNow)
    {
        return self.simpleDate;
    }
    
    return self.fullDate;
}

- (NSString*)simpleDate
{
    return [self dateRange:self
           withMonthFormat:@"MMM"
              andDayFormat:@"d"
             andYearFormat:@""];
}

- (NSString*)fullDate
{
    return [self dateRange:self
           withMonthFormat:@"MMM"
              andDayFormat:@"d"
             andYearFormat:@"yyyy"];
}

- (NSString*)localizedDate
{
    NSString*   datestr = [NSDateFormatter localizedStringFromDate:self
                                                         dateStyle:NSDateFormatterMediumStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    if ([datestr isEqualToString:@"(null)"] == YES)
    {
        return @"";
    }
    
    return datestr;
}

- (NSString*)localizedTime
{
    NSString*   timestr = [NSDateFormatter localizedStringFromDate:self
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterMediumStyle];
    if ([timestr isEqualToString:@"(null)"] == YES)
    {
        return @"";
    }
    
    return timestr;
}

- (NSString*)localizedFullDate
{
    NSString*   datestr = [NSDateFormatter localizedStringFromDate:self
                                                         dateStyle:NSDateFormatterFullStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    if ([datestr isEqualToString:@"(null)"] == YES)
    {
        return @"";
    }
    
    return datestr;
}

- (NSString*)localizedFullTime
{
    NSString*   timestr = [NSDateFormatter localizedStringFromDate:self
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterFullStyle];
    if ([timestr isEqualToString:@"(null)"] == YES)
    {
        return @"";
    }
    
    return timestr;
}

- (NSString*)localizedLongDate
{
    NSString*   datestr = [NSDateFormatter localizedStringFromDate:self
                                                         dateStyle:NSDateFormatterLongStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    if ([datestr isEqualToString:@"(null)"] == YES)
    {
        return @"";
    }
    
    return datestr;
}

- (NSString*)localizedLongTime
{
    NSString*   timestr = [NSDateFormatter localizedStringFromDate:self
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterLongStyle];
    if ([timestr isEqualToString:@"(null)"] == YES)
    {
        return @"";
    }
    
    return timestr;
}

- (NSString*)localizedShortDate
{
    NSString*   datestr = [NSDateFormatter localizedStringFromDate:self
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterNoStyle];
    if ([datestr isEqualToString:@"(null)"] == YES)
    {
        return @"";
    }
    
    return datestr;
}

- (NSString*)localizedShortTime
{
    NSString*   timestr = [NSDateFormatter localizedStringFromDate:self
                                                         dateStyle:NSDateFormatterNoStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    if ([timestr isEqualToString:@"(null)"] == YES)
    {
        return @"";
    }
    
    return timestr;
}

@end
