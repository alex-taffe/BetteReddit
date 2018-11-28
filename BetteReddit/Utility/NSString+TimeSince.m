//
//  NSString+TimeSince.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/28/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "NSString+TimeSince.h"

@implementation NSString (TimeSince)

+(NSString *)timeSinceDate:(NSDate *)date{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    if(interval < 60){
        return @"Just now";
    }else if(interval < 3600){
        return [NSString stringWithFormat:@"%.0fm", interval / 60];
    } else if(interval < 86400){
        return [NSString stringWithFormat:@"%.0fh", interval / 60 / 60];
    } else if(interval < 2592000){
        return [NSString stringWithFormat:@"%.0fd", interval / 60 / 60];
    } else if(interval < 31536000){
        return [NSString stringWithFormat:@"%.0fm", interval / 60 / 60 / 24];
    } else{
        return [NSString stringWithFormat:@"%.0fy", interval / 60 / 60 / 24 / 365];
    }
}

@end
