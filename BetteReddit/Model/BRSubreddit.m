//
//  BRSubreddit.m
//  BetteRedditKit
//
//  Created by Alex Taffe on 6/2/18.
//

#import "BRSubreddit.h"
#import "AppDelegate.h"
#import "BROAuthHelper.h"
#import "BRUser.h"
#import "BRClient.h"

@interface BRSubreddit()
@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation BRSubreddit

-(instancetype)init{
    self = [super init];
    if(self){
        self.posts = [[NSMutableArray alloc] init];
    }

    return self;
}

-(instancetype)initWithDictionary:(id)dict{
    self = [super init];
    if(self){
        //self.title = title;
        self.appDelegate = [[NSApplication sharedApplication] delegate];
        self.posts = [[NSMutableArray alloc] init];
        self.title = dict[@"data"][@"display_name"];
        self.internalName = dict[@"data"][@"name"];
        self.itemID = dict[@"data"][@"id"];
        self.endpoint = dict[@"data"][@"url"];
    }

    return self;
}

-(void)loadSubredditPosts:(void (^)(void))onComplete{
    [self.posts removeAllObjects];
    [BROAuthHelper performOAuthAction:^(NSString *authToken) {
        [[BRClient sharedInstance] makeRequestWithEndpoint:self.endpoint withMethod:@"GET" withArguments:nil withToken:authToken success:^(id  _Nonnull result) {
            id postList = result[@"data"][@"children"];
            for(id postDict in postList){
                BRPost *post = [[BRPost alloc] initWithDictionary:postDict];
                [self.posts addObject:post];
            }
            onComplete();
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"Failed to load user details: %@", error);
            onComplete();
        }];
    }];
}



@end
