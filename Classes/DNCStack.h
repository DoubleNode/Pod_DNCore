//
//  DNCStack.h
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//
//  Based on code Created by Dominik Krejčík on 25/09/2011.//
//

@import Foundation;

@interface DNCStack : NSObject<NSFastEnumeration>

// Removes and returns the element at the top of the stack
- (id)pop;
// Adds the element to the top of the stack
- (void)push:(id)element;
// Removes all elements
- (void)pushElementsFromArray:(NSArray*)arr;
- (void)clear;

// Returns the object at the top of the stack
- (id)peek;
// Returns the size of the stack
- (NSInteger)size;
// Returns YES if the stack is empty
- (BOOL)isEmpty;

@end
