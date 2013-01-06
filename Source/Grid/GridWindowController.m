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
#import "DeckSlotView.h"
#import "Player.h"

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
    _leftDeckViewController.deck = game.leftPlayer.deck;
    _rightDeckViewController.deck = game.rightPlayer.deck;
}

- (void)userDraggedUnitFromDeckSlotView:(DeckSlotView *)deckSlotView toPlayfieldSquareNode:(SquareNode *)playfieldSquareNode;
{
    // TODO: Check if the square is already filled
    // TODO: Check if the source square can be dragged from (or possibly do this in a 'will' hook)
    // TODO: Remove the unit from the deck
    // TODO: Animations
    
    DeckViewController *deckController = [self deckControllerContainingDeckSlotView:deckSlotView];
    Unit *unit = [deckController unitForDeckSlotView:deckSlotView];
    
    [_playfieldNodeController placeUnit:unit inSquareNode:playfieldSquareNode];
}

#pragma mark - NSWindowController subclass

- (void)windowDidLoad
{
    [super windowDidLoad];

    _leftDeckViewController.playfieldController = _playfieldNodeController;
    _rightDeckViewController.playfieldController = _playfieldNodeController;
    
    _leftDeckViewController.deck = _game.leftPlayer.deck;
    _rightDeckViewController.deck = _game.rightPlayer.deck;

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
    //_sceneView.autoenablesDefaultLighting = YES;
    
    _leftDeckViewController.view.layer.backgroundColor = [[NSColor redColor] CGColor];
    _rightDeckViewController.view.layer.backgroundColor = [[NSColor blueColor] CGColor];
    
    // Ensure these views are above the scene
    [_leftDeckViewController.view.superview addSubview:_leftDeckViewController.view positioned:NSWindowAbove relativeTo:_sceneView];
    [_rightDeckViewController.view.superview addSubview:_rightDeckViewController.view positioned:NSWindowAbove relativeTo:_sceneView];
    
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

- (DeckViewController *)deckControllerContainingDeckSlotView:(DeckSlotView *)deckSlotView;
{
    if ([deckSlotView isDescendantOf:_leftDeckViewController.view])
        return _leftDeckViewController;
    if ([deckSlotView isDescendantOf:_rightDeckViewController.view])
        return _rightDeckViewController;
    
    assert(0); // Shouldn't be asking...
    return nil;
}

@end
