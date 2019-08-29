//
//  DNCStack.m
//  DoubleNode Core
//
//  Created by Darren Ehlers on 2016/10/16.
//  Copyright © 2016 Darren Ehlers and DoubleNode, LLC.
//
//  DNCore is released under the MIT license. See LICENSE for details.
//
//  Based on code Created by Dominik Krejčík on 25/09/2011.//
//

#import "DNCStack.h"

@interface DNCStack()
{
    NSMutableArray* elements;
}

@end

@implementation DNCStack

- (id)init
{
    self = [super init];
    if (self)
    {
        elements = NSMutableArray.array;
    }
    
    return self;
}

- (id)pop
{
    id  object = self.peek;
    
    [elements removeLastObject];
    return object;
}

- (void)push:(id)element
{
    [elements addObject:element];
}

-(void)pushElementsFromArray:(NSArray*)arrayOfElements
{
    [elements addObjectsFromArray:arrayOfElements];
}

- (id)peek
{
    return elements.lastObject;
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

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state
                                  objects:(id __unsafe_unretained [])buffer
                                    count:(NSUInteger)len
{
    return [elements countByEnumeratingWithState:state
                                         objects:buffer
                                           count:len];
}

@end
