//
//  Playfield.m
//  Grid
//
//  Created by Timothy J. Wood on 11/25/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "Playfield.h"

#import "Square.h"
#import "Unit.h"

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

- (Unit *)unitAtColumn:(NSUInteger)column row:(NSUInteger)row;
{
    Square *square = [self _squareAtColumn:column row:row];
    return square.unit;
}

- (void)setUnit:(Unit *)unit atColumn:(NSUInteger)column row:(NSUInteger)row;
{
    Square *square = [self _squareAtColumn:column row:row];
    square.unit = unit;
}

- (void)addUnitObserver:(id)observer atColumn:(NSUInteger)column row:(NSUInteger)row context:(void *)context;
{
    Square *square = [self _squareAtColumn:column row:row];
    [square addObserver:observer forKeyPath:KeyPath(square, unit) options:0 context:context];
}

- (void)removeUnitObserver:(id)observer atColumn:(NSUInteger)column row:(NSUInteger)row context:(void *)context;
{
    Square *square = [self _squareAtColumn:column row:row];
    [square removeObserver:observer forKeyPath:KeyPath(square, unit) context:context];
}

#pragma mark - Private

- (Square *)_squareAtColumn:(NSUInteger)column row:(NSUInteger)row;
{
    assert(column < _width);
    assert(row < _height);
    
    NSUInteger idx = row * _width + column;
    return _squares[idx];
}

@end
