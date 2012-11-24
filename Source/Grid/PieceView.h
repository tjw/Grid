//
//  PieceView.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <AppKit/NSView.h>

@protocol PieceViewDelegate;

@interface PieceView : NSView
@property(nonatomic,weak) id <PieceViewDelegate> delegate;
@end
