//
//  ParticleSystem.h
//  Grid
//
//  Created by Timothy J. Wood on 1/2/13.
//  Copyright (c) 2013 Cocoatoa. All rights reserved.
//

#import <Foundation/NSObject.h>

@class Game;

@interface ParticleSystem : NSObject

@property(nonatomic,readonly) uint16 activeParticles;
@property(nonatomic,readonly) const SCNVector3 *positions;

- (void)gameTick:(Game *)game;

@end
