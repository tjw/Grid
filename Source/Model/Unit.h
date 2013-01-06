//
//  Unit.h
//  Grid
//
//  Created by Timothy J. Wood on 11/28/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <Foundation/NSObject.h>

@class Game, Player, ParticleSystem;

@interface Unit : NSObject

- initWithOwner:(Player *)owner;

@property(nonatomic,readonly,weak) Player *owner;

@property(nonatomic,readonly) NSString *imageName;
@property(nonatomic,readonly) ParticleSystem *particleSystem;

- (void)willAddToPlayfield;
- (void)gameTick:(Game *)game;

@end
