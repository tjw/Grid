//
//  DeckView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "DeckView.h"

#import "SquareView.h"

static const NSUInteger PiecesInDeck = 5;
static const CGFloat EdgeToPiecePadding = 8;

@implementation DeckView

- (id)initWithFrame:(NSRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    NSMutableArray *squareViews = [NSMutableArray new];
    NSMutableArray *contraints = [NSMutableArray new];
    
    SquareView *previousSquareView;
    for (NSUInteger pieceIndex = 0; pieceIndex < PiecesInDeck; pieceIndex++) {
        SquareView *squareView = [[SquareView alloc] init];
        squareView.translatesAutoresizingMaskIntoConstraints = NO;
        [squareView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
        [squareView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
        [squareViews addObject:squareView];
        [self addSubview:squareView];
        
        NSDictionary *views;
        if (pieceIndex == 0)
            views = @{@"square": squareView};
        else
            views = @{@"square": squareView, @"previous": previousSquareView};
        
        NSDictionary *metrics = @{@"padding" : @(EdgeToPiecePadding)};
        
        if (pieceIndex == 0)
            [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[square]" options:0 metrics:metrics views:views]];
        else if (pieceIndex == PiecesInDeck - 1)
            [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[previous]-(padding)-[square]-(padding)-|" options:0 metrics:metrics views:views]];
        else
            [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[previous]-(padding)-[square]" options:0 metrics:metrics views:views]];

        [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[square]-(padding)-|" options:0 metrics:metrics views:views]];

        previousSquareView = squareView;
    }
    _squareViews = [squareViews copy];
    
    [self addConstraints:contraints];
    
    return self;
}

#pragma mark - NSView subclass

- (CALayer *)makeBackingLayer;
{
    CALayer *layer = [super makeBackingLayer];
    layer.backgroundColor = [[NSColor blueColor] CGColor];
    return layer;
}

@end
