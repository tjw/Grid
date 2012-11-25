//
//  Playfield.m
//  Grid
//
//  Created by Timothy J. Wood on 11/25/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "Playfield.h"

@implementation Playfield

- init;
{
    if (!(self = [super init]))
        return nil;
    
    _width = 14;
    _height = 9;
    
    return self;
}

@end
