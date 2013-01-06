//
//  DeckView.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "DeckView.h"

#import "DeckSlotView.h"
#import "DeckSlotViewDelegate.h"
#import "DeckViewDelegate.h"

static const CGFloat EdgeToPiecePadding = 8;

@interface DeckView () <DeckSlotViewDelegate>
@property(nonatomic,readonly) NSArray *deckSlotViews;
@property(nonatomic,readonly) NSArray *deckSlotViewConstraints;
@end

@implementation DeckView

@synthesize delegate = _weak_delegate;

- (NSUInteger)deckSlotCount;
{
    return [_deckSlotViews count];
}

- (void)setDeckSlotCount:(NSUInteger)deckSlotCount;
{
    if ([_deckSlotViews count] == deckSlotCount)
        return;
        
    if (_deckSlotViewConstraints) {
        [self removeConstraints:_deckSlotViewConstraints];
        _deckSlotViewConstraints = nil;
    }
    
    NSMutableArray *deckSlotViews = [NSMutableArray new];
    for (NSUInteger deckSlotIndex = 0; deckSlotIndex < deckSlotCount; deckSlotIndex++) {
        DeckSlotView *slot = [DeckSlotView new];
        slot.translatesAutoresizingMaskIntoConstraints = NO;
        [slot setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
        [slot setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
        
        slot.delegate = self;
        
        [self addSubview:slot];
        [deckSlotViews addObject:slot];
    }
    
    _deckSlotViews = [deckSlotViews copy];
    
    [self setNeedsUpdateConstraints:YES];
}

- (void)setImage:(NSImage *)image forDeckSlotAtIndex:(NSUInteger)deckSlotIndex;
{
    assert(_deckSlotViews);
    
    // TODO: Bad, accessing its layer.
    DeckSlotView *deckSlotView = _deckSlotViews[deckSlotIndex];
    deckSlotView.wantsLayer = YES; // otherwise we don't get our layer until later
    deckSlotView.layer.contents = image;
}

- (NSUInteger)indexOfDeckSlotView:(DeckSlotView *)deckSlotView;
{
    assert(_deckSlotViews);

    return [_deckSlotViews indexOfObject:deckSlotView];
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

    DeckSlotView *previousDeckSlotView;
    for (DeckSlotView *deckSlotView in _deckSlotViews) {
        NSDictionary *views;
        if (previousDeckSlotView == nil)
            views = @{@"slot": deckSlotView};
        else
            views = @{@"slot": deckSlotView, @"previous": previousDeckSlotView};
        
        
        if (previousDeckSlotView == nil)
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[slot]" options:0 metrics:metrics views:views]];
        else
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[previous]-(padding)-[slot]" options:0 metrics:metrics views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding)-[slot]-(padding)-|" options:0 metrics:metrics views:views]];
        
        previousDeckSlotView = deckSlotView;
    }
    
    if (previousDeckSlotView)
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[previousDeckSlotView]-(padding)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(previousDeckSlotView)]];
}

#pragma mark - DeckSlotViewDelegate

- (void)deckSlotView:(DeckSlotView *)_deckSlotView clicked:(NSEvent *)mouseDown;
{
    id <DeckViewDelegate> delegate = _weak_delegate;
    
    [delegate deckView:self deckSlotView:_deckSlotView clicked:mouseDown];
}

@end
