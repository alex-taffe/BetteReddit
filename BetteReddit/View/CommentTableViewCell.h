//
//  CommentTableViewCell.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/16/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentTableViewCell : NSTableCellView
@property (strong) IBOutlet NSTextField *commentText;

@end

NS_ASSUME_NONNULL_END
