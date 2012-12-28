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
#import "PlayfieldViewController.h"
#import "Square.h"

@interface NSView ()
- (NSString *)_subtreeDescription;
@end

@interface DeckViewController () <DeckViewDelegate>

@end

@implementation DeckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    return self;
}

@synthesize playfieldController = _weak_playfieldController;

- (void)setDeck:(Deck *)deck;
{
    if (_deck == deck)
        return;
    
    _deck = deck;
    
    if (self.isViewLoaded)
        [self _updateDeck];
}

- (Unit *)unitForSquareView:(SquareView *)squareView;
{
    DeckView *deckView = (DeckView *)self.view;
    NSUInteger squareIndex = [deckView indexOfSquareView:squareView];
    if (squareIndex == NSNotFound) {
        assert(0); // shouldn't be asking
        return nil;
    }
    
    if (squareIndex >= [_deck.squares count]) {
        assert(0); // shouldn't be asking
        return nil;
    }
    
    Square *square = _deck.squares[squareIndex];
    Unit *unit = square.unit;
    
    assert(unit);
    return unit;
}

#pragma mark - NSViewController subclass

- (void)loadView;
{
    DeckView *view = [[DeckView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.nextResponder = self;
    
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];

    view.delegate = self;
    
    
    self.view = view;
    assert(self.isViewLoaded);
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    [self _updateDeck];
}

#pragma mark - DeckViewDelegate

- (void)deckView:(DeckView *)deckView squareView:(SquareView *)squareView clicked:(NSEvent *)mouseDown;
{
    PlayfieldViewController *playfieldController = _weak_playfieldController;
    if (!playfieldController) {
        assert(0);
        return;
    }
    
    [playfieldController dragUnitFromSquareView:squareView withEvent:mouseDown];
}

#pragma mark - Private

- (void)_updateDeck;
{
    assert([self isViewLoaded]);
    assert(_deck);
    
    DeckView *view = (DeckView *)self.view;
    
    view.squareCount = [_deck.squares count];
    for (NSUInteger idx = 0; idx < view.squareCount; idx++)
        [view setImage:[NSImage imageNamed:@"Emitter"] forSquareAtIndex:idx];
}

@end
