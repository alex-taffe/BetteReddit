//
//  BRPost.h
//  BetteReddit
//
//  Created by Alex Taffe on 11/13/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRComment.h"
#import "BRPost.h"

NS_ASSUME_NONNULL_BEGIN

//forward declare BRComment
@class BRComment;

//forward declare BRUser
@class BRUser;

@interface BRPost : NSObject


@property (strong, nonatomic) NSString *title; //example: Nothing to see here, just some valid java code
@property (strong, nonatomic) NSString *internalName; //example: t3_a13lbn
@property (strong, nonatomic) NSString *itemID; //example: a13lbn
@property (strong, atomic) NSMutableArray<BRComment *> *children;
@property (strong, nonatomic) NSString *permalink; //example: /r/programminghorror/comments/a13lbn/nothing_to_see_here_just_some_valid_java_code/
@property (strong, nonatomic, nullable) NSString *thumbnailURL; //example: https://b.thumbs.redditmedia.com/L8CLlEl_dITShDsoUsEV3S1fcRtXnE0qdqwlUZZMtQY.jpg
@property (strong, nonatomic, nullable) NSString *url; //example: https://i.redd.it/jt84i2y8l0121.png
@property (strong, nonatomic) NSString *postHint; //example: image
@property (strong, nonatomic) NSString *postPreviewLink; //example: https://preview.redd.it/jt84i2y8l0121.png?auto=webp&s=59b9e9436686d7465fc7f218d402abc7877b74e8
@property (strong, nonatomic) NSNumber *score; //Total score of the post
@property (strong, nonatomic) NSString *prefixedSubredditName; //example: r/programminghorror
@property (strong, nonatomic) NSDate *dateCreated; //Date of post creation
@property (nonatomic) int likes; //1 if signed in user has liked, 0 if not liked, -1 if disliked
@property (nonatomic) bool isSelf; //posted to current subreddit
@property (nonatomic) int numComments; //number of comments on this post
@property (strong, nonatomic) BRUser *poster;

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

