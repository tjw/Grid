//
//  PlayfieldView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "PlayfieldView.h"

#import "SquareView.h"

static const CGFloat EdgeToPiecePadding = 8;

@implementation PlayfieldView
{
    NSArray *_constraints;
    NSArray *_squareViews;
}

#pragma mark - API

- (void)resizeToWidth:(NSUInteger)width height:(NSUInteger)height;
{
    if (_width == width && _height == height)
        return;
    
    _width = width;
    _height = height;
    
    if (_constraints) {
        [self removeConstraints:_constraints];
        _constraints = nil;
    }

    NSMutableArray *squareViews = [NSMutableArray new];
    NSMutableArray *contraints = [NSMutableArray new];
    
    if (_constraints) {
        [self removeConstraints:_constraints];
        _constraints = nil;
    }
    
    for (NSUInteger pieceIndexY = 0; pieceIndexY < _height; pieceIndexY++) {
        for (NSUInteger pieceIndexX = 0; pieceIndexX < _width; pieceIndexX++) {
            SquareView *squareView = [[SquareView alloc] init];
            squareView.translatesAutoresizingMaskIntoConstraints = NO;
            [squareView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
            [squareView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
            
            [squareViews addObject:squareView];
            [self addSubview:squareView];
            
            NSMutableDictionary *views = [NSMutableDictionary dictionaryWithObject:squareView forKey:@"piece"];
            SquareView *before;
            if (pieceIndexX > 0) {
                before = squareViews[pieceIndexY * _width + (pieceIndexX - 1)];
                views[@"before"] = before;
            }
            SquareView *above;
            if (pieceIndexY > 0) {
                above = squareViews[(pieceIndexY - 1) * _width + pieceIndexX];
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
            
            if (pieceIndexX == _width - 1) {
                [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[piece]-(padding)-|" options:0 metrics:metrics views:views]];
            }
            if (pieceIndexY == _height - 1) {
                [contraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[piece]-(padding)-|" options:0 metrics:metrics views:views]];
            }
        }
    }
    _squareViews = [squareViews copy];
    
    [self addConstraints:contraints];
}

- (SquareView *)squareViewAtColumn:(NSUInteger)column row:(NSUInteger)row;
{
    assert(column < _width);
    assert(row < _height);
    
    NSUInteger viewIndex = row * _width + column;
    return _squareViews[viewIndex];
}

- (void)getColumn:(out NSUInteger *)outColumn row:(out NSUInteger *)outRow ofSquareView:(SquareView *)squareView;
{
    NSUInteger viewIndex = [_squareViews indexOfObject:squareView];
    if (viewIndex == NSNotFound) {
        assert(0); // shouldn't be asking
        *outRow = NSNotFound;
        *outColumn = NSNotFound;
        return;
    }

    *outColumn = viewIndex % _width;
    *outRow = viewIndex / _width;
}

// Takes a point in the receivers coordinate system (unlike -hitTest:).
- (SquareView *)squareViewAtPoint:(NSPoint)point;
{
    assert(self.superview);
    NSView *view = [self hitTest:[self convertPoint:point toView:self.superview]];
    
    while (view && view != self) {
        if ([view isKindOfClass:[SquareView class]])
            return (SquareView *)view;
        view = view.superview;
    }
    return nil;
}

// Takes a point in the receivers coordinate system (unlike -hitTest:).
- (SquareView *)squareViewNearestPoint:(NSPoint)point;
{
    SquareView *bestView;
    CGFloat bestDistanceSquared = CGFLOAT_MAX;

    // Maybe put this in the callers.
    if (!CGRectContainsPoint(self.bounds, point))
        return nil;
    
    for (SquareView *candidateView in _squareViews) {
        CGRect bounds = candidateView.frame;
        if (CGRectContainsPoint(bounds, point))
            return candidateView; // We assume non-overlapping candidates, so it isn't going to get better than this.
        
        CGPoint center = CGPointMake(NSMidX(bounds), NSMidY(bounds));
        CGSize offset = CGSizeMake(point.x - center.x, point.y - center.y);
        CGFloat distanceSquared = offset.width * offset.width + offset.height * offset.height;
        
        if (distanceSquared < bestDistanceSquared) {
            bestDistanceSquared = distanceSquared;
            bestView = candidateView;
        }
    }
    
    return bestView;
}

#pragma mark - NSView subclass

- (CALayer *)makeBackingLayer;
{
    CALayer *layer = [super makeBackingLayer];
    layer.backgroundColor = [[NSColor grayColor] CGColor];
    return layer;
}


@end
