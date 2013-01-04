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
    if (!(self = [super init]))
        return self;
    
    NSMutableArray *squares = [NSMutableArray new];
    for (NSUInteger squareIndex = 0; squareIndex < DeckSize; squareIndex++) {
        Square *square = [Square new];
        square.unit = [Unit new];
        [squares addObject:square];
    }
    _squares = [squares copy];
    
    return self;
}

- (void)gameTick:(Game *)game;
{
    
}

@end
