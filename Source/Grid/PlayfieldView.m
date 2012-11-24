//
//  PlayfieldView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "PlayfieldView.h"

#import "PieceView.h"

// this will get moved into a model layer at some point
static const NSUInteger PiecesPerPlayfieldWidth = 12;
static const NSUInteger PiecesPerPlayfieldHeight = 9;

static const CGFloat EdgeToPiecePadding = 8;

@implementation PlayfieldView
{
    NSArray *_pieceViews;
}

#pragma mark - NSView subclass

- (id)initWithFrame:(NSRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    NSMutableArray *pieceViews = [NSMutableArray new];
    NSMutableArray *contraints = [NSMutableArray new];
    
    for (NSUInteger pieceIndexY = 0; pieceIndexY < PiecesPerPlayfieldHeight; pieceIndexY++) {
        for (NSUInteger pieceIndexX = 0; pieceIndexX < PiecesPerPlayfieldWidth; pieceIndexX++) {
            PieceView *pieceView = [[PieceView alloc] init];
            pieceView.translatesAutoresizingMaskIntoConstraints = NO;
            [pieceViews addObject:pieceView];
            [self addSubview:pieceView];
            
            NSMutableDictionary *views = [NSMutableDictionary dictionaryWithObject:pieceView forKey:@"piece"];
            PieceView *before;
            if (pieceIndexX > 0) {
                before = pieceViews[pieceIndexY * PiecesPerPlayfieldWidth + (pieceIndexX - 1)];
                views[@"before"] = before;
            }
            PieceView *above;
            if (pieceIndexY > 0) {
                above = pieceViews[(pieceIndexY - 1) * PiecesPerPlayfieldWidth + pieceIndexX];
                views[@"above"] = above;
            }

            NSDictionary *metrics = @{@"padding" : @(EdgeToPiecePadding)};
        
            if (before) {
                [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[before]-(padding)-[piece]" options:0 metrics:metrics views:views]];
            } else {
                [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[piece]" options:0 metrics:metrics views:views]];
            }
            
            if (above) {
                [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[above]-(padding)-[piece]" options:0 metrics:metrics views:views]];
            } else {
                [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[piece]" options:0 metrics:metrics views:views]];
            }

            if (pieceIndexX == PiecesPerPlayfieldWidth - 1) {
                [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[piece]-(padding)-|" options:0 metrics:metrics views:views]];
            }
            if (pieceIndexY == PiecesPerPlayfieldHeight - 1) {
                [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[piece]-(padding)-|" options:0 metrics:metrics views:views]];
            }
        }
    }
    _pieceViews = [pieceViews copy];
    
    [self addConstraints:contraints];
    
    return self;
}

- (CALayer *)makeBackingLayer;
{
    CALayer *layer = [super makeBackingLayer];
    layer.backgroundColor = [[NSColor grayColor] CGColor];
    return layer;
}


@end
