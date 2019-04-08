//
//  UIColor+DNCAlpha.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//
//  Based on code Created by Borbás Geri on 11/25/13.
//  Copyright (c) 2013 eppz! development, LLC.
//
//  donate! by following http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "UIColor+DNCAlpha.h"

@implementation UIColor(DNCAlpha)

- (CGFloat)red
{
    return CGColorGetComponents(self.CGColor)[UIColorDNCAlphaComponentIndicesR];
}

- (CGFloat)green
{
    return CGColorGetComponents(self.CGColor)[UIColorDNCAlphaComponentIndicesG];
}

- (CGFloat)blue
{
    return CGColorGetComponents(self.CGColor)[UIColorDNCAlphaComponentIndicesB];
}

- (CGFloat)alpha
{
    return CGColorGetComponents(self.CGColor)[UIColorDNCAlphaComponentIndicesA];
}

- (UIColor*)colorWithAlpha:(CGFloat)alpha
{
    const CGFloat*  components = CGColorGetComponents(self.CGColor);
    
    CGFloat redComponent, greenComponent, blueComponent, alphaComponent;
    redComponent    = components[UIColorDNCAlphaComponentIndicesR];
    greenComponent  = components[UIColorDNCAlphaComponentIndicesG];
    blueComponent   = components[UIColorDNCAlphaComponentIndicesB];
    alphaComponent  = components[UIColorDNCAlphaComponentIndicesA];
    
    return [UIColor colorWithRed:redComponent
                           green:greenComponent
                            blue:blueComponent
                           alpha:alpha];
}

- (UIColor*)blendWithColor:(UIColor*)color
                    amount:(CGFloat)amount
{
    const CGFloat*  components = CGColorGetComponents(self.CGColor);
    
    CGFloat redComponent, greenComponent, blueComponent, alphaComponent;
    redComponent    = components[UIColorDNCAlphaComponentIndicesR];
    greenComponent  = components[UIColorDNCAlphaComponentIndicesG];
    blueComponent   = components[UIColorDNCAlphaComponentIndicesB];
    alphaComponent  = components[UIColorDNCAlphaComponentIndicesA];
    
    const CGFloat*  blendComponents = CGColorGetComponents(color.CGColor);
    
    CGFloat redBlendComponent, greenBlendComponent, blueBlendComponent, alphaBlendComponent;
    redBlendComponent   = blendComponents[UIColorDNCAlphaComponentIndicesR];
    greenBlendComponent = blendComponents[UIColorDNCAlphaComponentIndicesG];
    blueBlendComponent  = blendComponents[UIColorDNCAlphaComponentIndicesB];
    alphaBlendComponent = blendComponents[UIColorDNCAlphaComponentIndicesA];

    CGFloat finalAmount         = (fabsf((float)amount) > 1.0f) ? 1.0f : fabsf((float)amount); // Clamp to 0.0 - 1.0
    CGFloat finalBlendAmount    = 1.0f - finalAmount;
    
    return [UIColor colorWithRed:(redComponent   * finalAmount) + (redBlendComponent   * finalBlendAmount)
                           green:(greenComponent * finalAmount) + (greenBlendComponent * finalBlendAmount)
                            blue:(blueComponent  * finalAmount) + (blueBlendComponent  * finalBlendAmount)
                           alpha:(alphaComponent * finalAmount) + (alphaBlendComponent * finalBlendAmount)];
}

@end
