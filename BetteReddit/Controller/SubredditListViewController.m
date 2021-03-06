//
//  SubredditListViewController.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "SubredditListViewController.h"
#import "SubredditTableCellView.h"
#import "BRSubreddit.h"
#import "AppDelegate.h"
@import SDWebImage;
@import Masonry;
#import "NSImage+Resize.h"

@interface SubredditListViewController () <NSTableViewDelegate, NSTableViewDataSource>
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSProgressIndicator *indicator;
@property (nonatomic) bool hasSelectedFirst;
@end

@implementation SubredditListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    self.appDelegate = [[NSApplication sharedApplication] delegate];

    self.subscriptionListView.delegate = self;
    self.subscriptionListView.dataSource = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newLoggedInUser)
                                                 name:LOGGED_IN
                                               object:nil];

    self.indicator = [[NSProgressIndicator alloc] init];
    [self.indicator setStyle:NSProgressIndicatorStyleSpinning];
    self.indicator.hidden = true;
    [self.view addSubview:self.indicator];

    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}

-(void)newLoggedInUser{
    dispatch_async(dispatch_get_main_queue(),^(void){
        [self.indicator startAnimation:nil];
        self.indicator.hidden = false;
    });
    [self.appDelegate.currentUser loadSubscriptions:^{
        dispatch_async(dispatch_get_main_queue(),^(void){
            self.indicator.hidden = true;
            [self.indicator stopAnimation:nil];
            [self.subscriptionListView reloadData];
        });
    } withInitial:^(BRSubreddit *initial) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGED_SUBREDDIT object:initial];
    }];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.appDelegate.currentUser ? self.appDelegate.currentUser.subscriptions.count : 0;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    SubredditTableCellView *cell = [tableView makeViewWithIdentifier:@"subscriptionCell" owner:nil];
    cell.label.stringValue = self.appDelegate.currentUser.subscriptions[row].title;
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:self.appDelegate.currentUser.subscriptions[row].iconImageURL] placeholderImage:[NSImage imageNamed:@"DefaultSubredditIcon"]];
    cell.icon.wantsLayer = true;
    cell.icon.layer.cornerRadius = cell.icon.frame.size.width / 2;
    cell.icon.layer.masksToBounds = true;

    //NSLog(@"%@", self.appDelegate.currentUser.subscriptions[row].communityIcon);
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    //first selection is done for us for faster initial launch
    if(!self.hasSelectedFirst){
        self.hasSelectedFirst = true;
        return;
    }
    NSInteger selection = self.subscriptionListView.selectedRow;
    BRSubreddit *current = self.appDelegate.currentUser.subscriptions[selection];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGED_SUBREDDIT object:current];
}

@end
