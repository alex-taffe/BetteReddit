//
//  PostTableViewCell.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (IBAction)upArrowPressed:(id)sender {
    if(self.post.likes == 1)
        [self.post updateVote:0 onComplete:^{
            [self updateColorScheme];
        }];
    else
        [self.post updateVote:1 onComplete:^{
            [self updateColorScheme];
        }];
}

- (IBAction)downArrowPressed:(id)sender {
    if(self.post.likes == -1)
        [self.post updateVote:0 onComplete:^{
            [self updateColorScheme];
        }];
    else
        [self.post updateVote:-1 onComplete:^{
            [self updateColorScheme];
        }];
}

-(void)updateColorScheme{
    NSColor *upColor;
    NSColor *downColor;
    NSColor *labelColor;

    if(self.post.likes == 1){
        upColor =  [NSColor colorNamed:@"UpvoteColor"];
        downColor = NSColor.textColor;
        labelColor = [NSColor colorNamed:@"UpvoteColor"];
    } else if(self.post.likes == -1){
        upColor =  NSColor.textColor;
        downColor = [NSColor colorNamed:@"DownvoteColor"];
        labelColor = [NSColor colorNamed:@"DownvoteColor"];
    } else {
        upColor = NSColor.textColor;
        downColor = NSColor.textColor;
        labelColor = NSColor.textColor;
    }

    NSMutableAttributedString *upTitle = [[NSMutableAttributedString alloc] initWithAttributedString:self.upArrow.attributedTitle];
    NSMutableAttributedString *downTitle = [[NSMutableAttributedString alloc] initWithAttributedString:self.downArrow.attributedTitle];
    NSRange upRange = NSMakeRange(0, upTitle.length);
    NSRange downRange = NSMakeRange(0, downTitle.length);

    [upTitle addAttribute:NSForegroundColorAttributeName value:upColor range:upRange];
    [downTitle addAttribute:NSForegroundColorAttributeName value:downColor range:downRange];

    self.upArrow.attributedTitle = upTitle;
    self.downArrow.attributedTitle = downTitle;

    self.postLikes.textColor = labelColor;
    self.postLikes.stringValue = [NSString stringWithFormat:@"%@", self.post.score];
}
@end
