//
//  PlayfieldView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "PlayfieldView.h"

@implementation PlayfieldView

#pragma mark - NSView subclass

- (CALayer *)makeBackingLayer;
{
    CALayer *layer = [super makeBackingLayer];
    layer.backgroundColor = [[NSColor grayColor] CGColor];
    return layer;
}


@end
