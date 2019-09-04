//
//  DNCRootViewController.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

#import "DNCRootViewController.h"

@implementation DNCRootViewController

- (void)checkBoxPressedWithSender:(UIButton*)sender
{
    [sender setSelected:!sender.selected];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField.tag == -1)
    {
        return NO;
    }
    
    return YES;
}

@end
