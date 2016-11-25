//
//  UIFont+DNCCustom.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import "UIFont+DNCCustom.h"

@implementation UIFont(DNCCustom)

+ (UIFont*)customFontWithName:(NSString*)fontName size:(double)fontSize
{
    UIFont* retval  = [UIFont fontWithName:fontName size:fontSize];

    return [retval fontWithSize:fontSize];
}

+ (UIFont*)customFontWithNameDebug:(NSString*)fontName size:(double)fontSize
{
    UIFont* retval  = [UIFont fontWithName:fontName size:fontSize];

    // Debugging code to help diagnose missing fonts...
    if (!retval)
    {
        NSArray*    fontFamilies = [UIFont familyNames];
        [fontFamilies enumerateObjectsUsingBlock:^(NSString* fontFamily, NSUInteger idx, BOOL* stop)
         {
             NSArray*   fontNames = [UIFont fontNamesForFamilyName:fontFamily];
             [fontNames enumerateObjectsUsingBlock:^(NSString* fontName, NSUInteger idx, BOOL* stop)
              {
                  NSLog (@"%@: %@", fontFamily, fontName);
              }];
         }];
        
        UIFontDescriptor*   fontDescriptor  = [UIFontDescriptor fontDescriptorWithName:fontName size:fontSize];
        NSLog (@"fontDescriptor: %@", fontDescriptor);
        
        UIFont* font    = [UIFont fontWithDescriptor:fontDescriptor size:fontSize];
        NSLog (@"font: %@", font);
    }
    
    return [retval fontWithSize:fontSize];
}

@end
