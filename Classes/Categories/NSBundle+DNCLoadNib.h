//
//  NSBundle+DNCLoadNib.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2019/08/07.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

@import Foundation;

@interface NSBundle (DNCLoadNib)

- (id)dncLoadNibForClass:(Class)itemClass;

@end
