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
@import Masonry;

@interface CommentViewController () <NSOutlineViewDelegate, NSOutlineViewDataSource>
@property (strong) IBOutlet NSTextField *postTitle;
@property (strong, nonatomic) BRPost *current;
@property (strong, nonatomic) NSProgressIndicator* indicator;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    self.outlineView.dataSource = self;
    self.outlineView.delegate = self;
    self.outlineView.intercellSpacing = NSMakeSize(0, 0);

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startCommentsLoading:)
                                                 name:COMMENTS_START_LOAD
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentsLoaded:)
                                                 name:COMMENTS_LOADED
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedPost:)
                                                 name:CHANGED_POST
                                               object:nil];

    self.indicator = [[NSProgressIndicator alloc] init];
    [self.indicator setStyle:NSProgressIndicatorStyleSpinning];
    self.indicator.hidden = true;
    [self.view addSubview:self.indicator];
    //[indicator startAnimation:nil];

    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];

}

-(void)startCommentsLoading:(NSNotification *)notification{
    [self.indicator startAnimation:nil];
    self.indicator.hidden = false;
    [self.outlineView reloadData];
}

-(void)commentsLoaded:(NSNotification *)notification{
    [self.indicator stopAnimation:nil];
    self.indicator.hidden = true;
    [self.outlineView reloadData];
    
}

-(void)changedPost:(NSNotification *)notification{
    self.current = notification.object;
    self.postTitle.stringValue = self.current.title;
}

#pragma mark - OutlineView data

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    BRComment *temp = item;
    return temp.children.count > 0;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    if(item == nil){
        @synchronized (self.current) {
            return self.current.children.count * 2;
        }
    }

    BRComment *temp = item;
    return temp.children.count;
}

- (void)outlineView:(NSOutlineView *)outlineView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row{
    BRComment *comment = [outlineView itemAtRow:row];
    @synchronized (self.current) {
        if(row % 2 == 0 || (comment != nil && ![self.current.children containsObject:comment]))
            rowView.backgroundColor = NSColor.unemphasizedSelectedTextBackgroundColor;
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if(item == nil){
        if(index % 2 == 0){
            @synchronized (self.current) {
                if(self.current.children.count <= index / 2)
                    return nil;
                return self.current.children[index / 2];
            }
        } else {
            return nil;
        }

    } else {
        BRComment *temp = item;
        return temp.children[index];
    }
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    if(item == nil){
        NSTableCellView *cell = [outlineView makeViewWithIdentifier:@"commentSpaceCell" owner:self];

        return cell;
    } else {
        CommentTableViewCell *cell = [outlineView makeViewWithIdentifier:@"commentCell" owner:self];

        BRComment *temp = item;
        NSData *data = [temp.body dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithHTML:data
                                                                     documentAttributes:nil];

        NSRange range = NSMakeRange(0, attributedString.length - 1);
        [attributedString addAttributes:@{
                                          NSFontAttributeName: [NSFont systemFontOfSize:12],
                                          NSForegroundColorAttributeName: NSColor.textColor
                                          } range:range];


        //NSAttributedString *attributedString = [[TSMarkdownParser standardParser] attributedStringFromMarkdown:temp.body];

        cell.commentText.attributedStringValue = attributedString;
        cell.comment = temp;
        [cell updateColorScheme];

        return cell;
    }


}

@end
