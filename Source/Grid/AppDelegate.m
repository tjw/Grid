//
//  AppDelegate.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "AppDelegate.h"

#import "GridWindowController.h"

@implementation AppDelegate
{
    GridWindowController *_windowController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _windowController = [[GridWindowController alloc] init];
    [_windowController showWindow:self];
}

@end
