//
//  DeckSlotView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "DeckSlotView.h"

#import "DeckSlotViewDelegate.h"

@implementation DeckSlotView

static CGFloat DeckSlotViewSize = 64;

@synthesize delegate = _weak_delegate;

- (void)setIsDragDestination:(BOOL)isDragDestination;
{
    if (_isDragDestination == isDragDestination)
        return;
    
    _isDragDestination = isDragDestination;
    [self setNeedsDisplay:YES];
}

#pragma mark - NSResponder subclass

- (void)mouseDown:(NSEvent *)theEvent;
{
    id <DeckSlotViewDelegate> delegate = _weak_delegate;
    if (!delegate)
        return;
    if ([delegate respondsToSelector:@selector(deckSlotView:clicked:)])
        [delegate deckSlotView:self clicked:theEvent];
}

#pragma mark - NSView subclass

- (BOOL)wantsUpdateLayer;
{
    return YES;
}

- (CALayer *)makeBackingLayer;
{
    CALayer *layer = [super makeBackingLayer];
    layer.backgroundColor = [[NSColor greenColor] CGColor];
    return layer;
}

- (CGSize)intrinsicContentSize;
{
    return CGSizeMake(DeckSlotViewSize, DeckSlotViewSize);
}

- (void)updateLayer;
{
    CALayer *layer = self.layer;
    layer.backgroundColor = _isDragDestination ? [[NSColor redColor] CGColor] : [[NSColor greenColor] CGColor];
}

@end
