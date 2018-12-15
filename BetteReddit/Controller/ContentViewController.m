//
//  ContentViewController.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "ContentViewController.h"
#import "BRPost.h"
#import "CopyableImageView.h"
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
    self.progressIndicator.hidden = true;

    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];

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
            self.imageScrollView.magnification = 1.0;
            self.progressIndicator.hidden = false;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.current.postPreviewLink] placeholderImage:nil options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.progressIndicator.doubleValue = receivedSize * 100.0 / expectedSize;
                });
            } completed:^(NSImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.progressIndicator.hidden = true;
                });
            }];
            ((CopyableImageView *) self.imageView).post = self.current;
            return;
        } else if([self.current.postHint isEqualToString:@"link"] ||
                  [self.current.postHint isEqualToString:@"hosted:video"]){
            self.webView.hidden = false;
            self.videoView.hidden = true;
            self.imageView.hidden = true;
            self.imageScrollView.hidden = true;
            self.progressIndicator.hidden = false;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.current.url]]];
            return;
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_CONTENT_VIEW object:nil];
    }
    [self.imageView setImage:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString: @"estimatedProgress"]) {
        self.progressIndicator.doubleValue = self.webView.estimatedProgress * 100;
    } else if([keyPath isEqualToString: @"loading"]){
        if(!self.webView.loading)
            self.progressIndicator.hidden = true;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
