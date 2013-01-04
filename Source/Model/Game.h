//
//  Game.h
//  Grid
//
//  Created by Timothy J. Wood on 11/25/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <Foundation/NSObject.h>

@class Playfield, Deck;

@interface Game : NSObject

@property(nonatomic,readonly) Playfield *playfield;
@property(nonatomic,readonly) Deck *leftDeck;
@property(nonatomic,readonly) Deck *rightDeck;

- (void)pause;
- (void)unpause;
@property(nonatomic,readonly,getter = isPaused) BOOL paused;

@end
