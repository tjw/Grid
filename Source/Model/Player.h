//
//  Player.h
//  Grid
//
//  Created by Timothy J. Wood on 11/28/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <Foundation/NSObject.h>
#import "Influence.h"

@class Deck, Game;

@interface Player : NSObject

@property(nonatomic,readonly) Deck *deck;
@property(nonatomic) Influence influenceAdjustment;

- (void)gameTick:(Game *)game;

@end
