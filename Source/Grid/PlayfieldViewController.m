//
//  PlayfieldViewController.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "PlayfieldViewController.h"

#import "GridWindowController.h"
#import "PlayfieldView.h"
#import "Playfield.h"
#import "OATrackingLoop.h"
#import "SquareView.h"

@interface PlayfieldViewController ()
@end

@implementation PlayfieldViewController

@synthesize gridWindowController = _weak_gridWindowController;

- (void)setPlayfield:(Playfield *)playfield;
{
    if (_playfield == playfield)
        return;
    
    _playfield = playfield;
    
    if ([self isViewLoaded]) {
        PlayfieldView *view = (PlayfieldView *)self.view;
        [view resizeToWidth:_playfield.width height:_playfield.height];
    }
}

#pragma mark - API

- (void)dragUnitFromSquareView:(SquareView *)sourceSquareView withEvent:(NSEvent *)mouseDown;
{
    // TODO: Better way for the deck to get this.
    NSView *parentView = self.view.window.contentView;
    
    NSRect originalSquareFrameInParentView = [parentView convertRect:sourceSquareView.bounds fromView:sourceSquareView];
    
    OATrackingLoop *trackingLoop = [parentView trackingLoopForMouseDown:mouseDown];
    trackingLoop.disablesAnimation = NO; // Without this, my layer-backed view doesn't update at all.
    
    PlayfieldView *playfieldView = (PlayfieldView *)self.view;
    GridWindowController *gridWindowController = _weak_gridWindowController;
    assert(gridWindowController);
    
    __block SquareView *draggingView;
    __block NSLayoutConstraint *xConstraint;
    __block NSLayoutConstraint *yConstraint;
    __block NSPoint initialPoint;
    __block SquareView *destinationSquareView;
    
    __weak OATrackingLoop *_weak_trackingLoop = trackingLoop;
    
    void (^updateDrag)(void) = ^{
        OATrackingLoop *strongTrackingLoop = _weak_trackingLoop;
        if (!strongTrackingLoop) {
            assert(0);
            return;
        }
        NSSize offset = [strongTrackingLoop draggedOffsetInView];
        xConstraint.constant = originalSquareFrameInParentView.origin.x + offset.width;
        yConstraint.constant = -(originalSquareFrameInParentView.origin.y + offset.height); // TODO: Why does this need negation?
        
        NSPoint playfieldPoint = [parentView convertPoint:trackingLoop.currentMouseDraggedPointInView toView:playfieldView];
        SquareView *nearestSquareView = [playfieldView squareViewNearestPoint:playfieldPoint];
        if (nearestSquareView != destinationSquareView) {
            destinationSquareView.isDragDestination = NO;
            destinationSquareView = nearestSquareView;
            destinationSquareView.isDragDestination = YES;
        }
    };
    
    trackingLoop.hysteresisSize = 4;
    trackingLoop.hysteresisExit = ^(OATrackingLoopExitPoint exitPoint){
        OATrackingLoop *strongTrackingLoop = _weak_trackingLoop;
        if (!strongTrackingLoop) {
            assert(0);
            return;
        }
        
        draggingView = [SquareView new];
        draggingView.translatesAutoresizingMaskIntoConstraints = NO;
        [draggingView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
        [draggingView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
        [parentView addSubview:draggingView positioned:NSWindowAbove relativeTo:nil];
        
        draggingView.layer.backgroundColor = [[NSColor yellowColor] CGColor];
        draggingView.layer.contents = sourceSquareView.layer.contents;
        
        xConstraint = [NSLayoutConstraint constraintWithItem:draggingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        yConstraint = [NSLayoutConstraint constraintWithItem:draggingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        
        initialPoint = [strongTrackingLoop initialMouseDownPointInView];
        updateDrag();
        
        [parentView addConstraint:xConstraint];
        [parentView addConstraint:yConstraint];
    };
    trackingLoop.up = ^{
        [gridWindowController userDraggedUnitFromDeckSquareView:sourceSquareView toPlayfieldSquare:destinationSquareView];
        destinationSquareView.isDragDestination = NO;
        [draggingView removeFromSuperview];
        [parentView removeConstraint:xConstraint];
        [parentView removeConstraint:yConstraint];
    };
    trackingLoop.dragged = ^{
        updateDrag();
    };
    [trackingLoop run];
}

- (void)placeUnit:(Unit *)unit inSquareView:(SquareView *)squareView;
{
    PlayfieldView *view = (PlayfieldView *)self.view;
    NSUInteger column, row;
    
    [view getRow:&row column:&column ofSquareView:squareView];
    if (row == NSNotFound || column == NSNotFound) {
        assert(0);
        return;
    }
    if (column >= _playfield.width || row >= _playfield.height) {
        assert(0);
        return;
    }
    
    NSLog(@"dragged to %ld, %ld", column, row);
}

#pragma mark - NSViewController subclass

- (void)loadView;
{
    PlayfieldView *view = [[PlayfieldView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.nextResponder = self;
    
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];

    if (_playfield)
        [view resizeToWidth:_playfield.width height:_playfield.height];
    
    self.view = view;
}

@end
