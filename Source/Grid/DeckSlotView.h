//
//  DeckSlotView.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <AppKit/NSView.h>

@protocol DeckSlotViewDelegate;

@interface DeckSlotView : NSView
@property(nonatomic,weak) id <DeckSlotViewDelegate> delegate;
@property(nonatomic) BOOL isDragDestination;
@end
