//
//  DeckViewController.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "OUIViewController.h"

@class Unit;
@class SquareView;

@class PlayfieldViewController, Deck;

@interface DeckViewController : OUIViewController
@property(nonatomic,weak) PlayfieldViewController *playfieldController;
@property(nonatomic) Deck *deck;

- (Unit *)unitForSquareView:(SquareView *)squareView;

@end
