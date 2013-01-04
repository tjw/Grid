//
//  Game.m
//  Grid
//
//  Created by Timothy J. Wood on 11/25/12.
//  Copyright (c) 2012 Cocoatoa. All rights reserved.
//

#import "Game.h"

#import "Playfield.h"
#import "Deck.h"
#import "Parameters.h"

@implementation Game
{
    NSUInteger _pauseCounter;
    NSTimer *_tickTimer;
}

- init;
{
    if (!(self = [super init]))
        return nil;
    
    _pauseCounter = 1; // Start paused
    _playfield = [[Playfield alloc] init];
    _leftDeck = [[Deck alloc] init];
    _rightDeck = [[Deck alloc] init];
    
    return self;
}

- (void)pause;
{
    assert([NSThread isMainThread]);
    
    if (_pauseCounter == 0) {
        assert(_tickTimer != nil);
        [_tickTimer invalidate];
        _tickTimer = nil;
    } else {
        assert(_tickTimer == nil);
    }
    _pauseCounter++;
}

- (void)unpause;
{
    assert([NSThread isMainThread]);
    assert(_pauseCounter > 0);
    
    if (_pauseCounter == 0) {
        assert(_tickTimer != nil);
    } else {
        assert(_tickTimer == nil);
        _pauseCounter--;
        if (_pauseCounter == 0) {
            _tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/kGameTicksPerSecond target:self selector:@selector(_tickTimerFired:) userInfo:nil repeats:YES];
        }
    }
}

- (BOOL)isPaused;
{
    assert([NSThread isMainThread]);

    if (_pauseCounter > 0) {
        assert(_tickTimer == nil);
        return YES;
    } else {
        assert(_tickTimer != nil);
        return NO;
    }
}

#pragma mark - Private

- (void)_tickTimerFired:(NSTimer *)timer;
{
    [_leftDeck gameTick:self];
    [_rightDeck gameTick:self];
    [_playfield gameTick:self];
}

@end
