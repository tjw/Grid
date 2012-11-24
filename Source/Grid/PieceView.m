//
//  PieceView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "PieceView.h"

#import "PieceViewDelegate.h"

@implementation PieceView

static CGFloat PieceViewSize = 64;

@synthesize delegate = _weak_delegate;

#pragma mark - NSResponder subclass

- (void)mouseDown:(NSEvent *)theEvent;
{
    id <PieceViewDelegate> delegate = _weak_delegate;
    if (!delegate)
        return;
    if ([delegate respondsToSelector:@selector(pieceView:clicked:)])
        [delegate pieceView:self clicked:theEvent];
}

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
