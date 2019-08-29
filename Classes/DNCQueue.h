//
//  DNCQueue.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//
//  Based on code Created by Dominik Krejčík on 25/09/2011.
//

@import Foundation;

@interface DNCQueue : NSObject

// Removes and returns the element at the front of the queue
- (id)dequeue;
// Add the element to the back of the queue
- (void)enqueue:(id)element;
// Remove all elements
- (void)enqueueElementsFromArray:(NSArray*)arr;
- (void)enqueueElementsFromQueue:(DNCQueue*)queue;
- (void)clear;

// Returns the element at the front of the queue
- (id)peek;
// Returns YES if the queue is empty
- (BOOL)isEmpty;
// Returns the size of the queue
- (NSInteger)size;

@end
