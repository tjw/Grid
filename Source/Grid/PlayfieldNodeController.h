//
//  PlayfieldNodeController.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "NodeController.h"

@class GridWindowController;
@class Playfield, Unit;
@class DeckSlotView;
@class SquareNode;

@interface PlayfieldNodeController : NodeController

@property(nonatomic,weak) GridWindowController *gridWindowController;
@property(nonatomic,strong) Playfield *playfield;

- (void)dragUnitFromDeckSlotView:(DeckSlotView *)sourceDeckSlotView withEvent:(NSEvent *)mouseDown;

- (void)placeUnit:(Unit *)unit inSquareNode:(SquareNode *)squareNode;

- (void)updateParticleSystems;
- (void)updateInfluence;

@end
