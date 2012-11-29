//
//  DeckView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "DeckView.h"

#import "SquareView.h"

static const CGFloat EdgeToPiecePadding = 8;

@interface DeckView ()
@property(nonatomic,readonly) NSArray *squareViews;
@property(nonatomic,readonly) NSArray *squareViewConstraints;
@end

@implementation DeckView

- (NSUInteger)squareCount;
{
    return [_squareViews count];
}

- (void)setSquareCount:(NSUInteger)squareCount;
{
    if ([_squareViews count] == squareCount)
        return;
        
    if (_squareViewConstraints) {
        [self removeConstraints:_squareViewConstraints];
        _squareViewConstraints = nil;
    }
    
    NSMutableArray *squareViews = [NSMutableArray new];
    for (NSUInteger squareIndex = 0; squareIndex < squareCount; squareIndex++) {
        SquareView *square = [SquareView new];
        square.translatesAutoresizingMaskIntoConstraints = NO;
        [square setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
        [square setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
        
        [self addSubview:square];
        [squareViews addObject:square];
    }
    
    _squareViews = [squareViews copy];
    
    [self setNeedsUpdateConstraints:YES];
}

- (void)setImage:(NSImage *)image forSquareAtIndex:(NSUInteger)squareIndex;
{
    
}

#pragma mark - NSView subclass

- (CALayer *)makeBackingLayer;
{
    CALayer *layer = [super makeBackingLayer];
    layer.backgroundColor = [[NSColor blueColor] CGColor];
    return layer;
}

- (void)updateConstraints;
{
    NSDictionary *metrics = @{@"padding" : @(EdgeToPiecePadding)};

    SquareView *previousSquareView;
    for (SquareView *squareView in _squareViews) {
        NSDictionary *views;
        if (previousSquareView == nil)
            views = @{@"square": squareView};
        else
            views = @{@"square": squareView, @"previous": previousSquareView};
        
        
        if (previousSquareView == nil)
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[square]" options:0 metrics:metrics views:views]];
        else
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[previous]-(padding)-[square]" options:0 metrics:metrics views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[square]-(padding)-|" options:0 metrics:metrics views:views]];
        
        previousSquareView = squareView;
    }
    
    if (previousSquareView)
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[previousSquareView]-(padding)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(previousSquareView)]];
}

@end
