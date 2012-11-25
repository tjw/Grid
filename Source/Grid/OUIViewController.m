// Copyright 2012 The Omni Group.  All rights reserved.

#import "OUIViewController.h"

@interface OUIViewController () {
  @private
    struct {
        NSUInteger hasSentViewDidLoad:1;
        NSUInteger viewLoaded:1;
    } _vcFlags;
}

@end

#pragma mark -

@implementation OUIViewController

- (BOOL)isViewLoaded;
{
    return _vcFlags.viewLoaded;
}

- (void)viewDidLoad;
{
    // No-op in the base class
}

#pragma mark -

- (NSView *)view;
{
    NSView *view = [super view];
    
    if (view != nil && !_vcFlags.hasSentViewDidLoad) {
        _vcFlags.hasSentViewDidLoad = YES;
        [self viewDidLoad];
    }
    
    return view;
}

- (void)setView:(NSView *)view;
{
    [super setView:view];
    
    if (view == nil) {
        _vcFlags.viewLoaded = NO;
        _vcFlags.hasSentViewDidLoad = NO;
    }
}

@end
