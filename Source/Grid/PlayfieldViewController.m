//
//  PlayfieldViewController.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "PlayfieldViewController.h"

#import "PlayfieldView.h"

@interface PlayfieldViewController ()

@end

@implementation PlayfieldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark - NSViewController subclass

- (void)loadView;
{
    PlayfieldView *view = [[PlayfieldView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.view = view;
}

@end
