//
//  NSString+DNCContains.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import "NSString+DNCContains.h"

@implementation NSString (DNCContains)

- (BOOL)contains:(NSString*)subString
{
    return ([self rangeOfString:subString].location != NSNotFound);
}

@end
