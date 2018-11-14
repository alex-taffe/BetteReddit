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

-(instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if(self){
        self.title = title;
        self.appDelegate = [[NSApplication sharedApplication] delegate];
        self.posts = [[NSMutableArray alloc] init];
    }

    return self;
}

-(void)loadSubredditPosts:(void (^)(void))onComplete{
    [self.posts removeAllObjects];
    [BROAuthHelper performOAuthAction:^(NSString *authToken) {
        NSString  *endpoint = [NSString stringWithFormat:@"r/%@", self.title];
        [[BRClient sharedInstance] makeRequestWithEndpoint:endpoint withArguments:nil withToken:authToken success:^(id  _Nonnull result) {
            id postList = result[@"data"][@"children"];
            for(id postDict in postList){
                BRPost *post = [[BRPost alloc] initWithTitle:postDict[@"data"][@"title"]];
                post.internalName = postDict[@"data"][@"name"];
                post.parent = self;
                post.itemID = postDict[@"data"][@"id"];
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
