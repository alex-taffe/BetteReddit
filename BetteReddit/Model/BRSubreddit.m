//
//  BRSubreddit.m
//  BetteRedditKit
//
//  Created by Alex Taffe on 6/2/18.
//

#import "BRSubreddit.h"

@implementation BRSubreddit

-(instancetype)initWithName:(NSString *)name{
    self = [super init];
    if(self){
        self.name = name;
    }

    return self;
}

@end
