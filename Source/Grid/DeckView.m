//
//  DeckView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "DeckView.h"

#import "PieceView.h"

static const NSUInteger PiecesInDeck = 5;
static const CGFloat EdgeToPiecePadding = 8;

@implementation DeckView
{
    NSArray *_pieceViews;
}

- (id)initWithFrame:(NSRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    NSMutableArray *pieceViews = [NSMutableArray new];
    NSMutableArray *contraints = [NSMutableArray new];
    
    PieceView *previousPieceView;
    for (NSUInteger pieceIndex = 0; pieceIndex < PiecesInDeck; pieceIndex++) {
        PieceView *pieceView = [[PieceView alloc] init];
        pieceView.translatesAutoresizingMaskIntoConstraints = NO;
        [pieceViews addObject:pieceView];
        [self addSubview:pieceView];
        
        NSDictionary *views;
        if (pieceIndex == 0)
            views = @{@"piece": pieceView};
        else
            views = @{@"piece": pieceView, @"previous": previousPieceView};
        
        NSDictionary *metrics = @{@"padding" : @(EdgeToPiecePadding)};
        
        if (pieceIndex == 0)
            [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[piece]" options:0 metrics:metrics views:views]];
        else if (pieceIndex == PiecesInDeck - 1)
            [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[previous]-(padding)-[piece]-(padding)-|" options:0 metrics:metrics views:views]];
        else
            [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[previous]-(padding)-[piece]" options:0 metrics:metrics views:views]];

        [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[piece]-(padding)-|" options:0 metrics:metrics views:views]];

        previousPieceView = pieceView;
    }
    _pieceViews = [pieceViews copy];
    
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
