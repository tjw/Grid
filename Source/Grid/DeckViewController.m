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

- (void)pieceView:(PieceView *)pieceView clicked:(NSEvent *)mouseDown;
{
    OATrackingLoop *trackingLoop = [pieceView trackingLoopForMouseDown:mouseDown];
    trackingLoop.hysteresisSize = 4;
    trackingLoop.hysteresisExit = ^(OATrackingLoopExitPoint exitPoint){
        NSLog(@"exit");
    };
    trackingLoop.up = ^{
        NSLog(@"up");
    };
    [trackingLoop run];
}

@end
