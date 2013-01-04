//
//  Unit.m
//  Grid
//
//  Created by Timothy J. Wood on 11/28/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "Unit.h"

@implementation Unit

- (NSString *)imageName;
{
    return @"Emitter";
}

- (void)gameTick:(Game *)game;
{
    NSLog(@"Unit tick %@", self);
}

@end
