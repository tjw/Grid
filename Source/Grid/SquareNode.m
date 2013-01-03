//
//  SquareNode.m
//  Grid
//
//  Created by Timothy J. Wood on 1/3/13.
//  Copyright (c) 2013 Cocoatoa. All rights reserved.
//

#import "SquareNode.h"

@implementation SquareNode

- init;
{
    if (!(self = [super init]))
        return nil;
    
    _column = NSNotFound;
    _row = NSNotFound;
    
    return self;
}

@end
