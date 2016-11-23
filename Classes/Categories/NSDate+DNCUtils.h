//
//  NSDate+DNCUtils.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DNCUtils)

- (NSDate*)dncToLocalTime;
- (NSDate*)dncToGlobalTime;

@end
