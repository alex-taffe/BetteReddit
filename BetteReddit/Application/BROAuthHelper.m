//
//  BROAuthHelper.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "BROAuthHelper.h"
#import "AppDelegate.h"

@implementation BROAuthHelper

+(void)performOAuthAction:(void (^)(NSString *authToken))onComplete{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSString *authorizationToken = nil;

    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];


    BRUser *current = appDelegate.currentUser;

    //we have auth
    if(current.authState){
        //get a fresh token
        [current.authState performActionWithFreshTokens:^(NSString * _Nullable accessToken, NSString * _Nullable idToken, NSError * _Nullable error) {
            authorizationToken = accessToken;
            dispatch_semaphore_signal(semaphore);
        }];
    } else {
        dispatch_semaphore_signal(semaphore);
    }

    //let the client know they're good to make a request
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        onComplete(authorizationToken);
    });
}

@end
