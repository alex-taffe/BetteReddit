//
//  PostListViewController.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "PostListViewController.h"
#import "AppDelegate.h"
#import "BRSubreddit.h"
#import "PostTableViewCell.h"
@import SDWebImage;

@interface PostListViewController ()<NSTableViewDataSource, NSTableViewDelegate>
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) BRSubreddit *current;
@end

@implementation PostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    self.appDelegate = [[NSApplication sharedApplication] delegate];

    self.postListView.delegate = self;
    self.postListView.dataSource = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedSubreddit:)
                                                 name:@"ChangedSubreddit"
                                               object:nil];
}

-(void)changedSubreddit:(NSNotification *)notification{
    self.current = notification.object;
    [self.current loadSubredditPosts:^{
        dispatch_async(dispatch_get_main_queue(),^(void){
            [self.postListView reloadData];
        });
    }];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.current ? self.current.posts.count : 0;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    PostTableViewCell *cell = [tableView makeViewWithIdentifier:@"postCell" owner:nil];
    BRPost *item = self.current.posts[row];
    cell.postTitle.stringValue = item.title;
    [cell.postImage sd_setImageWithURL:[NSURL URLWithString:item.thumbnailURL]];

    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSInteger selection = self.postListView.selectedRow;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedPost" object:self.current.posts[selection]];
}

@end
