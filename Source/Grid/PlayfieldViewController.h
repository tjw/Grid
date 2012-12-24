//
//  PlayfieldViewController.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "OUIViewController.h"

@class Playfield;
@class SquareView;

@interface PlayfieldViewController : OUIViewController

@property(nonatomic,strong) Playfield *playfield;

- (void)dragUnitFromSquareView:(SquareView *)squareView withEvent:(NSEvent *)mouseDown;

@end
