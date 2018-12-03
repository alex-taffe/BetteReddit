//
//  CopyableImageView.h
//  BetteReddit
//
//  Created by Alex Taffe on 12/3/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BRPost.h"

NS_ASSUME_NONNULL_BEGIN

@interface CopyableImageView : NSImageView

@property (strong, nonatomic) BRPost *post;

@end

NS_ASSUME_NONNULL_END
