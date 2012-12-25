//
//  SquareView.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <AppKit/NSView.h>

@protocol SquareViewDelegate;

@interface SquareView : NSView
@property(nonatomic,weak) id <SquareViewDelegate> delegate;
@property(nonatomic) BOOL isDragDestination;
@end
