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

@interface SubredditListViewController () <NSTableViewDelegate, NSTableViewDataSource>
@property (strong, nonatomic) AppDelegate *appDelegate;
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
}

-(void)newLoggedInUser{
    [self.appDelegate.currentUser loadSubscriptions:^{
        dispatch_async(dispatch_get_main_queue(),^(void){
            [self.subscriptionListView reloadData];
        });
    }];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.appDelegate.currentUser ? self.appDelegate.currentUser.subscriptions.count : 0;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    SubredditTableCellView *cell = [tableView makeViewWithIdentifier:@"subscriptionCell" owner:nil];
    cell.label.stringValue = self.appDelegate.currentUser.subscriptions[row].title;
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:self.appDelegate.currentUser.subscriptions[row].communityIcon]];
    cell.icon.wantsLayer = true;
    cell.icon.layer.cornerRadius = cell.icon.frame.size.width / 2;
    cell.icon.layer.masksToBounds = true;

    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSInteger selection = self.subscriptionListView.selectedRow;
    BRSubreddit *current = self.appDelegate.currentUser.subscriptions[selection];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGED_SUBREDDIT object:current];
}

@end
