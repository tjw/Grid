//
//  Player.m
//  Grid
//
//  Created by Timothy J. Wood on 11/28/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "Player.h"

#import "Deck.h"

@implementation Player

- init;
{
    if (!(self = [super init]))
        return nil;

    _deck = [[Deck alloc] initWithOwner:self];
    
    return self;
}

- (void)gameTick:(Game *)game;
{
    [_deck gameTick:game];
}

@end
