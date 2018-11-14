//
//  ContentViewController.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "ContentViewController.h"
#import "BRPost.h"
@import SDWebImage;

@interface ContentViewController ()
@property (strong, nonatomic) BRPost *current;
@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedPost:)
                                                 name:@"ChangedPost"
                                               object:nil];
}

-(void)changedPost:(NSNotification *)notification{
    self.current = notification.object;
    if(self.current.url){
        NSRange range = NSMakeRange(0, self.current.url.length);
        NSString *pattern = @"\\.(jpg|png|gif|jpeg)$";

        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *matches = [regex matchesInString:self.current.url options:0 range: range];
        if(matches.count > 0){
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.current.url]];
            return;
        }
    }
    [self.imageView setImage:nil];
}

@end
