//
//  NSBundle+DNCLoadNib.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

@import PodAsset;

#import "NSBundle+DNCLoadNib.h"

@implementation NSBundle (DNCLoadNib)

+ (id)dncLoadNibForClass:(Class)itemClass
{
    NSString*   itemClassName   = NSStringFromClass(itemClass);
    NSBundle*   itemBundle      = [PodAsset bundleForPod:itemClassName];
    if (!itemBundle)
    {
        itemBundle  = [NSBundle bundleForClass:itemClass];
    }
    
    NSArray*    items   = [itemBundle loadNibNamed:itemClassName
                                             owner:nil
                                           options:nil];
    id  itemNib = items.firstObject;
    
    return itemNib;
}

@end
