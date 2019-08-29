//
//  DNCQueue.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//
//  Based on code Created by Dominik Krejčík on 25/09/2011.//
//

#import "DNCQueue.h"

@interface DNCQueue()
{
    NSMutableArray* elements;
}

@end

@implementation DNCQueue

- (id)init
{
    self = [super init];
    if (self)
    {
        elements = NSMutableArray.array;
    }
    
    return self;
}

- (id)dequeue
{
    if (!self.size)
    {
        return nil;
    }
    
    id object = self.peek;
    [elements removeObjectAtIndex:0];
    return object;
}

- (void)enqueue:(id)element
{
    [elements addObject:element];
}

- (void)enqueueElementsFromArray:(NSArray*)arrayOfElements
{
    [elements addObjectsFromArray:arrayOfElements];
}

- (void)enqueueElementsFromQueue:(DNCQueue*)queue
{
    while (!queue.isEmpty)
    {
        [self enqueue:queue.dequeue];
    }
}

- (id)peek
{
    if (!self.size)
    {
        return nil;
    }
    
    return elements.firstObject;
}

- (NSInteger)size
{
    return elements.count;
}

- (BOOL)isEmpty
{
    return (self.size == 0);
}

- (void)clear
{
    [elements removeAllObjects];
}

@end
