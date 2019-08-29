//
//  DNCNavigationController.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

#import "DNCNavigationController.h"

@interface DNCNavigationController ()

@end

@implementation DNCNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate
{
    return self.visibleViewController.shouldAutorotate;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.visibleViewController.preferredInterfaceOrientationForPresentation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.visibleViewController.supportedInterfaceOrientations;
}

@end
