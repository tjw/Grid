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
#import "ParticleSystem.h"
#import "Parameters.h"
#import "Player.h"

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
    for (Square *square in _squares) {
        Unit *unit = square.unit;
        if (!unit) {
            // TODO: Decay slowly back to zero?
            continue;
        }

        ParticleSystem *particleSystem = unit.particleSystem;
        if (!particleSystem)
            return;
        
        // TODO: Mapping positions back to squares requires the model to have some notion of how things will be rendered
        SCNVector3 squareCenter = SCNVector3Make((square.column + 0.5) * kSquareSize, (square.row + 0.5) * kSquareSize, 0);
        int32_t influenceAdjustment = unit.owner.influenceAdjustment;
        
        uint16 particleCount = particleSystem.activeParticles;
        const SCNVector3 *positions = particleSystem.positions;
        for (uint16 particleIndex = 0; particleIndex < particleCount; particleIndex++) {
            
            SCNVector3 position = positions[particleIndex];
            position.x += squareCenter.x;
            position.y += squareCenter.y;
            
            Square *overSquare = [self _closestSquareToPosition:position];
            [overSquare accumulateInfluenceAdjustment:influenceAdjustment];
        }
    }

    for (Square *square in _squares)
        [square applyInfluenceAdjustment];

    for (Square *square in _squares)
        [square gameTick:game];
}

- (Square *)_closestSquareToPosition:(SCNVector3)position;
{
    assert(_width > 0);
    assert(_height > 0);
    
    // In world coordinates, the squares are unit-aligned and take up all the space in the board (no gaps between squares) and the squares start at the origin.
    CGRect bounds = CGRectMake(0, 0, _width * kSquareSize, _height * kSquareSize);
    CGPoint point = CGPointMake(position.x, position.y);
    
    if (!CGRectContainsPoint(bounds, point))
        return nil;
    
    CGFloat fColumn = point.x / kSquareSize;
    assert(fColumn >= 0);
    assert(fColumn <= _width);

    CGFloat fRow = point.y / kSquareSize;
    assert(fRow >= 0);
    assert(fRow <= _height);
    
    NSUInteger column = (NSUInteger)fColumn;
    if (column >= _width) {
        assert(0); // can this happen?
        return nil; // On the border?
    }
    NSUInteger row = (NSUInteger)fRow;
    if (row >= _height) {
        assert(0); // can this happen?
        return nil; // On the border?
    }
    
    return [self squareAtColumn:column row:row];
}

@end
