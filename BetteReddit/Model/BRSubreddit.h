//
//  BRSubreddit.h
//  BetteRedditKit
//
//  Created by Alex Taffe on 6/2/18.
//

#import <Foundation/Foundation.h>
#import "BRPost.h"

NS_ASSUME_NONNULL_BEGIN

@interface BRSubreddit : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *internalName;

@property (strong, nonatomic) NSMutableArray<BRPost *> *posts;

-(instancetype)initWithName:(NSString *)name;

/**
 Loads in the current posts of the subreddit

 @param onComplete completion callback
 */
-(void)loadSubredditPosts:(void (^)(void))onComplete;

@end


NS_ASSUME_NONNULL_END
