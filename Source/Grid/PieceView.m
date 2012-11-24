//
//  PieceView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "PieceView.h"

@implementation PieceView

static CGFloat PieceViewSize = 64;

#pragma mark - NSView subclass

- (CALayer *)makeBackingLayer;
{
    CALayer *layer = [super makeBackingLayer];
    layer.backgroundColor = [[NSColor greenColor] CGColor];
    return layer;
}

- (CGSize)intrinsicContentSize;
{
    return CGSizeMake(PieceViewSize, PieceViewSize);
}

@end
