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
@property(nonatomic) Playfield *playfield;
@end

@implementation PlayfieldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    _playfield = [[Playfield alloc] init];
    
    return self;
}

#pragma mark - NSViewController subclass

- (void)loadView;
{
    PlayfieldView *view = [[PlayfieldView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.nextResponder = self;
    
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];

    [view resizeToWidth:_playfield.width height:_playfield.height];
    
    self.view = view;
}

@end
