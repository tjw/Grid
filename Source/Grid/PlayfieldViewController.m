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
