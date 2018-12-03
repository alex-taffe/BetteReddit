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
                                                 name:CHANGED_POST
                                               object:nil];
    self.videoView.hidden = true;
    self.webView.hidden = true;

}

-(void)changedPost:(NSNotification *)notification{
    self.current = notification.object;
    if(!self.current.isSelf){
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_CONTENT_VIEW object:nil];
        if([self.current.postHint isEqualToString:@"rich:video"] ||
           [self.current.postHint isEqualToString:@"video"] ||
           [self.current.postHint isEqualToString:@"hosted:video"]){
            self.webView.hidden = true;
            self.videoView.hidden = false;
            self.imageView.hidden = true;
            self.imageScrollView.hidden = true;
            self.videoView.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.current.postPreviewLink]];
            [self.videoView.player play];
            return;
        } else if([self.current.postHint isEqualToString:@"image"] ||
                  ([self.current.postHint isEqualToString:@"link"] && [self.current.url containsString:@"imgur"] && ![self.current.url containsString:@"gifv"])){
            self.webView.hidden = true;
            self.videoView.hidden = true;
            self.imageView.hidden = false;
            self.imageScrollView.hidden = false;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.current.postPreviewLink]];
            return;
        } else if([self.current.postHint isEqualToString:@"link"] ||
                  [self.current.postHint isEqualToString:@"hosted:video"]){
            self.webView.hidden = false;
            self.videoView.hidden = true;
            self.imageView.hidden = true;
            self.imageScrollView.hidden = true;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.current.url]]];
            return;
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_CONTENT_VIEW object:nil];
    }
    [self.imageView setImage:nil];
}
- (IBAction)rightClickImage:(id)sender {

    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];

    [theMenu insertItemWithTitle:@"Beep" action:@selector(beep:) keyEquivalent:@"" atIndex:0];

    [theMenu insertItemWithTitle:@"Honk" action:@selector(honk:) keyEquivalent:@"" atIndex:1];

    [NSMenu popUpContextMenu:theMenu withEvent:nil forView:self.view];
}

@end
