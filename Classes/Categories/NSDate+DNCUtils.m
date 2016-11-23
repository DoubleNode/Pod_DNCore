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

@end
