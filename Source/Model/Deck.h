//
//  Deck.h
//  Grid
//
//  Created by Timothy J. Wood on 11/28/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <Foundation/NSObject.h>

@class Game, Player;

@interface Deck : NSObject

- initWithOwner:(Player *)owner;

@property(nonatomic,readonly,weak) Player *owner;

@property(nonatomic,readonly) NSArray *slots;

- (void)gameTick:(Game *)game;

@end
