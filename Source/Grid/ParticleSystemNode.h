//
//  ParticleSystemNode.h
//  Grid
//
//  Created by Timothy J. Wood on 1/5/13.
//  Copyright (c) 2013 Cocoatoa. All rights reserved.
//

#import <SceneKit/SCNNode.h>

@class ParticleSystem;

@interface ParticleSystemNode : SCNNode

// TODO: Alternatively, PlayfieldNodeController could have a map of ParticleSystem -> SCNNode
@property(nonatomic,weak) ParticleSystem *particleSystem;

@end
