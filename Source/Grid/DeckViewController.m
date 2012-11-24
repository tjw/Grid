//
//  DeckViewController.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "DeckViewController.h"

#import "DeckView.h"

@interface DeckViewController ()

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
    
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];

    self.view = view;
}

@end
