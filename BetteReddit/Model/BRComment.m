//
//  BRComment.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "BRComment.h"
#import "BROAuthHelper.h"
#import "BRClient.h"

@implementation BRComment

-(instancetype)initWithDictionary:(id)dict{
    self = [super init];

    if(self){
        self.children = [[NSMutableArray alloc] init];
        self.body = dict[@"data"][@"body_html"];
        self.itemID = dict[@"data"][@"id"];
        self.score = dict[@"data"][@"score"];
        self.internalName = dict[@"data"][@"name"];
        if(![dict[@"data"][@"likes"] isEqual:[NSNull null]]){
            self.likes = [dict[@"data"][@"likes"] isEqualToNumber:@1] ? 1 : -1;
        } else {
            self.likes = 0;
        }

        if([dict[@"data"][@"replies"] isKindOfClass:[NSDictionary class]]){
            for(id reply in dict[@"data"][@"replies"][@"data"][@"children"]){
                BRComment *child = [[BRComment alloc] initWithDictionary:reply];
                if(child.body != nil)
                    [self.children addObject:child];
            }
        }
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    if(self == object)
        return true;

    if (![object isKindOfClass:[self class]]) {
        return false;
    }

    return [self.itemID isEqualToString:((BRComment *)object).itemID];

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

@end
