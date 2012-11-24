//
//  DeckViewController.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "DeckViewController.h"

#import "DeckView.h"
#import "PieceView.h"
#import "PieceViewDelegate.h"
#import "OATrackingLoop.h"

@interface NSView ()
- (NSString *)_subtreeDescription;
@end

@interface DeckViewController () <PieceViewDelegate>

@end

@implementation DeckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    return self;
}

- (IBAction)pieceViewClicked:(NSEvent *)event;
{
    NSLog(@"clicked");
}

#pragma mark - NSViewController subclass

- (void)loadView;
{
    DeckView *view = [[DeckView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.nextResponder = self;
    
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];

    for (PieceView *pieceView in view.pieceViews)
        pieceView.delegate = self;
    
    self.view = view;
}

#pragma mark - PieceViewDelegate

- (void)pieceView:(PieceView *)_pieceView clicked:(NSEvent *)mouseDown;
{
    // TODO: Better way for the deck to get this.
    NSView *parentView = self.view.window.contentView;
    
    NSRect originalPieceFrameInParentView = [parentView convertRect:_pieceView.bounds fromView:_pieceView];
    
    OATrackingLoop *trackingLoop = [parentView trackingLoopForMouseDown:mouseDown];
    trackingLoop.disablesAnimation = NO; // Without this, my layer-backed view doesn't update at all.
    
    __block PieceView *draggingView;
    __block NSLayoutConstraint *xConstraint;
    __block NSLayoutConstraint *yConstraint;
    __block NSPoint initialPoint;
    
    __weak OATrackingLoop *_trackingLoop = trackingLoop;
    
    void (^updateDrag)(void) = ^{
        NSSize offset = [_trackingLoop draggedOffsetInView];
        xConstraint.constant = originalPieceFrameInParentView.origin.x + offset.width;
        yConstraint.constant = -(originalPieceFrameInParentView.origin.y + offset.height); // TODO: Why does this need negation?
    };
    
    trackingLoop.hysteresisSize = 4;
    trackingLoop.hysteresisExit = ^(OATrackingLoopExitPoint exitPoint){
        draggingView = [PieceView new];
        draggingView.translatesAutoresizingMaskIntoConstraints = NO;
        [draggingView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
        [draggingView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
        [parentView addSubview:draggingView positioned:NSWindowAbove relativeTo:nil];
        
        draggingView.layer.backgroundColor = [[NSColor yellowColor] CGColor];

        xConstraint = [NSLayoutConstraint constraintWithItem:draggingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        yConstraint = [NSLayoutConstraint constraintWithItem:draggingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        
        initialPoint = [_trackingLoop initialMouseDownPointInView];
        updateDrag();
        
        [parentView addConstraint:xConstraint];
        [parentView addConstraint:yConstraint];
    };
    trackingLoop.up = ^{
        [draggingView removeFromSuperview];
        [parentView removeConstraint:xConstraint];
        [parentView removeConstraint:yConstraint];
    };
    trackingLoop.dragged = ^{
        updateDrag();
    };
    [trackingLoop run];
}

@end
