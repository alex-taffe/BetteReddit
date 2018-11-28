//
//  BRUser.h
//  AFNetworking
//
//  Created by Alex Taffe on 6/2/18.
//

#import <Foundation/Foundation.h>
#import "BRSubreddit.h"
@import AppAuth;

//Forward declare subreddit
@class BRSubreddit;

@interface BRUser : NSObject

@property (strong, nonatomic) NSString *username; //example: curlyhair
@property (strong, nonatomic) NSString *internalName; //example: t2_7qmzk
@property (strong, atomic) NSMutableArray<BRSubreddit *> *subscriptions;
@property (strong, nonatomic, nullable) OIDAuthState *authState;


-(instancetype)init;

-(instancetype)initWithAccessToken:(OIDAuthState *)authState;

-(instancetype)initWithUsername:(NSString *)username withInternalName:(NSString *)internalName;


/**
 Loads in all of the user details

 @param onComplete completion callback
 */
-(void)loadUserDetails:(void (^)(void))onComplete;


/**
 Loads in all of the subreddits the user is subscribed to

 @param onComplete completion callback
 */
-(void)loadSubscriptions:(void (^)(void))onComplete;

@end

