//  Copyright 2010 The Omni Group. All rights reserved.
//
// $Header: svn+ssh://source.omnigroup.com/Source/svn/Omni/trunk/OmniGroup/Frameworks/OmniAppKit/OATrackingLoop.h 170958 2012-08-03 22:04:57Z tom $

#import <Foundation/NSObject.h>

@class OATrackingLoop;

typedef enum {
    OATrackingLoopExitPointNone,
    OATrackingLoopExitPointVertical,
    OATrackingLoopExitPointHorizontal,
} OATrackingLoopExitPoint;

typedef void (^OATrackingLoopHysteresisExit)(OATrackingLoopExitPoint exitPoint);
typedef void (^OATrackingLoopDragged)(void);
typedef void (^OATrackingLoopLongPress)(void);
typedef void (^OATrackingLoopInsideVisibleRectChanged)(void);
typedef BOOL (^OATrackingLoopShouldAutoscroll)(void);
typedef void (^OATrackingLoopModifierFlagsChanged)(NSUInteger oldFlags);
typedef void (^OATrackingLoopUp)(void);

// Tracks the mouse, starting from a -mouseDown: event.
@interface OATrackingLoop : NSObject

@property(nonatomic,readonly) NSView *view;
@property(nonatomic,readonly) NSEvent *mouseDownEvent;

// Things like dragging explicitly drive animation by user events. We nearly always want timed animations off and want direct user control. Defaults to YES.
@property(nonatomic,assign) BOOL disablesAnimation;

@property(nonatomic,readonly) BOOL insideHysteresisRect;
@property(nonatomic,assign) CGFloat hysteresisSize;
@property(nonatomic,readonly) BOOL insideVisibleRect;

@property(nonatomic,readonly) NSPoint initialMouseDownPointInView;
@property(nonatomic,readonly) NSPoint currentMouseDraggedPointInView;
@property(nonatomic,readonly) NSSize draggedOffsetInView;
- (NSSize)draggedOffsetInView:(NSView *)view;

@property(nonatomic,readonly) NSUInteger modifierFlags;

@property(nonatomic,copy) OATrackingLoopHysteresisExit hysteresisExit;
@property(nonatomic,copy) OATrackingLoopInsideVisibleRectChanged insideVisibleRectChanged;
@property(nonatomic,copy) OATrackingLoopModifierFlagsChanged modifierFlagsChanged;
@property(nonatomic,copy) OATrackingLoopShouldAutoscroll shouldAutoscroll;
@property(nonatomic,copy) OATrackingLoopDragged dragged;
@property(nonatomic,copy) OATrackingLoopLongPress longPress;
@property(nonatomic,copy) OATrackingLoopUp up;

@property(nonatomic,assign) BOOL debug;

- (void)run;
- (void)stop;

@end

@interface NSView (OATrackingLoop)
- (OATrackingLoop *)trackingLoopForMouseDown:(NSEvent *)mouseDownEvent;
@end
