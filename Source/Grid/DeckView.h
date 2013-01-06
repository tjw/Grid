//
//  DeckView.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <AppKit/NSView.h>

@protocol DeckViewDelegate;
@class DeckSlotView;

@interface DeckView : NSView

@property(nonatomic,weak) id <DeckViewDelegate> delegate;

@property(nonatomic) NSUInteger deckSlotCount;
- (void)setImage:(NSImage *)image forDeckSlotAtIndex:(NSUInteger)deckSlotIndex;

- (NSUInteger)indexOfDeckSlotView:(DeckSlotView *)deckSlotView;

@end
