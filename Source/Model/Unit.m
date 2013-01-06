//
//  Unit.m
//  Grid
//
//  Created by Timothy J. Wood on 11/28/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "Unit.h"

#import "ParticleSystem.h"

@implementation Unit

- init;
{
    assert(0); // Use -initWithOwner:
}

- initWithOwner:(Player *)owner;
{
    assert(owner);
    
    if (!(self = [super init]))
        return nil;
    
    _weak_owner = owner;
    
    return self;
}

@synthesize owner = _weak_owner;

- (NSString *)imageName;
{
    return @"Emitter";
}

- (void)willAddToPlayfield;
{
    _particleSystem = [[ParticleSystem alloc] init];
}

- (void)gameTick:(Game *)game;
{
    [_particleSystem gameTick:game];
}

@end
