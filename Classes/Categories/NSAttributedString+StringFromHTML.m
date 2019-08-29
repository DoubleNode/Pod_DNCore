//
//  NSAttributedString+StringFromHTML.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//
//  Derived from work originally created by
//  Created by Orta on 06/08/2013.
//  Copyright (c) 2013 Art.sy. All rights reserved.
//

@import ColorUtils;

#import "NSAttributedString+StringFromHTML.h"

@implementation NSAttributedString (StringFromHTML)

/// As we can't use the attributed string attributes params, so generate CSS from it

+ (NSString*)_cssStringFromAttributedStringAttributes:(NSDictionary*)dictionary
{
    NSMutableString*    cssString = [NSMutableString stringWithString:@"<style> p { white-space: nowrap; "];
    
    if ([dictionary objectForKey:NSForegroundColorAttributeName])
    {
        UIColor*    color   = dictionary[NSForegroundColorAttributeName];
        [cssString appendFormat:@"color: %@;", [color stringValue]];
    }
    
    if ([dictionary objectForKey:NSFontAttributeName])
    {
        UIFont* font = dictionary[NSFontAttributeName];
        [cssString appendFormat:@"font-family:'%@'; font-size: %0.1fpx;", font.fontName, roundf(font.pointSize)];
    }
    
    if (dictionary[NSParagraphStyleAttributeName])
    {
        NSParagraphStyle*   style = dictionary[NSParagraphStyleAttributeName];
        [cssString appendFormat:@"line-height:%f em;", style.lineHeightMultiple];
    }
    
    [cssString appendString:@"}"];
    [cssString appendString:@"</style><body>"];
    
    return cssString;
}

+ (NSAttributedString*)attributedStringWithTextParams:(NSDictionary*)textParams
                                              andHTML:(NSString *)HTML
{
    NSDictionary*   importParams = @{
                                     NSDocumentTypeDocumentAttribute:      NSHTMLTextDocumentType,
                                     NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]
                                     };
    
    NSError*    error           = nil;
    NSString*   cssString       = [self _cssStringFromAttributedStringAttributes:textParams];
    NSString*   formatString    = [cssString stringByAppendingFormat:@"%@</body>", HTML];
    NSData*     stringData      = [formatString dataUsingEncoding:NSUTF8StringEncoding];    // NSUnicodeStringEncoding];
    
    NSAttributedString* attributedString = [NSAttributedString.alloc initWithData:stringData
                                                                          options:importParams
                                                               documentAttributes:NULL
                                                                            error:&error];
    if (error)
    {
        return nil;
    }
    
    return attributedString;
}

@end
