//
//  ParticleSystem.m
//  Grid
//
//  Created by Timothy J. Wood on 1/2/13.
//  Copyright (c) 2013 Cocoatoa. All rights reserved.
//

#import "ParticleSystem.h"

@implementation ParticleSystem
{
    uint16 _count;
    SCNVector3 *_points;
}

- init;
{
    if (!(self = [super init]))
        return nil;
    
    _count = 100;
    _points = malloc(_count * sizeof(*_points));
    
    // TODO: Bring over OFRandom
    for (NSUInteger pointIndex = 0; pointIndex < _count; pointIndex++) {
        CGFloat radius = arc4random_uniform(10000) / 1000.0;
        CGFloat angle = arc4random_uniform(10000) / 10000.0 * (2*M_PI);
        
        CGFloat x = radius * cos(angle);
        CGFloat y = radius * sin(angle);
        CGFloat z = 10;
        
        _points[pointIndex] = SCNVector3Make(x, y, z);
    }
    
    return self;
}

- (void)dealloc;
{
    if (_points)
        free(_points);
}

@end
