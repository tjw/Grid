//
//  Square.m
//  Grid
//
//  Created by Timothy J. Wood on 11/28/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "Square.h"

#import "Unit.h"

@implementation Square
{
    int64_t _influenceAdjustmentAccumulator;
}

- init;
{
    assert(0); // Use -initWithColumn:row:
}

- initWithColumn:(NSUInteger)column row:(NSUInteger)row;
{
    if (!(self = [super init]))
        return nil;
    
    _column = column;
    _row = row;
    
    return self;
}

- (void)accumulateInfluenceAdjustment:(Influence)influenceAdjustment;
{
    // Total up all the adjustment for each tick and then clamp once at the end of the tick.
    _influenceAdjustmentAccumulator += influenceAdjustment;
}

- (void)applyInfluenceAdjustment;
{
    int64_t influence = (int64_t)_influence + _influenceAdjustmentAccumulator;
    
    if (influence < InfluenceMin)
        influence = InfluenceMin;
    if (influence > InfluenceMax)
        influence = InfluenceMax;
    
    _influence = (Influence)influence;
    _influenceAdjustmentAccumulator = 0;
}

- (void)gameTick:(Game *)game;
{
    [_unit gameTick:game];
}

@end
