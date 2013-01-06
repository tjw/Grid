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
    
    for (NSUInteger rowIndex = 0; rowIndex < _height; rowIndex++) {
        for (NSUInteger columnIndex = 0; columnIndex < _width; columnIndex++) {
            Square *square = [[Square alloc] initWithColumn:columnIndex row:rowIndex];
            [_squares addObject:square];
            assert([self squareAtColumn:columnIndex row:rowIndex] == square);
        }
    }
    
    return self;
}

- (Square *)squareAtColumn:(NSUInteger)column row:(NSUInteger)row;
{
    assert(column < _width);
    assert(row < _height);
    
    NSUInteger idx = row * _width + column;
    Square *square = _squares[idx];
    
    assert(square.column == column);
    assert(square.row == row);
    
    return square;
}

- (Unit *)unitAtColumn:(NSUInteger)column row:(NSUInteger)row;
{
    Square *square = [self squareAtColumn:column row:row];
    return square.unit;
}

- (void)setUnit:(Unit *)unit atColumn:(NSUInteger)column row:(NSUInteger)row;
{
    Square *square = [self squareAtColumn:column row:row];

    // TODO: Add some way to make sure units are only in one square at a time?
    [unit willAddToPlayfield];
    
    square.unit = unit;
}

- (void)gameTick:(Game *)game;
{
    for (Square *square in _squares)
        [square gameTick:game];
}

@end
