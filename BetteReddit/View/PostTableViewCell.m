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
    
}
@end
