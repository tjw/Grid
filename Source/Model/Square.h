//
//  Square.h
//  Grid
//
//  Created by Timothy J. Wood on 11/28/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <Foundation/NSObject.h>

@class Game, Unit;

@interface Square : NSObject

- initWithColumn:(NSUInteger)column row:(NSUInteger)row;

@property(nonatomic,readonly) NSUInteger column;
@property(nonatomic,readonly) NSUInteger row;

@property(nonatomic) Unit *unit;
@property(nonatomic) int32_t influence;

- (void)gameTick:(Game *)game;

@end
