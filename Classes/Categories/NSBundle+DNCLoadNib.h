//
//  NSBundle+DNCLoadNib.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//

@import Foundation;

@interface NSBundle (DNCLoadNib)

+ (id)dncLoadNibForClass:(Class)itemClass;

@end
