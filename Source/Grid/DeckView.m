//
//  DeckView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "DeckView.h"

#import "SquareView.h"
#import "SquareViewDelegate.h"
#import "DeckViewDelegate.h"

static const CGFloat EdgeToPiecePadding = 8;

@interface DeckView () <SquareViewDelegate>
@property(nonatomic,readonly) NSArray *squareViews;
@property(nonatomic,readonly) NSArray *squareViewConstraints;
@end

@implementation DeckView

@synthesize delegate = _weak_delegate;

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
        
        square.delegate = self;
        
        [self addSubview:square];
        [squareViews addObject:square];
    }
    
    _squareViews = [squareViews copy];
    
    [self setNeedsUpdateConstraints:YES];
}

- (void)setImage:(NSImage *)image forSquareAtIndex:(NSUInteger)squareIndex;
{
    // TODO: Bad, accessing its layer.
    SquareView *squareView = _squareViews[squareIndex];
    squareView.wantsLayer = YES; // otherwise we don't get our layer until later
    squareView.layer.contents = image;
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
    [super updateConstraints];
    
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

#pragma mark - SquareViewDelegate

- (void)squareView:(SquareView *)_squareView clicked:(NSEvent *)mouseDown;
{
    id <DeckViewDelegate> delegate = _weak_delegate;
    
    [delegate deckView:self squareView:_squareView clicked:mouseDown];
}

@end
