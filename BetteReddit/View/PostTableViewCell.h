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
@property (strong) IBOutlet NSButton *upArrow;
@property (strong) IBOutlet NSButton *downArrow;
- (IBAction)upArrowPressed:(id)sender;
- (IBAction)downArrowPressed:(id)sender;
-(void)updateColorScheme;


@end

NS_ASSUME_NONNULL_END
