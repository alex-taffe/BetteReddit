//
//  CommentViewController.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "CommentViewController.h"
#import "BRPost.h"
#import "BRComment.h"
#import "CommentTableViewCell.h"
@import TSMarkdownParser;

@interface CommentViewController () <NSOutlineViewDelegate, NSOutlineViewDataSource>
@property (strong, nonatomic) BRPost *current;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    self.outlineView.dataSource = self;
    self.outlineView.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentsLoaded:)
                                                 name:COMMENTS_LOADED
                                               object:nil];
}

-(void)commentsLoaded:(NSNotification *)notification{
    self.current = notification.object;
    [self.outlineView reloadData];
    
}

#pragma mark - OutlineView data

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    BRComment *temp = item;
    return temp.children.count > 0;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    if(item == nil)
        return self.current.children.count;
    BRComment *temp = item;
    return temp.children.count;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if(item == nil){
        return self.current.children[index];
    } else {
        BRComment *temp = item;
        return temp.children[index];
    }
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    CommentTableViewCell *cell =  [outlineView makeViewWithIdentifier:@"commentCell" owner:self];

    BRComment *temp = item;

    NSAttributedString *attributedString = [[TSMarkdownParser standardParser] attributedStringFromMarkdown:temp.body];


    cell.commentText.attributedStringValue = attributedString;

    return cell;

}

@end
