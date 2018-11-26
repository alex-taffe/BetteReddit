//
//  PostTableViewCell.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BRPost.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostTableViewCell : NSTableCellView
@property (strong, nonatomic) BRPost *post;

@property (strong) IBOutlet NSImageView *postImage;
@property (strong) IBOutlet NSTextField *postTitle;
@property (strong) IBOutlet NSTextField *postLikes;
@property (strong) IBOutlet NSTextField *postParent;
@property (strong) IBOutlet NSTextField *postComments;
@property (strong) IBOutlet NSButton *upArrow;
@property (strong) IBOutlet NSButton *downArrow;
@property bool isSelected;
- (IBAction)upArrowPressed:(id)sender;
- (IBAction)downArrowPressed:(id)sender;


/**
 Updates the color scheme of the up arrow, down arrow, and post likes label based
 on the number of likes in the current post
 */
-(void)updateColorScheme;


@end

NS_ASSUME_NONNULL_END
