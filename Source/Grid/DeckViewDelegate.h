//
//  DeckView.h
//  Grid
//
//  Created by Timothy J. Wood on 12/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

@protocol DeckViewDelegate <NSObject>

- (void)deckView:(DeckView *)deckView squareView:(SquareView *)squareView clicked:(NSEvent *)mouseDown;

@end