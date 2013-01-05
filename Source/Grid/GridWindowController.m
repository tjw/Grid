//
//  GridWindowController.m
//  Grid
//
//  Created by Timothy J. Wood on 11/23/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "GridWindowController.h"

#import "PlayfieldNodeController.h"
#import "DeckViewController.h"
#import "Game.h"
#import "Unit.h"
#import "Parameters.h"
#import "SquareView.h"

@interface GridWindowController () <SCNSceneRendererDelegate>
@property(nonatomic) IBOutlet SCNView *sceneView;
@property(nonatomic) IBOutlet DeckViewController *leftDeckViewController;
@property(nonatomic) IBOutlet DeckViewController *rightDeckViewController;

@property(nonatomic,readonly) PlayfieldNodeController *playfieldNodeController;
@end

@implementation GridWindowController

- (id)initWithWindow:(NSWindow *)window
{
    if (!(self = [super initWithWindow:window]))
        return nil;

    _playfieldNodeController = [PlayfieldNodeController new];
    
    _playfieldNodeController.gridWindowController = self;

    return self;
}

- (void)setGame:(Game *)game;
{
    _game = game;
    _playfieldNodeController.playfield = game.playfield;
    _leftDeckViewController.deck = game.leftDeck;
    _rightDeckViewController.deck = game.rightDeck;
}

- (void)userDraggedUnitFromDeckSquareView:(SquareView *)deckSquareView toPlayfieldSquareNode:(SquareNode *)playfieldSquareNode;
{
    // TODO: Check if the square is already filled
    // TODO: Check if the source square can be dragged from (or possibly do this in a 'will' hook)
    // TODO: Remove the unit from the deck
    // TODO: Animations
    
    DeckViewController *deckController = [self deckControllerContainingSquareView:deckSquareView];
    Unit *unit = [deckController unitForSquareView:deckSquareView];
    
    [_playfieldNodeController placeUnit:unit inSquareNode:playfieldSquareNode];
}

#pragma mark - NSWindowController subclass

- (void)windowDidLoad
{
    [super windowDidLoad];

    _leftDeckViewController.playfieldController = _playfieldNodeController;
    _rightDeckViewController.playfieldController = _playfieldNodeController;
    
    _leftDeckViewController.deck = _game.leftDeck;
    _rightDeckViewController.deck = _game.rightDeck;

    NSWindow *window = self.window;
    window.title = @"Grid";
    
    SCNScene *scene = [SCNScene scene];
    
    SCNNode *rootNode = scene.rootNode;
    assert(rootNode);
    
    SCNNode *playfield = _playfieldNodeController.node;
    [rootNode addChildNode:playfield];
    
    SCNCamera *camera = [SCNCamera camera];
    //camera.usesOrthographicProjection = YES;
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, 20*kSquareSize);
    cameraNode.name = @"camera";
    [scene.rootNode addChildNode:cameraNode];
    
    SCNLight * ambientLight = [SCNLight light];
    ambientLight.type = SCNLightTypeAmbient;
    ambientLight.color = [NSColor whiteColor];
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = ambientLight;
    lightNode.name = @"light";
    [scene.rootNode addChildNode:lightNode];

    _sceneView.scene = scene;
    _sceneView.delegate = self;
    
//    _sceneView.autoenablesDefaultLighting = YES;
    NSLog(@"add decks");
#if 0
    NSView *leftDeck = _leftDeckViewController.view;
    [view addSubview:leftDeck];
    
    NSView *rightDeck = _rightDeckViewController.view;
    [view addSubview:rightDeck];
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    NSDictionary *metrics = @{};
    NSDictionary *views = NSDictionaryOfVariableBindings(playfield, leftDeck, rightDeck);
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[playfield]-|" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[playfield]" options:0 metrics:metrics views:views]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:playfield
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:leftDeck
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1 constant:0]];
     [constraints addObject:[NSLayoutConstraint constraintWithItem:playfield
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:rightDeck
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1 constant:0]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[playfield]-[leftDeck]-|" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[playfield]-[rightDeck]-|" options:0 metrics:metrics views:views]];

    [view addConstraints:constraints];
    
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    [view setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];

    [view layout];
    
    leftDeck.layer.backgroundColor = [[NSColor redColor] CGColor];
    rightDeck.layer.backgroundColor = [[NSColor blueColor] CGColor];
#endif
    
    _playfieldNodeController.playfield = _game.playfield;
    
    [_game unpause];
    
    [window center];
}

- (NSString *)windowNibName;
{
    return NSStringFromClass([self class]);
}

#pragma mark - SCNSceneRendererDelegate

- (void)renderer:(id <SCNSceneRenderer>)aRenderer willRenderScene:(SCNScene *)scene atTime:(NSTimeInterval)time;
{
    glEnable(GL_VERTEX_PROGRAM_POINT_SIZE);
    
    [_playfieldNodeController updateParticleSystems];
}

#pragma mark - Private

- (IBAction)exerciseAmbiguity:(id)sender;
{
    NSView *view = self.window.contentView;
    if ([view hasAmbiguousLayout])
        [view exerciseAmbiguityInLayout];
}

- (DeckViewController *)deckControllerContainingSquareView:(SquareView *)squareView;
{
    if ([squareView isDescendantOf:_leftDeckViewController.view])
        return _leftDeckViewController;
    if ([squareView isDescendantOf:_rightDeckViewController.view])
        return _rightDeckViewController;
    
    assert(0); // Shouldn't be asking...
    return nil;
}

@end
