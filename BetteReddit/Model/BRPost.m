//
//  BRPost.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/13/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "BRPost.h"
#import "BRClient.h"
#import "BRComment.h"
#import "BROAuthHelper.h"

@implementation BRPost

-(instancetype)initWithDictionary:(id)dict{
    self = [super init];

    if(self){
        self.children = [[NSMutableArray alloc] init];
        self.title = dict[@"data"][@"title"];
        self.internalName = dict[@"data"][@"name"];
        self.itemID = dict[@"data"][@"id"];
        self.permalink = dict[@"data"][@"permalink"];
    }
    return self;
}

-(void)loadPostComments:(void (^)(void))onComplete{
    [self.children removeAllObjects];
    [BROAuthHelper performOAuthAction:^(NSString *authToken) {
        NSString  *endpoint = [NSString stringWithFormat:@"%@/comments/", self.permalink];
        [[BRClient sharedInstance] makeRequestWithEndpoint:endpoint withArguments:nil withToken:authToken success:^(id  _Nonnull result) {
            for(id listing in result){
                id comments = listing[@"data"][@"children"];
                for(id commentDict in comments){
                    if(!commentDict[@"data"][@"body"])
                        continue;
                    BRComment *comment = [[BRComment alloc] initWithDictionary:commentDict];

                    [self.children addObject:comment];
                }
            }
//            for(id postDict in postList){
//                BRPost *post = [[BRPost alloc] initWithTitle:postDict[@"data"][@"title"]];
//                post.internalName = postDict[@"data"][@"name"];
//                [self.posts addObject:post];
//            }
            onComplete();
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"Failed to load post comments: %@", error);
            onComplete();
        }];
    }];
}

@end
