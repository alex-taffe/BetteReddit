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

NS_ASSUME_NONNULL_BEGIN

@interface BRPost : NSObject


@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *internalName;
@property (strong, nonatomic) NSString *itemID;
@property (strong, nonatomic) NSMutableArray<BRComment *> *children;
@property (strong, nonatomic) NSString *permalink;
@property (strong, nonatomic, nullable) NSString *thumbnailURL;
@property (strong, nonatomic, nullable) NSString *url;
@property (strong, nonatomic) NSString *postHint;
@property (strong, nonatomic) NSString *postPreviewLink;
@property (strong, nonatomic) NSNumber *score;
@property (strong, nonatomic) NSString *prefixedSubredditName;
@property (nonatomic) int likes;
@property (nonatomic) bool isSelf;

-(instancetype)initWithDictionary:(id)dict;




/**
 Updates the current value of the votes

 @param likes the new like status
 @param onComplete on complete callback
 */
-(void)updateVote:(int)likes onComplete:(void (^)(void))onComplete;

/**
 Retrieve the comments on the post

 @param onComplete on complete callback
 */
-(void)loadPostComments:(void (^)(void))onComplete;

@end

NS_ASSUME_NONNULL_END

#endif
