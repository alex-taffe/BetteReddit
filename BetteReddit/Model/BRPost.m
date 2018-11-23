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
        self.thumbnailURL = dict[@"data"][@"thumbnail"];
        self.url = dict[@"data"][@"url"];
        self.postHint = dict[@"data"][@"post_hint"];
        if([self.postHint isEqualToString:@"rich:video"]){
            self.postPreviewLink = dict[@"data"][@"preview"][@"reddit_video_preview"][@"fallback_url"];
        } else if([self.postHint isEqualToString:@"image"] || [self.url containsString:@"imgur"]){
            self.postPreviewLink = dict[@"data"][@"preview"][@"images"][0][@"source"][@"url"];
        }

        self.score = dict[@"data"][@"score"];

        if(![dict[@"data"][@"likes"] isEqual:[NSNull null]]){
            self.likes = [dict[@"data"][@"likes"] isEqualToNumber:@1] ? 1 : -1;
        } else {
            self.likes = 0;
        }

        self.isSelf = dict[@"data"][@"is_self"];
        self.prefixedSubredditName = dict[@"data"][@"subreddit_name_prefixed"];

        
    }
    return self;
}

-(void)updateVote:(int)likes onComplete:(void (^)(void))onComplete{
    __weak __typeof(self) weakSelf = self;
    [BROAuthHelper performOAuthAction:^(NSString *authToken) {
        NSString  *endpoint = [NSString stringWithFormat:@"/api/vote"];
        [[BRClient sharedInstance] makeRequestWithEndpoint:endpoint withMethod:@"POST" withArguments:@{
            @"id": weakSelf.internalName,
            @"dir": [NSNumber numberWithInt: likes]
        } withToken:authToken success:^(id  _Nonnull result) {
            if(likes == 1){
                weakSelf.score = [NSNumber numberWithInteger:(self.score.integerValue + 1)];
            } else if(likes == 0 && weakSelf.likes == 1){
                weakSelf.score = [NSNumber numberWithInteger:(self.score.integerValue - 1)];
            } else if(likes == 0 && weakSelf.likes == -1){
                weakSelf.score = [NSNumber numberWithInteger:(self.score.integerValue + 1)];
            } else{
                weakSelf.score = [NSNumber numberWithInteger:(self.score.integerValue - 1)];
            }
            weakSelf.likes = likes;

            onComplete();
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"Failed to load post comments: %@", error);
            onComplete();
        }];
    }];
}


-(void)loadPostComments:(void (^)(void))onComplete{
    [self.children removeAllObjects];
    __weak __typeof(self) weakSelf = self;
    [BROAuthHelper performOAuthAction:^(NSString *authToken) {
        NSString  *endpoint = [NSString stringWithFormat:@"%@", weakSelf.permalink];
        [[BRClient sharedInstance] makeRequestWithEndpoint:endpoint withMethod:@"GET" withArguments:nil withToken:authToken success:^(id  _Nonnull result) {
            for(id listing in result){
                id comments = listing[@"data"][@"children"];
                for(id commentDict in comments){
                    if(!commentDict[@"data"][@"body"])
                        continue;
                    BRComment *comment = [[BRComment alloc] initWithDictionary:commentDict];

                    [weakSelf.children addObject:comment];
                }
            }
            onComplete();
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"Failed to load post comments: %@", error);
            onComplete();
        }];
    }];
}

@end
