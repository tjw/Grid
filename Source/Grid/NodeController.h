//
//  NodeController.h
//  Grid
//
//  Created by Timothy J. Wood on 1/2/13.
//  Copyright (c) 2013 Cocoatoa. All rights reserved.
//

#import <Foundation/NSObject.h>

@class SCNNode;

@interface NodeController : NSObject

@property(nonatomic) SCNNode *node;

- (void)loadNode;
@property (nonatomic, readonly, getter=isNodeLoaded) BOOL nodeLoaded;
- (void)nodeDidLoad;

@end
