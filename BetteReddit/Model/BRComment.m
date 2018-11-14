//
//  BRComment.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "BRComment.h"

@implementation BRComment

-(instancetype)initWithDictionary:(id)dict{
    self = [super init];

    if(self){
        self.children = [[NSMutableArray alloc] init];
        self.body = dict[@"data"][@"body"];
        self.itemID = dict[@"data"][@"id"];
    }
    return self;
}

@end
