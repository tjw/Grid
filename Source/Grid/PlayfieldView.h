//
//  PlayfieldView.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <AppKit/NSView.h>

@class SquareView;

@interface PlayfieldView : NSView

- (void)resizeToWidth:(NSUInteger)width height:(NSUInteger)height;
@property(nonatomic,readonly) NSUInteger width;
@property(nonatomic,readonly) NSUInteger height;

- (SquareView *)squareViewAtColumn:(NSUInteger)column row:(NSUInteger)row;
- (void)getColumn:(out NSUInteger *)outColumn row:(out NSUInteger *)outRow ofSquareView:(SquareView *)squareView;

- (SquareView *)squareViewAtPoint:(NSPoint)point;
- (SquareView *)squareViewNearestPoint:(NSPoint)point;

@end
