//
//  DNCGradientView.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import "DNCGradientView.h"

@implementation DNCGradientView

@dynamic layer;

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

@end
