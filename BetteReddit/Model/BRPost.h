//
//  BRPost.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/13/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#ifndef __BRPOST_H
#define __BRPOST_H

#import <Foundation/Foundation.h>
#import "BRComment.h"
#import "BRSubreddit.h"

NS_ASSUME_NONNULL_BEGIN

//Forward declare the BRSubreddit class here
@class BRSubreddit;

@interface BRPost : NSObject


@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *internalName;
@property (strong, nonatomic) NSString *itemID;
@property (strong, nonatomic) NSMutableArray<BRComment *> *children;
@property (weak, nonatomic) BRSubreddit *parent;

-(instancetype)initWithTitle:(NSString *)title;

-(void)loadPostComments:(void (^)(void))onComplete;

@end

NS_ASSUME_NONNULL_END

#endif
