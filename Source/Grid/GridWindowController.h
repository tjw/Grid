//
//  GridWindowController.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <AppKit/NSWindowController.h>

@class Game;

@interface GridWindowController : NSWindowController

@property(nonatomic,strong) Game *game;

@end
