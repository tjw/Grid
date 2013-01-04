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
@property(nonatomic) Unit *unit;

- (void)gameTick:(Game *)game;

@end
