//
//  PlayfieldNodeController.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "PlayfieldNodeController.h"

#import "GridWindowController.h"
#import "Playfield.h"
#import "OATrackingLoop.h"
#import "Parameters.h"
#import "SquareView.h"
#import "SquareNode.h"
#import "SCNView+Extensions.h"
#import "ParticleSystem.h"
#import "Unit.h"

@interface PlayfieldNodeController () <SCNProgramDelegate>
@end

@implementation PlayfieldNodeController
{
    NSUInteger _width, _height;
    NSArray *_squareNodes;
}

- (void)dealloc;
{
    if (_playfield)
        [self _stopObservingPlayfield:_playfield];
}

@synthesize gridWindowController = _weak_gridWindowController;

- (void)setPlayfield:(Playfield *)playfield;
{
    if (_playfield == playfield)
        return;
    
    if (_playfield)
        [self _stopObservingPlayfield:_playfield];
    
    _playfield = playfield;
    
    if (_playfield)
        [self _startObservingPlayfield:_playfield];

    if (self.nodeLoaded)
        [self _resizeToWidth:_playfield.width height:_playfield.height];
}

#pragma mark - API

- (void)dragUnitFromSquareView:(SquareView *)sourceSquareView withEvent:(NSEvent *)mouseDown;
{
    GridWindowController *wc = _weak_gridWindowController;
    NSView *parentView = wc.window.contentView;
    SCNView *sceneView = wc.sceneView;
        
    NSRect originalSquareFrameInParentView = [parentView convertRect:sourceSquareView.bounds fromView:sourceSquareView];
    
    OATrackingLoop *trackingLoop = [parentView trackingLoopForMouseDown:mouseDown];
    trackingLoop.disablesAnimation = NO; // Without this, my layer-backed view doesn't update at all.
    
    GridWindowController *gridWindowController = _weak_gridWindowController;
    assert(gridWindowController);
    
    __block SquareView *draggingView;
    __block NSLayoutConstraint *xConstraint;
    __block NSLayoutConstraint *yConstraint;
    __block NSPoint initialPoint;
    __block SquareNode *destinationSquareNode;
    
    __weak OATrackingLoop *_weak_trackingLoop = trackingLoop;
    
    void (^updateDrag)(void) = ^{
        OATrackingLoop *strongTrackingLoop = _weak_trackingLoop;
        if (!strongTrackingLoop) {
            assert(0);
            return;
        }
        CGSize offset = [strongTrackingLoop draggedOffsetInView];
        xConstraint.constant = originalSquareFrameInParentView.origin.x + offset.width;
        yConstraint.constant = -(originalSquareFrameInParentView.origin.y + offset.height); // TODO: Why does this need negation?
        
        CGPoint scenePoint = [parentView convertPoint:trackingLoop.currentMouseDraggedPointInView toView:sceneView];
        SCNHitTestResult *hitResult = [sceneView hitTest:scenePoint nodeClass:[SquareNode class]];
//        NSLog(@"hitResult = %@", hitResult);
        SquareNode *nearestSquareNode = (SquareNode *)hitResult.node;
        if (nearestSquareNode != destinationSquareNode) {
//            destinationSquareNode.isDragDestination = NO;
            destinationSquareNode = nearestSquareNode;
//            destinationSquareNode.isDragDestination = YES;
        }
    };
    
    trackingLoop.hysteresisSize = 4;
    trackingLoop.hysteresisExit = ^(OATrackingLoopExitPoint exitPoint){
        OATrackingLoop *strongTrackingLoop = _weak_trackingLoop;
        if (!strongTrackingLoop) {
            assert(0);
            return;
        }
        
        draggingView = [SquareView new];
        draggingView.translatesAutoresizingMaskIntoConstraints = NO;
        [draggingView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
        [draggingView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
        [parentView addSubview:draggingView positioned:NSWindowAbove relativeTo:nil];
        
        draggingView.layer.backgroundColor = [[NSColor yellowColor] CGColor];
        draggingView.layer.contents = sourceSquareView.layer.contents;
        
        xConstraint = [NSLayoutConstraint constraintWithItem:draggingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        yConstraint = [NSLayoutConstraint constraintWithItem:draggingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        
        initialPoint = [strongTrackingLoop initialMouseDownPointInView];
        updateDrag();
        
        [parentView addConstraint:xConstraint];
        [parentView addConstraint:yConstraint];
    };
    trackingLoop.up = ^{
        if (destinationSquareNode) {
            [gridWindowController userDraggedUnitFromDeckSquareView:sourceSquareView toPlayfieldSquareNode:destinationSquareNode];
//            destinationSquareNode.isDragDestination = NO;
        }
        [draggingView removeFromSuperview];
        [parentView removeConstraint:xConstraint];
        [parentView removeConstraint:yConstraint];
    };
    trackingLoop.dragged = ^{
        updateDrag();
    };
    [trackingLoop run];
}

static NSString *_shaderSource(NSString *name)
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:[name stringByDeletingPathExtension] withExtension:[name pathExtension]];
    assert(fileURL);

    NSError *error;
    NSString *source = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    if (!source)
        NSLog(@"Error loading program source %@: %@", name, error);
    return source;
}

- (void)placeUnit:(Unit *)unit inSquareNode:(SquareNode *)squareNode;
{
    NSUInteger column = squareNode.column;
    NSUInteger row = squareNode.row;
    
    if (row == NSNotFound || column == NSNotFound) {
        assert(0);
        return;
    }
    if (column >= _playfield.width || row >= _playfield.height) {
        assert(0);
        return;
    }
    
    [_playfield setUnit:unit atColumn:column row:row];

    // TODO: Should really hear about this via KVO or something so that the game tick can add/remove particle systems.
    ParticleSystem *particleSystem = unit.particleSystem;
    if (particleSystem) {
        SCNNode *node = [SCNNode node];
        node.name = @"particleSystem";
        
        uint16 vertexCount = particleSystem.count;
        SCNGeometrySource *vertexSource = [SCNGeometrySource geometrySourceWithVertices:particleSystem.points count:vertexCount];
        
        // TODO: For point based particle systems, we could have a shared SCNGeometryElement instance.
        NSUInteger vertexElementIndexesSize = vertexCount * sizeof(vertexCount);
        uint16 *vertexElementIndexes = malloc(vertexElementIndexesSize);
        
        for (uint16 vertexIndex = 0; vertexIndex < vertexCount; vertexIndex++)
            vertexElementIndexes[vertexIndex] = vertexIndex;
        
        NSData *vertexElementData = [NSData dataWithBytesNoCopy:vertexElementIndexes length:vertexElementIndexesSize freeWhenDone:YES];
        
        SCNGeometryElement *vertexElements = [SCNGeometryElement geometryElementWithData:vertexElementData primitiveType:SCNGeometryPrimitiveTypePoint primitiveCount:vertexCount bytesPerIndex:sizeof(vertexCount)];
        node.geometry = [SCNGeometry geometryWithSources:@[vertexSource] elements:@[vertexElements]];
                
        // TODO: Share programs
        SCNProgram *program = [SCNProgram program];
        program.delegate = self;
        program.vertexShader = _shaderSource(@"Particle.vsh");
        program.fragmentShader = _shaderSource(@"Particle.fsh");
        
        [program setSemantic:SCNModelViewProjectionTransform forSymbol:@"MVP" options:nil];
        [program setSemantic:SCNGeometrySourceSemanticVertex forSymbol:@"position" options:nil];
        
        SCNMaterial *material = [SCNMaterial material];
        material.program = program;
        node.geometry.materials = @[material];
        
        SquareNode *squareNode = [self _squareNodeAtColumn:column row:row];
        [squareNode addChildNode:node];
    }
}

#pragma mark - NodeController subclass

- (void)loadNode;
{
    SCNNode *node = [SCNNode node];
    
    SCNGeometry *box = [SCNBox boxWithWidth:1 height:1 length:0.05 chamferRadius:0];
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [NSColor blueColor];
    material.lightingModelName = SCNLightingModelConstant;
    box.materials = @[material];
    
    node.geometry = box;
    node.position = SCNVector3Make(0, 0, 0);
    node.name = @"playfield";

    self.node = node;
    
    if (_playfield)
        [self _resizeToWidth:_playfield.width height:_playfield.height];
}

#pragma mark - NSKeyValueObserving

static unsigned PlayfieldContext;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    if (context == &PlayfieldContext) {
        // The object and keypath are private...
        NSUInteger column, row;
        Unit *unit = [_playfield unitForObservedObject:object column:&column row:&row];
        SquareNode *squareNode = [self _squareNodeAtColumn:column row:row];
        
        NSImage *image = [self _imageForUnit:unit];
        
        // TODO: Bad, accessing its layer.
        squareNode.geometry.firstMaterial.diffuse.contents = image;
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - SCNProgramDelegate

//- (BOOL)program:(SCNProgram*)program bindValueForSymbol:(NSString*)symbol atLocation:(unsigned int)location programID:(unsigned int)programID renderer:(SCNRenderer*)renderer;
//{
//    NSLog(@"bind %@", symbol);
//    return NO;
//}
//
//- (void)program:(SCNProgram*)program unbindValueForSymbol:(NSString*)symbol atLocation:(unsigned int)location programID:(unsigned int)programID renderer:(SCNRenderer*)renderer;
//{
//    NSLog(@"unbind %@", symbol);
//}

- (void)program:(SCNProgram *)program handleError:(NSError*)error;
{
    NSLog(@"Program %@ error: %@", program, error);
}

#pragma mark - Private

- (NSImage *)_imageForUnit:(Unit *)unit;
{
    // TODO: Something useful
    if (unit)
        return [NSImage imageNamed:@"Emitter"];
    
    return nil;
}

- (void)_startObservingPlayfield:(Playfield *)playfield;
{
    assert(playfield);
    
    // We assume the width and height cannot change.
    NSUInteger width = playfield.width;
    NSUInteger height = playfield.height;
    
    assert(width > 0);
    assert(height > 0);
    
    for (NSUInteger column = 0; column < width; column++) {
        for (NSUInteger row = 0; row < height; row++) {
            [playfield addUnitObserver:self atColumn:column row:row context:&PlayfieldContext];
        }
    }
}

- (void)_stopObservingPlayfield:(Playfield *)playfield;
{
    assert(playfield);
    
    // We assume the width and height cannot change.
    NSUInteger width = playfield.width;
    NSUInteger height = playfield.height;
    
    assert(width > 0);
    assert(height > 0);
    
    for (NSUInteger column = 0; column < width; column++) {
        for (NSUInteger row = 0; row < height; row++) {
            [playfield removeUnitObserver:self atColumn:column row:row context:&PlayfieldContext];
        }
    }
}

- (void)_resizeToWidth:(NSUInteger)width height:(NSUInteger)height;
{
    assert(self.nodeLoaded);
    assert(width > 0);
    assert(height > 0);
    
    if (_width == width && _height == height)
        return;
    
    SCNNode *playfieldNode = self.node;
    SCNBox *playfieldBox = (SCNBox *)playfieldNode.geometry;
    
    _width = width;
    _height = height;
    
    playfieldBox.width = 2*kPaddingBetweenPlayfieldEdgeAndSquares + _width * kSquareSize + (_width - 1) * kPaddingBetweenSquares;
    playfieldBox.height = 2*kPaddingBetweenPlayfieldEdgeAndSquares + _height * kSquareSize + (_height - 1) * kPaddingBetweenSquares;
    
    CGFloat firstX = -playfieldBox.width/2 + kPaddingBetweenPlayfieldEdgeAndSquares;
    CGFloat firstY = -playfieldBox.height/2 + kPaddingBetweenPlayfieldEdgeAndSquares;
    
    NSMutableArray *squareNodes = [NSMutableArray new];
    
    for (NSUInteger pieceIndexY = 0; pieceIndexY < _height; pieceIndexY++) {
        for (NSUInteger pieceIndexX = 0; pieceIndexX < _width; pieceIndexX++) {
            SquareNode *squareNode = (SquareNode *)[SquareNode node];
            squareNode.column = pieceIndexX;
            squareNode.row = pieceIndexY;
            
            SCNGeometry *box = [SCNBox boxWithWidth:1 height:1 length:0.1 chamferRadius:0];
            SCNMaterial *material = [SCNMaterial material];
            material.diffuse.contents = (pieceIndexX == 0 && pieceIndexY == 0) ? [NSColor redColor]:[NSColor yellowColor];
            material.lightingModelName = SCNLightingModelConstant;
            box.materials = @[material];
            
            squareNode.geometry = box;
            
            SCNVector3 position = SCNVector3Make(firstX + pieceIndexX * (kSquareSize + kPaddingBetweenSquares), firstY + pieceIndexY * (kSquareSize + kPaddingBetweenSquares), 0);
            
            // we are positioning centers
            position.x += kSquareSize/2;
            position.y += kSquareSize/2;
            
            squareNode.position = position;
            
            squareNode.name = @"square";

            [squareNodes addObject:squareNode];
            [playfieldNode addChildNode:squareNode];
        }
    }
    _squareNodes = [squareNodes copy];
}

- (SquareNode *)_squareNodeAtColumn:(NSUInteger)column row:(NSUInteger)row;
{
    assert(column < _width);
    assert(row < _height);
    
    NSUInteger nodeIndex = row * _width + column;
    SquareNode *node = _squareNodes[nodeIndex];
    assert(node.column == column);
    assert(node.row == row);
    
    return node;
}


#if 0

- (void)getColumn:(out NSUInteger *)outColumn row:(out NSUInteger *)outRow ofSquareView:(SquareView *)squareView;
{
    NSUInteger viewIndex = [_squareViews indexOfObject:squareView];
    if (viewIndex == NSNotFound) {
        assert(0); // shouldn't be asking
        *outRow = NSNotFound;
        *outColumn = NSNotFound;
        return;
    }
    
    *outColumn = viewIndex % _width;
    *outRow = viewIndex / _width;
}

// Takes a point in the receivers coordinate system (unlike -hitTest:).
- (SquareView *)squareViewAtPoint:(NSPoint)point;
{
    assert(self.superview);
    NSView *view = [self hitTest:[self convertPoint:point toView:self.superview]];
    
    while (view && view != self) {
        if ([view isKindOfClass:[SquareView class]])
            return (SquareView *)view;
        view = view.superview;
    }
    return nil;
}

// Takes a point in the receivers coordinate system (unlike -hitTest:).
- (SquareView *)squareViewNearestPoint:(NSPoint)point;
{
    SquareView *bestView;
    CGFloat bestDistanceSquared = CGFLOAT_MAX;
    
    // Maybe put this in the callers.
    if (!CGRectContainsPoint(self.bounds, point))
        return nil;
    
    for (SquareView *candidateView in _squareViews) {
        CGRect bounds = candidateView.frame;
        if (CGRectContainsPoint(bounds, point))
            return candidateView; // We assume non-overlapping candidates, so it isn't going to get better than this.
        
        CGPoint center = CGPointMake(NSMidX(bounds), NSMidY(bounds));
        CGSize offset = CGSizeMake(point.x - center.x, point.y - center.y);
        CGFloat distanceSquared = offset.width * offset.width + offset.height * offset.height;
        
        if (distanceSquared < bestDistanceSquared) {
            bestDistanceSquared = distanceSquared;
            bestView = candidateView;
        }
    }
    
    return bestView;
}

#endif

@end
