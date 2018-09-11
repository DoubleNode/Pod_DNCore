//
//  NSAttributedString+StringFromHTML.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//
//  Derived from work originally created by
//  Created by Orta on 06/08/2013.
//  Copyright (c) 2013 Art.sy. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (StringFromHTML)

+ (NSAttributedString*)attributedStringWithTextParams:(NSDictionary*)textParams
                                              andHTML:(NSString*)HTML;

@end

NS_ASSUME_NONNULL_END
