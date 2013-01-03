//
//  SCNView+Extensions.h
//  Grid
//
//  Created by Timothy J. Wood on 1/3/13.
//  Copyright (c) 2013 Cocoatoa. All rights reserved.
//

#import <SceneKit/SCNView.h>

@interface SCNView (Extensions)

- (SCNHitTestResult *)hitTest:(CGPoint)thePoint nodeClass:(Class)nodeClass;

@end
