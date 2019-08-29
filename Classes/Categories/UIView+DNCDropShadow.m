//
//  UIView+DNCDropShadow.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

#import "UIView+DNCDropShadow.h"

@implementation UIView (DNCDropShadow)

const CGSize    DNVDS_DEFAULT_OFFSET   = (CGSize){ 3, 3 };
const CGFloat   DNVDS_DEFAULT_RADIUS   = 2.0f;
const CGFloat   DNVDS_DEFAULT_OPACITY  = 0.6f;

- (void)addDropShadow
{
    [self addDropShadow:UIColor.blackColor
             withOffset:DNVDS_DEFAULT_OFFSET
                 radius:DNVDS_DEFAULT_RADIUS
                opacity:DNVDS_DEFAULT_OPACITY];
}

- (void)addDropShadow:(UIColor*)color
{
    [self addDropShadow:color
             withOffset:DNVDS_DEFAULT_OFFSET
                 radius:DNVDS_DEFAULT_RADIUS
                opacity:DNVDS_DEFAULT_OPACITY];
}

- (void)addDropShadow:(UIColor*)color
           withOffset:(CGSize)offset
               radius:(CGFloat)radius
              opacity:(CGFloat)opacity
{
    self.layer.shadowColor      = color.CGColor;
    self.layer.shadowOffset     = offset;
    self.layer.shadowRadius     = radius;
    self.layer.shadowOpacity    = (float)opacity;
}

@end
