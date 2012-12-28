//
//  PlayfieldViewController.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "OUIViewController.h"

@class GridWindowController;
@class Playfield, Unit;
@class SquareView;

@interface PlayfieldViewController : OUIViewController

@property(nonatomic,weak) GridWindowController *gridWindowController;
@property(nonatomic,strong) Playfield *playfield;

- (void)dragUnitFromSquareView:(SquareView *)sourceSquareView withEvent:(NSEvent *)mouseDown;

- (void)placeUnit:(Unit *)unit inSquareView:(SquareView *)squareView;

@end
