//
//  Playfield.h
//  Grid
//
//  Created by Timothy J. Wood on 11/25/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <Foundation/NSObject.h>

@class Unit, Game, Square;

@interface Playfield : NSObject

@property(nonatomic,readonly) NSUInteger width;
@property(nonatomic,readonly) NSUInteger height;

- (Square *)squareAtColumn:(NSUInteger)column row:(NSUInteger)row;
- (Unit *)unitAtColumn:(NSUInteger)column row:(NSUInteger)row;
- (void)setUnit:(Unit *)unit atColumn:(NSUInteger)column row:(NSUInteger)row;

- (void)gameTick:(Game *)game;

@end
