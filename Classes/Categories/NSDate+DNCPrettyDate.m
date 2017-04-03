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

- (NSString*)simpleDateRange:(NSDate*)end
{
    if ([end isEqualToDate:self])
    {
        NSString*    dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMM d, yyyy"
                                                                      options:0
                                                                       locale:NSLocale.currentLocale];
        
        NSDateFormatter*    dateFormatter = NSDateFormatter.alloc.init;
        [dateFormatter setDateFormat:dateFormat];
        
        return [dateFormatter stringFromDate:self];
    }
    
    NSString*    startFormat    = [NSDateFormatter dateFormatFromTemplate:@"MMM d"
                                                                  options:0
                                                                   locale:NSLocale.currentLocale];
    
    NSString*    endFormat      = [NSDateFormatter dateFormatFromTemplate:@"d, yyyy"
                                                                  options:0
                                                                   locale:NSLocale.currentLocale];

    NSDateFormatter*    startFormatter = [[NSDateFormatter alloc] init];
    [startFormatter setDateFormat:startFormat];

    NSString*   startStr    = [startFormatter stringFromDate:self];
    
    NSDateFormatter*    endFormatter    = [[NSDateFormatter alloc] init];
    [endFormatter setDateFormat:endFormat];
    
    NSString*   endStr  = [endFormatter stringFromDate:end];
    
    return [NSString stringWithFormat:@"%@-%@", startStr, endStr];
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
