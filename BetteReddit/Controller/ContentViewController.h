//
//  ContentViewController.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import AVKit;
@import WebKit;

NS_ASSUME_NONNULL_BEGIN

@interface ContentViewController : NSViewController
@property (strong) IBOutlet NSImageView *imageView;
@property (strong) IBOutlet NSScrollView *imageScrollView;
@property (strong) IBOutlet AVPlayerView *videoView;
@property (strong) IBOutlet WKWebView *webView;
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;

@end

NS_ASSUME_NONNULL_END
