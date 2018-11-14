//
//  BRUser.m
//  AFNetworking
//
//  Created by Alex Taffe on 6/2/18.
//

#import "BRUser.h"
#import "BRClient.h"

@interface BRUser()
@property (strong, nonatomic, nullable) OIDAuthState *authState;
@end

@implementation BRUser

-(instancetype)init{
    self = [super init];

    if(self){
        self.subscriptions = [[NSMutableArray alloc] init];
    }

    return self;
}

-(instancetype)initWithAccessToken:(OIDAuthState *)authState{
    self = [super init];

    if(self){
        self.authState = authState;
        self.subscriptions = [[NSMutableArray alloc] init];
    }

    return self;
}

-(void)loadUserDetails:(void (^)(void))onComplete{
    [self performOAuthAction:^(NSString *authToken) {
        [[BRClient sharedInstance] makeRequestWithEndpoint:@"api/v1/me" withArguments:nil withToken:authToken success:^(id  _Nonnull result) {
            self.username = result[@"name"];
            onComplete();
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"Failed to load user details: %@", error);
            onComplete();
        }];
    }];
}

-(void)loadSubscriptions:(void (^)(void))onComplete{
    [self.subscriptions removeAllObjects];
    [self performOAuthAction:^(NSString *authToken) {
        __block bool doneLoading = false;
        __block NSString *after = @"";
        while(!doneLoading){
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
                [[BRClient sharedInstance] makeRequestWithEndpoint:@"subreddits/mine/subscriber" withArguments:@{@"limit":@100, @"after" : after} withToken:authToken success:^(id  _Nonnull result) {
                    id subs = result[@"data"][@"children"];
                    for(id sub in subs){
                        BRSubreddit *subReddit = [[BRSubreddit alloc] initWithName:sub[@"data"][@"display_name"]];
                        subReddit.internalName = sub[@"data"][@"name"];
                        [self.subscriptions addObject:subReddit];
                    }
                    after = self.subscriptions.lastObject.internalName;
                    if([subs count] < 100)
                        doneLoading = true;
                    dispatch_semaphore_signal(semaphore);

                } failure:^(NSError * _Nonnull error) {
                    doneLoading = true;
                    NSLog(@"Failed to load user subscriptions: %@", error);
                    dispatch_semaphore_signal(semaphore);
                }];
            });
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }

        [self.subscriptions sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *name1 = ((BRSubreddit *)obj1).name;
            NSString *name2 = ((BRSubreddit *)obj2).name;
            return [name1 compare:name2];
        }];
        onComplete();
    }];
}


-(void)performOAuthAction:(void (^)(NSString *authToken))onComplete{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSString *authorizationToken = nil;

    if(self.authState){
        [self.authState performActionWithFreshTokens:^(NSString * _Nullable accessToken, NSString * _Nullable idToken, NSError * _Nullable error) {
            authorizationToken = accessToken;
            dispatch_semaphore_signal(semaphore);
        }];
    } else {
        dispatch_semaphore_signal(semaphore);
    }

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        onComplete(authorizationToken);
    });
}

@end
