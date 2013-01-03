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
@class SquareNode;

@interface GridWindowController : NSWindowController

@property(nonatomic,readonly) SCNView *sceneView;

@property(nonatomic,strong) Game *game;

- (void)userDraggedUnitFromDeckSquareView:(SquareView *)deckSquareView toPlayfieldSquareNode:(SquareNode *)playfieldSquareNode;

@end
