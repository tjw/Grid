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
//    NSLog(@"Unit tick %@", self);
}

@end
