//
//  Playfield.m
//  Grid
//
//  Created by Timothy J. Wood on 11/25/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "Playfield.h"

#import "Square.h"

@implementation Playfield
{
    NSMutableArray *_squares;
}

- init;
{
    if (!(self = [super init]))
        return nil;
    
    _width = 14;
    _height = 9;
    
    _squares = [[NSMutableArray alloc] init];
    for (NSUInteger squareIndex = 0; squareIndex < _width * _height; squareIndex++)
        [_squares addObject:[Square new]];
         
    return self;
}

@end
