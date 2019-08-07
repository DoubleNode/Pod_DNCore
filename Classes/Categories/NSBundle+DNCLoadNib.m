//
//  NSBundle+DNCLoadNib.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2019/08/07.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

@import PodAsset;

#import "NSBundle+DNCLoadNib.h"

@implementation NSBundle (DNCLoadNib)

- (id)dncLoadNibForClass:(Class)itemClass
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
