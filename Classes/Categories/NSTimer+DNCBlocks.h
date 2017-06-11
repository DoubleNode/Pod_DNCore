//
//  NSTimer+DNCBlocks.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (DNCBlocks)

/**
 *  Creates and returns a new NSTimer object and schedules it on the current run loop in the default mode.
 *
 *  @param inTimeInterval The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead.
 *  @param inBlock        The block to run when the timer fires. The timer maintains a strong reference to target until it (the timer) is invalidated.
 *  @param inRepeats      If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
 *
 *  @return A new NSTimer object, configured according to the specified parameters.
 */
+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock repeats:(BOOL)inRepeats;

/**
 *  Creates and returns a new NSTimer object initialized with the specified object and selector.
 *
 *  @param inTimeInterval The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead.
 *  @param inBlock        The block to run when the timer fires. The timer maintains a strong reference to target until it (the timer) is invalidated.
 *  @param inRepeats      If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
 *
 *  @return A new NSTimer object, configured according to the specified parameters.
 */
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock repeats:(BOOL)inRepeats;

@end
