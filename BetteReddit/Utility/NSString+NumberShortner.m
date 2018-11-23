//
//  NSString+NumberShortner.m
//  BetteReddit
//
//  Created by Alex Taffe on 11/23/18.
//  Copyright © 2018 Alex Taffe. All rights reserved.
//

#import "NSString+NumberShortner.h"

@implementation NSString (NumberShortner)
+(NSString *)shortenedStringWithInt:(NSInteger)number{
    double result;
    NSString *postFix = @"";
    if(number >= 1000000000){
        result = (double)number / 1000000000;
        postFix = @"b";
    } else if(number >= 1000000){
        result = (double)number / 1000000;
        postFix = @"m";
    } else if(number >= 1000){
        result = (double)number / 1000;
        postFix = @"k";
    } else {
        return [NSString stringWithFormat:@"%li", (long)number];
    }
    return [NSString stringWithFormat:@"%0.1f%@", result, postFix];
}
@end
