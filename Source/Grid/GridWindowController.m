//
//  GridWindowController.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "GridWindowController.h"

#import "PlayfieldViewController.h"
#import "DeckViewController.h"
#import "Game.h"

@interface GridWindowController ()
@property(nonatomic,readonly) PlayfieldViewController *playfieldViewController;
@property(nonatomic,readonly) DeckViewController *leftDeckViewController;
@property(nonatomic,readonly) DeckViewController *rightDeckViewController;
@end

@implementation GridWindowController

- (id)initWithWindow:(NSWindow *)window
{
    if (!(self = [super initWithWindow:window]))
        return nil;

    _playfieldViewController = [PlayfieldViewController new];
    _leftDeckViewController = [DeckViewController new];
    _rightDeckViewController = [DeckViewController new];
    
    return self;
}

- (void)setGame:(Game *)game;
{
    _game = game;
    _playfieldViewController.playfield = game.playfield;
    
    _leftDeckViewController.deck = game.leftDeck;
    _leftDeckViewController.playfieldController = _playfieldViewController;
    
    _rightDeckViewController.deck = game.rightDeck;
    _rightDeckViewController.playfieldController = _playfieldViewController;
}

#pragma mark - NSWindowController subclass

- (void)windowDidLoad
{
    [super windowDidLoad];

    NSWindow *window = self.window;
    window.title = @"Grid";
    
    NSView *view = window.contentView;
    NSCAssert(view.layer, @"Should start with a layer");
    view.layer.backgroundColor = [[NSColor blackColor] CGColor];
    
    NSView *playfield = _playfieldViewController.view;
    [view addSubview:playfield];
    
    NSView *leftDeck = _leftDeckViewController.view;
    [view addSubview:leftDeck];
    
    NSView *rightDeck = _rightDeckViewController.view;
    [view addSubview:rightDeck];
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    NSDictionary *metrics = @{};
    NSDictionary *views = NSDictionaryOfVariableBindings(playfield, leftDeck, rightDeck);
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[playfield]-|" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[playfield]" options:0 metrics:metrics views:views]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:playfield
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:leftDeck
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1 constant:0]];
     [constraints addObject:[NSLayoutConstraint constraintWithItem:playfield
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:rightDeck
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1 constant:0]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[playfield]-[leftDeck]-|" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[playfield]-[rightDeck]-|" options:0 metrics:metrics views:views]];

    [view addConstraints:constraints];
    
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];

    [view layout];
    
    leftDeck.layer.backgroundColor = [[NSColor redColor] CGColor];
    rightDeck.layer.backgroundColor = [[NSColor blueColor] CGColor];
    
    _playfieldViewController.playfield = _game.playfield;
    
    [window center];
}

- (NSString *)windowNibName;
{
    return NSStringFromClass([self class]);
}

#pragma mark - Private

- (IBAction)exerciseAmbiguity:(id)sender;
{
    NSView *view = self.window.contentView;
    if ([view hasAmbiguousLayout])
        [view exerciseAmbiguityInLayout];
}

@end
