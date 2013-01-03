//
//  NodeController.m
//  Grid
//
//  Created by Timothy J. Wood on 1/2/13.
//  Copyright (c) 2013 Cocoatoa. All rights reserved.
//

#import "NodeController.h"

@implementation NodeController

- (void)loadNode;
{
    assert(0); // Must be subclassed.
}

- (BOOL)isNodeLoaded;
{
    return _node != nil;
}

- (void)nodeDidLoad;
{
    // No-op in the base class
}

@synthesize node = _node;
- (SCNNode *)node;
{
    if (!_node) {
        [self loadNode];
        assert(_node);
        
        [self nodeDidLoad];
    }
    
    return _node;
}

@end
