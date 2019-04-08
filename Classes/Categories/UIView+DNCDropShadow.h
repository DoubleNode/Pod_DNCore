//
//  UIView+DNCDropShadow.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DNCDropShadow)

- (void)addDropShadow;

- (void)addDropShadow:(UIColor*)color;

- (void)addDropShadow:(UIColor*)color
           withOffset:(CGSize)offset
               radius:(CGFloat)radius
              opacity:(CGFloat)opacity;

@end
