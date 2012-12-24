//
//  DeckView.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <AppKit/NSView.h>

@protocol DeckViewDelegate;

@interface DeckView : NSView

@property(nonatomic,weak) id <DeckViewDelegate> delegate;

@property(nonatomic) NSUInteger squareCount;
- (void)setImage:(NSImage *)image forSquareAtIndex:(NSUInteger)squareIndex;

@end
