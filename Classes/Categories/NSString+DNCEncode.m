//
//  NSString+DNCEncode.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import "NSString+DNCEncode.h"

@implementation NSString (DNCEncode)

- (NSString*)urlEncoded
{
    NSMutableString*    output = NSMutableString.string;
    
    const unsigned char*    source = (const unsigned char*)[self UTF8String];
    
    unsigned long sourceLen = strlen((const char*)source);
    
    for (unsigned long i = 0; i < sourceLen; ++i)
    {
        const unsigned char thisChar = source[i];
        if (thisChar == ' ')
        {
            [output appendString:@"+"];
            continue;
        }
        
        if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
            (thisChar >= 'a' && thisChar <= 'z') ||
            (thisChar >= 'A' && thisChar <= 'Z') ||
            (thisChar >= '0' && thisChar <= '9'))
        {
            [output appendFormat:@"%c", thisChar];
            continue;
        }
        
        [output appendFormat:@"%%%02X", thisChar];
    }
    
    return output;
}

@end
