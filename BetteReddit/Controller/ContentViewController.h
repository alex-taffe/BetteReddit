//
//  ContentViewController.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import AVKit;

NS_ASSUME_NONNULL_BEGIN

@interface ContentViewController : NSViewController
@property (strong) IBOutlet NSImageView *imageView;
@property (strong) IBOutlet AVPlayerView *videoView;

@end

NS_ASSUME_NONNULL_END
