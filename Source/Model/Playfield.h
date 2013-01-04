//
//  Playfield.h
//  Grid
//
//  Created by Timothy J. Wood on 11/25/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <Foundation/NSObject.h>

@class Unit, Game;

@interface Playfield : NSObject

@property(nonatomic,readonly) NSUInteger width;
@property(nonatomic,readonly) NSUInteger height;

- (Unit *)unitAtColumn:(NSUInteger)column row:(NSUInteger)row;
- (void)setUnit:(Unit *)unit atColumn:(NSUInteger)column row:(NSUInteger)row;

- (void)addUnitObserver:(id)observer atColumn:(NSUInteger)column row:(NSUInteger)row context:(void *)context;
- (void)removeUnitObserver:(id)observer atColumn:(NSUInteger)column row:(NSUInteger)row context:(void *)context;
- (Unit *)unitForObservedObject:(id)observed column:(out NSUInteger *)outColumn row:(out NSUInteger *)outRow;

- (void)gameTick:(Game *)game;

@end
