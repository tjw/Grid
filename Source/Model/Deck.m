//
//  Deck.m
//  Grid
//
//  Created by Timothy J. Wood on 11/28/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "Deck.h"

#import "Unit.h"
#import "DeckSlot.h"

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
    
    NSMutableArray *slots = [NSMutableArray new];
    for (NSUInteger slotIndex = 0; slotIndex < DeckSize; slotIndex++) {
        DeckSlot *slot = [DeckSlot new];
        slot.unit = [[Unit alloc] initWithOwner:owner];
        [slots addObject:slot];
    }
    _slots = [slots copy];
    
    return self;
}

@synthesize owner = _weak_owner;

- (void)gameTick:(Game *)game;
{
    
}

@end
