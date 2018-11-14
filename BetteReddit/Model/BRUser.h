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

-(void)loadUserDetails:(void (^)(void))onComplete;

-(void)loadSubscriptions:(void (^)(void))onComplete;

@end
