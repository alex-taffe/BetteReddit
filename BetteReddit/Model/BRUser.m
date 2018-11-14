//
//  BRUser.m
//  AFNetworking
//
//  Created by Alex Taffe on 6/2/18.
//

#import "BRUser.h"
#import "BROAuthHelper.h"
#import "BRClient.h"

@interface BRUser()

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
    [BROAuthHelper performOAuthAction:^(NSString *authToken) {
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
    [BROAuthHelper performOAuthAction:^(NSString *authToken) {
        __block bool doneLoading = false;
        __block NSString *after = @"";

        //keep requesting subreddits until we're done
        while(!doneLoading){
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

            //run the request asyncrhonously
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
                //get the current round of subscriptions
                [[BRClient sharedInstance] makeRequestWithEndpoint:@"subreddits/mine/subscriber"
                                                     withArguments:@{@"limit":@100, @"after" : after}
                                                         withToken:authToken
                                                           success:^(id  _Nonnull result) {
                    id subs = result[@"data"][@"children"];
                    for(id sub in subs){
                        BRSubreddit *subReddit = [[BRSubreddit alloc] initWithTitle:sub[@"data"][@"display_name"]];
                        subReddit.internalName = sub[@"data"][@"name"];
                        subReddit.itemID = sub[@"data"][@"id"];
                        [self.subscriptions addObject:subReddit];
                    }

                    //set the last item
                    after = self.subscriptions.lastObject.internalName;

                    //if we have less than 100 items returned we're done
                    if([subs count] < 100)
                        doneLoading = true;

                    //let the loop know this round of loading is done
                    dispatch_semaphore_signal(semaphore);

                } failure:^(NSError * _Nonnull error) {
                    doneLoading = true;
                    NSLog(@"Failed to load user subscriptions: %@", error);
                    dispatch_semaphore_signal(semaphore);
                }];
            });
            //wait until  the request is  done and continue on
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }

        //sort the subscriptions in alphabetical order
        [self.subscriptions sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *name1 = ((BRSubreddit *)obj1).title;
            NSString *name2 = ((BRSubreddit *)obj2).title;
            return [name1 compare:name2];
        }];
        //finally done
        onComplete();
    }];
}

@end
