//
//  BRSubreddit.h
//  BetteRedditKit
//
//  Created by Alex Taffe on 6/2/18.
//


#import <Foundation/Foundation.h>
#import "BRPost.h"

NS_ASSUME_NONNULL_BEGIN

//forward declare the BRPost class here
@class BRPost;

@interface BRSubreddit : NSObject

@property (strong, nonatomic) NSString *title; //example: programming
@property (strong, nonatomic) NSString *internalName; //example: t5_2fwo
@property (strong, nonatomic) NSString *itemID; //example: 2fwo
@property (strong, nonatomic) NSString *endpoint; //example: /r/programming
@property (strong, nonatomic) NSString *iconImageURL; //example: https://styles.redditmedia.com/t5_2fwo/styles/communityIcon_1bqa1ibfp8q11.png
@property (strong, atomic) NSMutableArray<BRPost *> *posts;

-(instancetype)initWithDictionary:(id)dict;



/**
 Loads in the current posts of the subreddit

 @param more If true, the existing posts will not be cleared
 @param onComplete onComplete callback
 */
-(void)loadMoreSubredditPosts:(bool)more onComplete:(void (^)(NSArray * _Nullable newPosts))onComplete;

@end


NS_ASSUME_NONNULL_END
