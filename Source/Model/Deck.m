//
//  Deck.m
//  Grid
//
//  Created by Timothy J. Wood on 11/28/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "Deck.h"

#import "Square.h"
#import "Unit.h"

static const NSUInteger DeckSize = 5;

@implementation Deck

- init;
{
    assert(0); // Use -initWithOwner;
}

- initWithOwner:(Player *)owner;
{
    assert(owner);
    
    if (!(self = [super init]))
        return self;
    
    _weak_owner = owner;
    
    NSMutableArray *squares = [NSMutableArray new];
    for (NSUInteger squareIndex = 0; squareIndex < DeckSize; squareIndex++) {
        Square *square = [Square new];
        square.unit = [[Unit alloc] initWithOwner:owner];
        [squares addObject:square];
    }
    _squares = [squares copy];
    
    return self;
}

@synthesize owner = _weak_owner;

- (void)gameTick:(Game *)game;
{
    
}

@end
