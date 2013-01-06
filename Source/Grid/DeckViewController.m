//
//  DeckViewController.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "DeckViewController.h"

#import "DeckView.h"
#import "SquareView.h"
#import "DeckViewDelegate.h"
#import "Deck.h"
#import "PlayfieldNodeController.h"
#import "DeckSlot.h"

@interface NSView ()
- (NSString *)_subtreeDescription;
@end

@interface DeckViewController () <DeckViewDelegate>

@end

@implementation DeckViewController

@synthesize playfieldController = _weak_playfieldController;

static unsigned UnitContext;

- (void)setDeck:(Deck *)deck;
{
    if (_deck == deck)
        return;
    
    for (DeckSlot *slot in _deck.slots)
        [slot removeObserver:self forKeyPath:KeyPath(slot, unit) context:&UnitContext];
    
    _deck = deck;
    
    for (DeckSlot *slot in _deck.slots)
        [slot addObserver:self forKeyPath:KeyPath(slot, unit) options:0 context:&UnitContext];

    if (self.viewLoaded)
        [self _setupView];
}

- (Unit *)unitForSquareView:(SquareView *)squareView;
{
    DeckView *deckView = (DeckView *)self.view;
    NSUInteger slotIndex = [deckView indexOfSquareView:squareView];
    if (slotIndex == NSNotFound) {
        assert(0); // shouldn't be asking
        return nil;
    }
    
    if (slotIndex >= [_deck.slots count]) {
        assert(0); // shouldn't be asking
        return nil;
    }
    
    DeckSlot *slot = _deck.slots[slotIndex];
    Unit *unit = slot.unit;
    
    assert(unit);
    return unit;
}

#pragma mark - NSObject (NSNibAwaking)

// We expect our view is setup in xib, so we don't have a -loadView
- (void)awakeFromNib;
{
    [super awakeFromNib];

    DeckView *view = (DeckView *)self.view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.nextResponder = self;
    
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
    
    view.delegate = self;
    
    if (_deck)
        [self _setupView];
}

#pragma mark - DeckViewDelegate

- (void)deckView:(DeckView *)deckView squareView:(SquareView *)squareView clicked:(NSEvent *)mouseDown;
{
    PlayfieldNodeController *playfieldController = _weak_playfieldController;
    if (!playfieldController) {
        assert(0);
        return;
    }
    
    [playfieldController dragUnitFromSquareView:squareView withEvent:mouseDown];
}

#pragma mark - Private

- (void)_setupView;
{
    assert(self.isViewLoaded);
    assert(_deck);
    
    DeckView *view = (DeckView *)self.view;
    view.squareCount = [_deck.slots count];
    
    for (DeckSlot *slot in _deck.slots)
        [self _slotChanged:slot];
}

- (NSImage *)_imageForUnit:(Unit *)unit;
{
    // TODO: Something useful
    if (unit)
        return [NSImage imageNamed:@"Emitter"];
    
    return nil;
}

- (void)_slotChanged:(DeckSlot *)slot;
{
    assert([self isViewLoaded]);
    assert(_deck);
    assert(slot);
    
    DeckView *view = (DeckView *)self.view;
    Unit *unit = slot.unit;
    
    NSUInteger slotIndex = [_deck.slots indexOfObject:slot];
    assert(slotIndex != NSNotFound);

    [view setImage:[self _imageForUnit:unit] forSquareAtIndex:slotIndex];
}

@end
