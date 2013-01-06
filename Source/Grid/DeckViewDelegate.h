//
//  DeckView.h
//  Grid
//
//  Created by Timothy J. Wood on 12/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

@class DeckView, DeckSlotView;

@protocol DeckViewDelegate <NSObject>

- (void)deckView:(DeckView *)deckView deckSlotView:(DeckSlotView *)deckSlotView clicked:(NSEvent *)mouseDown;

@end