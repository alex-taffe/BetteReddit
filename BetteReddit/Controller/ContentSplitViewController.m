//
//  ContentSplitViewController.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "ContentSplitViewController.h"

@interface ContentSplitViewController ()

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
}

-(void)hideContentView{
    ((NSView *)self.splitViewItems[0]).hidden = true;
    [self.splitView setPosition:0 ofDividerAtIndex:0];
    NSLog(@"Hide Content View");
}

-(void)showContentView{
    NSLog(@"Show Content View");
}

@end
