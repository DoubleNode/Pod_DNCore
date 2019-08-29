//
//  UIFont+DNCCustom.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

#import <UIKit/UIKit.h>

@interface UIFont (DNCCustom)

/**
 *  Creates and returns a new UIFont object (works around the iOS oddity which required an additional sizing call).
 *
 *  @param fontName The postscript font name string
 *  @param fontSize The font size (in points)
 *
 *  @return A new UIFont configured according to the specified parameters.
 */
+ (UIFont*)customFontWithName:(NSString*)fontName size:(double)fontSize;

+ (UIFont*)customFontWithNameDebug:(NSString*)fontName size:(double)fontSize;

@end
