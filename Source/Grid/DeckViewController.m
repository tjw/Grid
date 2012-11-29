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
#import "SquareViewDelegate.h"
#import "OATrackingLoop.h"

@interface NSView ()
- (NSString *)_subtreeDescription;
@end

@interface DeckViewController () <SquareViewDelegate>

@end

@implementation DeckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    return self;
}

#pragma mark - NSViewController subclass

- (void)loadView;
{
    DeckView *view = [[DeckView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.nextResponder = self;
    
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];

    for (SquareView *squareView in view.squareViews) {
        squareView.delegate = self;
        squareView.wantsLayer = YES; // otherwise we don't get our layer until later
        squareView.layer.contents = [NSImage imageNamed:@"Emitter"];
    }
    
    self.view = view;
}

#pragma mark - SquareViewDelegate

- (void)squareView:(SquareView *)_squareView clicked:(NSEvent *)mouseDown;
{
    // TODO: Better way for the deck to get this.
    NSView *parentView = self.view.window.contentView;
    
    NSRect originalSquareFrameInParentView = [parentView convertRect:_squareView.bounds fromView:_squareView];
    
    OATrackingLoop *trackingLoop = [parentView trackingLoopForMouseDown:mouseDown];
    trackingLoop.disablesAnimation = NO; // Without this, my layer-backed view doesn't update at all.
    
    __block SquareView *draggingView;
    __block NSLayoutConstraint *xConstraint;
    __block NSLayoutConstraint *yConstraint;
    __block NSPoint initialPoint;
    
    __weak OATrackingLoop *_trackingLoop = trackingLoop;
    
    void (^updateDrag)(void) = ^{
        NSSize offset = [_trackingLoop draggedOffsetInView];
        xConstraint.constant = originalSquareFrameInParentView.origin.x + offset.width;
        yConstraint.constant = -(originalSquareFrameInParentView.origin.y + offset.height); // TODO: Why does this need negation?
    };
    
    trackingLoop.hysteresisSize = 4;
    trackingLoop.hysteresisExit = ^(OATrackingLoopExitPoint exitPoint){
        draggingView = [SquareView new];
        draggingView.translatesAutoresizingMaskIntoConstraints = NO;
        [draggingView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
        [draggingView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
        [parentView addSubview:draggingView positioned:NSWindowAbove relativeTo:nil];
        
        draggingView.layer.backgroundColor = [[NSColor yellowColor] CGColor];
        draggingView.layer.contents = _squareView.layer.contents;

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
