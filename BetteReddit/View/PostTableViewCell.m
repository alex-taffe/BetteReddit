//
//  PostTableViewCell.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "PostTableViewCell.h"
#import "NSString+NumberShortner.h"

@implementation PostTableViewCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if(self.isSelected)
        self.layer.backgroundColor = NSColor.selectedTextBackgroundColor.CGColor;
    else
        self.layer.backgroundColor = NSColor.controlBackgroundColor.CGColor;
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


    self.upArrow.contentTintColor = upColor;
    self.downArrow.contentTintColor = downColor;

    self.postLikes.textColor = labelColor;
    self.postLikes.stringValue = [NSString shortenedStringWithInt:[self.post.score integerValue]];
}
@end
