//
//  ContentSplitViewController.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "ContentSplitViewController.h"

@interface ContentSplitViewController ()
@property (nonatomic) CGFloat previousPosition;
@end

@implementation ContentSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideContentView)
                                                 name:HIDE_CONTENT_VIEW
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showContentView)
                                                 name:SHOW_CONTENT_VIEW
                                               object:nil];
    self.previousPosition = self.splitViewItems[0].viewController.view.frame.size.height;
}

-(void)hideContentView{
    self.previousPosition = self.splitViewItems[0].viewController.view.frame.size.height;
    [self.splitView setPosition:0 ofDividerAtIndex:0];
}

-(void)showContentView{
    [self.splitView setPosition:self.previousPosition ofDividerAtIndex:0];
}

@end
