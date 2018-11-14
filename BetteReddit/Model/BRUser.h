//
//  BRUser.h
//  AFNetworking
//
//  Created by Alex Taffe on 6/2/18.
//

#ifndef __BRUSER_H
#define __BRUSER_H

#import <Foundation/Foundation.h>
#import "BRSubreddit.h"
@import AppAuth;

@interface BRUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSMutableArray<BRSubreddit *> *subscriptions;
@property (strong, nonatomic, nullable) OIDAuthState *authState;


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
#endif
