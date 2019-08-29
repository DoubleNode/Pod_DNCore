//
//  DNCGradientView.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

#import "DNCGradientView.h"

@implementation DNCGradientView

@dynamic layer;

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

@end
