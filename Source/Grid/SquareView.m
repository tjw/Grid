//
//  SquareView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "SquareView.h"

#import "SquareViewDelegate.h"

@implementation SquareView

static CGFloat SquareViewSize = 64;

@synthesize delegate = _weak_delegate;

#pragma mark - NSResponder subclass

- (void)mouseDown:(NSEvent *)theEvent;
{
    id <SquareViewDelegate> delegate = _weak_delegate;
    if (!delegate)
        return;
    if ([delegate respondsToSelector:@selector(squareView:clicked:)])
        [delegate squareView:self clicked:theEvent];
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
    return CGSizeMake(SquareViewSize, SquareViewSize);
}

@end
