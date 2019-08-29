//
//  DNCRootViewController.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

@import UIKit;

@interface DNCRootViewController : UIViewController<UITextFieldDelegate>

- (void)checkBoxPressed:(UIButton*)sender;

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField;

@end
