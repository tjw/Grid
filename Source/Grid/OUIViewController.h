// Copyright 2012 Omni Development, Inc.  All rights reserved.
//
// $Header: svn+ssh://source.omnigroup.com/Source/svn/Omni/trunk/OmniGroup/Frameworks/OmniUI/Mac/OUIViewController.h 174915 2012-11-01 04:28:52Z correia $

#import <AppKit/NSViewController.h>

@interface OUIViewController : NSViewController

@property (nonatomic, readonly, getter=isViewLoaded) BOOL viewLoaded;
- (void)viewDidLoad;

@end
