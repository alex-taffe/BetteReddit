//
//  BRComment.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/14/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "BRComment.h"

@implementation BRComment

-(instancetype)initWithTitle:(NSString *)title{
    self = [super init];

    if(self){
        self.children = [[NSMutableArray alloc] init];
        self.title = title;
    }
    return self;
}

@end
