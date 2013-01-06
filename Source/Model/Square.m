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

- (void)gameTick:(Game *)game;
{
    [_unit gameTick:game];
}

@end
