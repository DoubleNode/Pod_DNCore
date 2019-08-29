//
//  DNCDate.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

@import Foundation;

@interface DNCDate : NSDateComponents

+ (id)dateWithComponentFlags:(unsigned)flags fromDate:(NSDate*)date;
+ (id)dateWithComponents:(NSDateComponents*)components;

- (id)initWithComponentFlags:(unsigned)flags fromDate:(NSDate*)date;
- (id)initWithComponents:(NSDateComponents*)components;

- (id)initWithCoder:(NSCoder*)decoder;
- (void)encodeWithCoder:(NSCoder*)encoder;

- (NSComparisonResult)compare:(id)otherObject;
- (BOOL)isEqualToDNDate:(DNCDate*)otherDate;

- (NSDate*)date;

- (NSString*)dayOfWeekString;
- (NSString*)dateString;
- (NSString*)timeString;

@end
