//
//  Unit.h
//  Grid
//
//  Created by Timothy J. Wood on 11/28/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import <Foundation/NSObject.h>

@class Player;

@interface Unit : NSObject
@property(nonatomic) Player *owner;
@end
