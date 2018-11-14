//
//  BRSubreddit.m
//  BetteRedditKit
//
//  Created by Alex Taffe on 6/2/18.
//

#import "BRSubreddit.h"
#import "AppDelegate.h"
#import "BRUser.h"
#import "BRClient.h"

@interface BRSubreddit()
@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation BRSubreddit

-(instancetype)initWithName:(NSString *)name{
    self = [super init];
    if(self){
        self.name = name;
        self.appDelegate = [[NSApplication sharedApplication] delegate];
        self.posts = [[NSMutableArray alloc] init];
    }

    return self;
}

-(void)loadSubredditPosts:(void (^)(void))onComplete{
    [self.posts removeAllObjects];
    [self performOAuthAction:^(NSString *authToken) {
        NSString  *endpoint = [NSString stringWithFormat:@"r/%@", self.name];
        [[BRClient sharedInstance] makeRequestWithEndpoint:endpoint withArguments:nil withToken:authToken success:^(id  _Nonnull result) {
            id postList = result[@"data"][@"children"];
            for(id postDict in postList){
                BRPost *post = [[BRPost alloc] init];
                post.title = postDict[@"data"][@"title"];
                [self.posts addObject:post];
            }
            onComplete();
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"Failed to load user details: %@", error);
            onComplete();
        }];
    }];
}

-(void)performOAuthAction:(void (^)(NSString *authToken))onComplete{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSString *authorizationToken = nil;

    BRUser *current = self.appDelegate.currentUser;

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
