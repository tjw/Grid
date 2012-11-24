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

- (void)windowDidLoad
{
    [super windowDidLoad];

    NSWindow *window = self.window;
    window.title = @"Grid";
    
    NSView *view = window.contentView;
    [view addSubview:_playfieldViewController.view];
    [view addSubview:_leftDeckViewController.view];
    [view addSubview:_rightDeckViewController.view];
}

#pragma mark - NSWindowController subclass

- (NSString *)windowNibName;
{
    return NSStringFromClass([self class]);
}

@end
