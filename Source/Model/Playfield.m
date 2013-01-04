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

    // TODO: Add some way to make sure units are only in one square at a time?
    [unit willAddToPlayfield];
    
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

- (Unit *)unitForObservedObject:(id)observed column:(out NSUInteger *)outColumn row:(out NSUInteger *)outRow;
{
    Square *square = observed;
    assert([square isKindOfClass:[Square class]]);
    assert([_squares indexOfObject:observed] != NSNotFound);
    
    [self _getColumn:outColumn row:outRow forSquare:square];
    return square.unit;
}

- (void)gameTick:(Game *)game;
{
    for (Square *square in _squares)
        [square gameTick:game];
}

#pragma mark - Private

- (Square *)_squareAtColumn:(NSUInteger)column row:(NSUInteger)row;
{
    assert(column < _width);
    assert(row < _height);
    
    NSUInteger idx = row * _width + column;
    return _squares[idx];
}

- (void)_getColumn:(out NSUInteger *)outColumn row:(out NSUInteger *)outRow forSquare:(Square *)square;
{
    assert(_width > 0);
    assert(_height > 0);
    
    NSUInteger idx = [_squares indexOfObject:square];
    assert(idx != NSNotFound);
    
    *outColumn = idx % _width;
    *outRow = idx / _width;
}

@end
