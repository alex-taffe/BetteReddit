//
//  CommentTableViewCell.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/16/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "NSString+NumberShortner.h"

@implementation CommentTableViewCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (IBAction)upArrowPressed:(id)sender {
    if(self.comment.likes == 1)
        [self.comment updateVote:0 onComplete:^{
            [self updateColorScheme];
        }];
    else
        [self.comment updateVote:1 onComplete:^{
            [self updateColorScheme];
        }];
}

- (IBAction)downArrowPressed:(id)sender {
    if(self.comment.likes == -1)
        [self.comment updateVote:0 onComplete:^{
            [self updateColorScheme];
        }];
    else
        [self.comment updateVote:-1 onComplete:^{
            [self updateColorScheme];
        }];
}

-(void)updateColorScheme{
    NSColor *upColor;
    NSColor *downColor;
    NSColor *labelColor;

    if(self.comment.likes == 1){
        upColor =  [NSColor colorNamed:@"UpvoteColor"];
        downColor = NSColor.textColor;
        labelColor = [NSColor colorNamed:@"UpvoteColor"];
    } else if(self.comment.likes == -1){
        upColor =  NSColor.textColor;
        downColor = [NSColor colorNamed:@"DownvoteColor"];
        labelColor = [NSColor colorNamed:@"DownvoteColor"];
    } else {
        upColor = NSColor.textColor;
        downColor = NSColor.textColor;
        labelColor = NSColor.textColor;
    }


    self.upArrow.contentTintColor = upColor;
    self.downArrow.contentTintColor = downColor;

    self.commentScore.textColor = labelColor;
    self.commentScore.stringValue = [NSString shortenedStringWithInt:[self.comment.score integerValue]];
}

@end
