//
//  CommentTableViewCell.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/16/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BRComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentTableViewCell : NSTableCellView
@property (strong, nonatomic) BRComment *comment;

@property (strong) IBOutlet NSTextField *commentText;
@property (strong) IBOutlet NSTextField *commentScore;
@property (strong) IBOutlet NSButton *upArrow;
@property (strong) IBOutlet NSButton *downArrow;
- (IBAction)upArrowPressed:(id)sender;
- (IBAction)downArrowPressed:(id)sender;



-(void)updateColorScheme;

@end

NS_ASSUME_NONNULL_END
