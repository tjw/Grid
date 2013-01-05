//
//  ParticleSystem.m
//  Grid
//
//  Created by Timothy J. Wood on 1/2/13.
//  Copyright (c) 2013 Cocoatoa. All rights reserved.
//

#import "ParticleSystem.h"

#import "Parameters.h"

@implementation ParticleSystem
{
    uint16 _activeParticles;
    uint16 _maximumParticles;
    SCNVector3 *_positions;
    SCNVector3 *_velocities;
}

- init;
{
    if (!(self = [super init]))
        return nil;
    
    _maximumParticles = 128;
    _positions = malloc(_maximumParticles * sizeof(*_positions));
    _velocities = malloc(_maximumParticles * sizeof(*_velocities));
    
    return self;
}

- (void)dealloc;
{
    free(_positions);
    free(_velocities);
}

- (void)gameTick:(Game *)game;
{
    // Start or restart one particle
    {
        uint16 particleIndex;
        
        if (_activeParticles < _maximumParticles) {
            // Still filling up, use the next particle
            particleIndex = _activeParticles;
            _activeParticles++;
        } else {
            // Already full, reuse a random particle
            particleIndex = arc4random_uniform(_maximumParticles);
        }

        CGFloat radius = (kParticleMaximumDistancePerSecond/kGameTicksPerSecond) * (arc4random_uniform(10000) / 10000.0);
        CGFloat angle = (arc4random_uniform(10000) / 10000.0) * (2*M_PI);
        
        CGFloat x = radius * cos(angle);
        CGFloat y = radius * sin(angle);
        
        _positions[particleIndex] = SCNVector3Make(0, 0, 2);
        _velocities[particleIndex] = SCNVector3Make(x, y, 0);
    }

    // Update positions for each particle.
    for (uint16 particleIndex = 0; particleIndex < _activeParticles; particleIndex++) {
        SCNVector3 p = _positions[particleIndex];
        SCNVector3 v = _velocities[particleIndex];
        
        _positions[particleIndex] = SCNVector3Make(p.x + v.x, p.y + v.y, p.z + v.z);
    }
}

@end
