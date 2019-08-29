//
//  NSString+DNCHTML.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

#import <Foundation/Foundation.h>

@interface NSString (DNCHTML)

/**
 *  Creates and returns a new NSString object initialized with the source string, with XML entities replaced with their decoded values.  Current support includes: &amp;, &nbsp;, &apos;, &quot;, &lt;, &gt; and most numeric character representations.
 *
 *  @return A new NSString object, initialized with the source string, with XML entities replaced with their decoded values.
 */
- (NSString *)dncStringByDecodingXMLEntities;

@end
