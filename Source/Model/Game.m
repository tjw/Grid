//
//  Game.m
//  Grid
//
//  Created by Timothy J. Wood on 11/25/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "Game.h"

#import "Playfield.h"
#import "Deck.h"

@implementation Game

- init;
{
    if (!(self = [super init]))
        return nil;
    
    _playfield = [[Playfield alloc] init];
    _leftDeck = [[Deck alloc] init];
    _rightDeck = [[Deck alloc] init];
    
    return self;
}

@end
