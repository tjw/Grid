//
//  SCNView+Extensions.m
//  Grid
//
//  Created by Timothy J. Wood on 1/3/13.
//  Copyright (c) 2013 Cocoatoa. All rights reserved.
//

#import "SCNView+Extensions.h"

@implementation SCNView (Extensions)

- (SCNHitTestResult *)hitTest:(CGPoint)thePoint nodeClass:(Class)nodeClass;
{
    NSArray *results = [self hitTest:thePoint options:nil];
    for (SCNHitTestResult *result in results) {
        if (!nodeClass || [result.node isKindOfClass:nodeClass])
            return result;
    }
    
    return nil;
}

@end
