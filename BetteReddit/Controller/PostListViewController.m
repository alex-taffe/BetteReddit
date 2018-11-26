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
#import "NSString+NumberShortner.h"
@import SDWebImage;

@interface PostListViewController ()<NSTableViewDataSource, NSTableViewDelegate>
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) BRSubreddit *current;
@property (strong, nonatomic) NSNumber *isLoading;
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
                                                 name:CHANGED_SUBREDDIT
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshFeed)
                                                 name:REFRESH_FEED
                                               object:nil];

    id clipView = self.postListView.enclosingScrollView.contentView;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boundsDidChange:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:clipView];

    self.isLoading = [NSNumber numberWithBool:false];

}

-(void)changedSubreddit:(NSNotification *)notification{
    self.current = notification.object;
    [self.current loadMoreSubredditPosts:false onComplete:^(NSArray * _Nullable newPosts){
        dispatch_async(dispatch_get_main_queue(),^(void){
            [self.postListView reloadData];
        });
    }];
}

-(void)refreshFeed{
    [self.current loadMoreSubredditPosts:false onComplete:^(NSArray * _Nullable newPosts){
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
    cell.postParent.stringValue = item.prefixedSubredditName;
    [cell.postImage sd_setImageWithURL:[NSURL URLWithString:item.thumbnailURL]];
    cell.post = item;
    cell.postComments.stringValue = [NSString stringWithFormat:@"%@ comments",[NSString shortenedStringWithInt:item.numComments]];
    [cell updateColorScheme];
    cell.wantsLayer = true;
    return cell;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    if(tableView.numberOfSelectedRows > 0){
        NSInteger selected = self.postListView.selectedRow;
        PostTableViewCell *row = [self.postListView viewAtColumn:0 row:selected makeIfNecessary:false];
        row.isSelected = false;
        row.needsDisplay = true;
    }
    return true;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSInteger selection = self.postListView.selectedRow;
    PostTableViewCell *row = [self.postListView viewAtColumn:0 row:selection makeIfNecessary:false];
    row.isSelected = true;
    row.needsDisplay = true;
    __block BRPost *selectedItem = self.current.posts[selection];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGED_POST object:selectedItem];
    [self.current.posts[selection] loadPostComments:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:COMMENTS_LOADED object:selectedItem];
    }];
}

-(void)boundsDidChange:(NSNotification *)notification{
    if (notification.object == self.postListView.enclosingScrollView.contentView){
        //dont try to load if one is already loading
        @synchronized (self.isLoading) {
            if([self.isLoading boolValue]) return;
        }

        //get the sizes of the scroll
        NSClipView *clipView = notification.object;
        NSRect visibleBounds = clipView.documentVisibleRect;
        NSRect documentBounds = clipView.documentRect;
        CGFloat difference = documentBounds.size.height - visibleBounds.size.height - visibleBounds.origin.y;

        //only load more if there are 700 px left
        if(difference < 700){
            //set the loading to start
            @synchronized (self.isLoading) {
                self.isLoading = [NSNumber numberWithBool:true];
            }
            //start the new items async
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSInteger currentRows = self.current.posts.count;
                //load more items
                [self.current loadMoreSubredditPosts:true onComplete:^(NSArray * _Nullable newPosts) {
                    //if we have more, animate them in
                    if(newPosts){
                        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(currentRows, newPosts.count)];
                        [self.postListView insertRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectFade];
                    }
                    //indicate the loading is done
                    @synchronized (self.isLoading) {
                        self.isLoading = [NSNumber numberWithBool:false];
                    }
                }];
            });
        }
    }
}



@end
