//
//  PostTableViewCell.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostTableViewCell : NSTableCellView
@property (strong) IBOutlet NSImageView *postImage;
@property (strong) IBOutlet NSTextField *postTitle;

@end

NS_ASSUME_NONNULL_END
