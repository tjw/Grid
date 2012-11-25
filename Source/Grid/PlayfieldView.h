//
//  PlayfieldView.h
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PlayfieldView : NSView

- (void)resizeToWidth:(NSUInteger)width height:(NSUInteger)height;
@property(nonatomic,readonly) NSUInteger width;
@property(nonatomic,readonly) NSUInteger height;

@end
