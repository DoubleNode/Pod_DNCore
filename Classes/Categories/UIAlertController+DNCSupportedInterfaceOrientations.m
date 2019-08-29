//
//  UIAlertController+DNCSupportedInterfaceOrientations.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

#import "UIAlertController+DNCSupportedInterfaceOrientations.h"

@implementation UIAlertController (DNCSupportedInterfaceOrientations)

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#else

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#endif

@end
