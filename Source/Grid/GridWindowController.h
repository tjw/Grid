//
//  GridWindowController.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <AppKit/NSWindowController.h>

@class Game;
@class SquareView;

@interface GridWindowController : NSWindowController

@property(nonatomic,strong) Game *game;

- (void)userDraggedUnitFromDeckSquareView:(SquareView *)deckSquareView toPlayfieldSquare:(SquareView *)playfieldSquareView;

@end
