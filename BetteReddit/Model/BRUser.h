//
//  BRUser.h
//  AFNetworking
//
//  Created by Alex Taffe on 6/2/18.
//

#import <Foundation/Foundation.h>
#import "BRSubreddit.h"
@import AppAuth;

@interface BRUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSMutableArray<BRSubreddit *> *subscriptions;



-(instancetype)init;

-(instancetype)initWithAccessToken:(OIDAuthState *)authState;


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
