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

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *internalName;
@property (strong, nonatomic) NSString *itemID;
@property (strong, nonatomic) NSString *endpoint;
@property (strong, nonatomic) NSString *communityIcon;
@property (strong, nonatomic) NSMutableArray<BRPost *> *posts;

-(instancetype)initWithDictionary:(id)dict;



/**
 Loads in the current posts of the subreddit

 @param more If true, the existing posts will not be cleared
 @param onComplete onComplete callback
 */
-(void)loadMoreSubredditPosts:(bool)more onComplete:(void (^)(NSArray * _Nullable newPosts))onComplete;

@end


NS_ASSUME_NONNULL_END
