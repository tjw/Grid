//
//  PlayfieldViewController.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "PlayfieldViewController.h"

#import "PlayfieldView.h"
#import "Playfield.h"
#import "OATrackingLoop.h"
#import "SquareView.h"

@interface PlayfieldViewController ()
@end

@implementation PlayfieldViewController

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

- (void)dragUnitFromSquareView:(SquareView *)squareView withEvent:(NSEvent *)mouseDown;
{
    // TODO: Better way for the deck to get this.
    NSView *parentView = self.view.window.contentView;
    
    NSRect originalSquareFrameInParentView = [parentView convertRect:squareView.bounds fromView:squareView];
    
    OATrackingLoop *trackingLoop = [parentView trackingLoopForMouseDown:mouseDown];
    trackingLoop.disablesAnimation = NO; // Without this, my layer-backed view doesn't update at all.
    
    PlayfieldView *playfieldView = (PlayfieldView *)self.view;
    
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
        destinationSquareView = [playfieldView squareViewNearestPoint:playfieldPoint];
        NSLog(@"playfieldPoint %@ destinationSquareView %@", NSStringFromPoint(playfieldPoint), destinationSquareView);
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
        draggingView.layer.contents = squareView.layer.contents;
        
        xConstraint = [NSLayoutConstraint constraintWithItem:draggingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        yConstraint = [NSLayoutConstraint constraintWithItem:draggingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        
        initialPoint = [strongTrackingLoop initialMouseDownPointInView];
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
