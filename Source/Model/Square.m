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

- (void)gameTick:(Game *)game;
{
    [_unit gameTick:game];
}

@end
